#!/usr/bin/env bash

###############################################################################
# Copyright 2017 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
BOLD='\033[1m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'

function info() {
  (echo >&2 -e "[${WHITE}${BOLD}INFO${NO_COLOR}] $*")
}

function error() {
  (echo >&2 -e "[${RED}ERROR${NO_COLOR}] $*")
}

function warning() {
  (echo >&2 -e "${YELLOW}[WARNING] $*${NO_COLOR}")
}

function ok() {
  (echo >&2 -e "[${GREEN}${BOLD} OK ${NO_COLOR}] $*")
}

APOLLO_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${APOLLO_ROOT_DIR}/scripts/apollo_base_neo.sh"

#DOCKER_REPO="iregistry.baidu-int.com/apolloauto/apollo-dev"
DOCKER_REPO_CPU="registry.baidubce.com/apollo/apollo-env-cpu"
DOCKER_REPO_GPU="registry.baidubce.com/apollo/apollo-env-gpu"
MAP_REPO="apolloauto/apollo"
DEV_CONTAINER="apollo_neo_dev_${USER}"
DEV_INSIDE="in-dev-docker"

SUPPORTED_ARCHS=(x86_64)
TARGET_ARCH="$(uname -m)"
HOST_ARCH="$(uname -m)"

VERSION_X86_64_CPU="0.0.2-beta"
VERSION_X86_64_GPU="0.0.2-beta"

USE_GPU_IMAGE=0
#VERSION_X86_64="dev-x86_64-18.04-20220803_1505"
USER_VERSION_OPT=

USE_GPU_HOST=0
DOCKER_RUN_CMD="docker run"
FAST_MODE="no"

USE_LOCAL_IMAGE=0
CUSTOM_DIST=
USER_AGREED="no"

VOLUME_VERSION="latest"
SHM_SIZE="2G"

HOST_OS="$(uname -s)"

RESTART=0
CAN_RESTART=0

MAP_VOLUMES_CONF=
OTHER_VOLUMES_CONF=

DEFAULT_MAPS=(
    sunnyvale_big_loop
    sunnyvale_loop
    sunnyvale_with_two_offices
    san_mateo
)

DEFAULT_TEST_MAPS=(
    sunnyvale_big_loop
    sunnyvale_loop
)

function show_usage() {
    cat <<EOF
Usage: $0 [options] ...
OPTIONS:
    -h, --help             Display this help and exit.
    -f, --force            force to restart the container.
    -f, --fast             Fast mode without pulling all map volumes.
    -g, --geo <us|cn|none> Pull docker image from geolocation specific registry mirror.
    -t, --tag <TAG>        Specify docker image with tag <TAG> to start.
    --shm-size <bytes>     Size of /dev/shm . Passed directly to "docker run"
    --gpu                  Use gpu image instead of cpu image.
    stop                   Stop all running Apollo containers.
EOF
}

function parse_arguments() {
    local custom_version=""
    local shm_size=""
    local geo=""

    while [ $# -gt 0 ]; do
        local opt="$1"
        shift
        case "${opt}" in
            -t | --tag)
                if [ -n "${custom_version}" ]; then
                    warning "Multiple option ${opt} specified, only the last one will take effect."
                fi
                custom_version="$1"
                shift
                optarg_check_for_opt "${opt}" "${custom_version}"
                ;;

            -f | --force)
                RESTART=1
                ;;

            -l | --local)
                USE_LOCAL_IMAGE=1
                ;;

            -f | --fast)
                FAST_MODE="yes"
                ;;

            --gpu)
                USE_GPU_IMAGE=1
                ;;

            -h | --help)
                show_usage
                exit 1
                ;;

            --shm-size)
                shm_size="$1"
                shift
                optarg_check_for_opt "${opt}" "${shm_size}"
                ;;

            stop)
                info "Now, stop all Apollo containers created by ${USER} ..."
                stop_all_apollo_containers "-f"
                exit 0
                ;;

            *)
                warning "Unknown option: ${opt}"
                exit 2
                ;;
        esac
    done # End while loop

    [[ -n "${custom_version}" ]] && USER_VERSION_OPT="${custom_version}"
    [[ -n "${shm_size}" ]] && SHM_SIZE="${shm_size}"
}

function determine_dev_image() {
    local version="$1"
    local repo=
    # If no custom version specified
    if [[ -z "${version}" ]]; then
        if [[ "${TARGET_ARCH}" == "x86_64" ]]; then
            if [[ "${USE_GPU_HOST}" -eq 1 ]]; then
                if [[ "${USE_GPU_IMAGE}" -eq 1 ]]; then
                    repo="${DOCKER_REPO_GPU}"
                    version="${VERSION_X86_64_GPU}"
                else
                    repo="${DOCKER_REPO_CPU}"
                    version="${VERSION_X86_64_CPU}"
                    DOCKER_RUN_CMD="docker run"
                fi
            else
                repo="${DOCKER_REPO_CPU}"
                version="${VERSION_X86_64_CPU}"
                DOCKER_RUN_CMD="docker run" 
            fi
        else
            error "Logic can't reach here! Please report this issue to Apollo@GitHub."
            exit 3
        fi
    fi
    DEV_IMAGE="${repo}:${version}"
}


function check_host_environment() {
    if [[ "${HOST_OS}" != "Linux" ]]; then
        warning "Running Apollo dev container on ${HOST_OS} is UNTESTED, exiting..."
        exit 1
    fi
}

function check_target_arch() {
    local arch="${TARGET_ARCH}"
    for ent in "${SUPPORTED_ARCHS[@]}"; do
        if [[ "${ent}" == "${TARGET_ARCH}" ]]; then
            return 0
        fi
    done
    error "Unsupported target architecture: ${TARGET_ARCH}."
    exit 1
}

function setup_device() {
  if [ "$(uname -s)" != "Linux" ]; then
    info "Not on Linux, skip mapping devices."
    return
  fi
  if [[ "${HOST_ARCH}" == "x86_64" ]]; then
    setup_device_for_amd64
  fi
}

function setup_device_for_amd64() {
  # setup CAN device
  local NUM_PORTS=8
  for i in $(seq 0 $((${NUM_PORTS} - 1))); do
    if [[ -e /dev/can${i} ]]; then
      continue
    elif [[ -e /dev/zynq_can${i} ]]; then
      # soft link if sensorbox exist
      sudo ln -s /dev/zynq_can${i} /dev/can${i}
    else
      break
      # sudo mknod --mode=a+rw /dev/can${i} c 52 ${i}
    fi
  done

  # Check Nvidia device
  if [[ ! -e /dev/nvidia0 ]]; then
    warning "No device named /dev/nvidia0"
  fi
  if [[ ! -e /dev/nvidiactl ]]; then
    warning "No device named /dev/nvidiactl"
  fi
  if [[ ! -e /dev/nvidia-uvm ]]; then
    warning "No device named /dev/nvidia-uvm"
  fi
  if [[ ! -e /dev/nvidia-uvm-tools ]]; then
    warning "No device named /dev/nvidia-uvm-tools"
  fi
  if [[ ! -e /dev/nvidia-modeset ]]; then
    warning "No device named /dev/nvidia-modeset"
  fi
}

function setup_devices_and_mount_local_volumes() {
    local __retval="$1"
    local user=${USER}
    local home_path
    local src_path

    if [ ${user} == "root" ]; then 
        home_path="/root"
    else
        home_path="/home/${user}"
    fi
    
    src_path="${home_path}/.apollo"
    echo ${src_path}
    if [ -d ${src_path} ]; then
        volumes="${volumes} -v ${src_path}:${src_path}"
    fi

    setup_device

    local os_release="$(lsb_release -rs)"
    case "${os_release}" in
        16.04)
            warning "[Deprecated] Support for Ubuntu 16.04 will be removed" \
                "in the near future. Please upgrade to ubuntu 18.04+."
            volumes="${volumes} -v /dev:/dev"
            ;;
        18.04 | 20.04 | *)
            volumes="${volumes} -v /dev:/dev"
            ;;
    esac
    # local tegra_dir="/usr/lib/aarch64-linux-gnu/tegra"
    # if [[ "${TARGET_ARCH}" == "aarch64" && -d "${tegra_dir}" ]]; then
    #    volumes="${volumes} -v ${tegra_dir}:${tegra_dir}:ro"
    # fi
    volumes="${volumes} -v /media:/media \
                        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
                        -v /etc/localtime:/etc/localtime:ro \
                        -v /usr/src:/usr/src \
                        -v /lib/modules:/lib/modules"
    volumes="$(tr -s " " <<<"${volumes}")"
    eval "${__retval}='${volumes}'"
}

function docker_restart_volume() {
    local volume="$1"
    local image="$2"
    local path="$3"
    info "Create volume ${volume} from image: ${image}"
    docker_pull "${image}"
    docker volume rm "${volume}" >/dev/null 2>&1
    docker run -v "${volume}":"${path}" --rm "${image}" true
}

function restart_map_volume_if_needed() {
    local map_name="$1"
    local map_version="$2"
    local map_volume="apollo_map_volume-${map_name}_${USER}"
    local map_path="/apollo/modules/map/data/${map_name}"

    if [[ ${MAP_VOLUMES_CONF} == *"${map_volume}"* ]]; then
        info "Map ${map_name} has already been included."
    else
        local map_image=
        if [ "${TARGET_ARCH}" = "aarch64" ]; then
            map_image="${MAP_REPO}:map_volume-${map_name}-${TARGET_ARCH}-${map_version}"
        else
            map_image="${MAP_REPO}:map_volume-${map_name}-${map_version}"
        fi
        info "Load map ${map_name} from image: ${map_image}"

        docker_restart_volume "${map_volume}" "${map_image}" "${map_path}"
        MAP_VOLUMES_CONF="${MAP_VOLUMES_CONF} --volume ${map_volume}:${map_path}"
    fi
}

function mount_map_volumes() {
    info "Starting mounting map volumes ..."
    if [ -n "${USER_SPECIFIED_MAPS}" ]; then
        for map_name in ${USER_SPECIFIED_MAPS}; do
            restart_map_volume_if_needed "${map_name}" "${VOLUME_VERSION}"
        done
    fi

    if [[ "$FAST_MODE" == "no" ]]; then
        for map_name in ${DEFAULT_MAPS[@]}; do
            restart_map_volume_if_needed "${map_name}" "${VOLUME_VERSION}"
        done
    else
        for map_name in ${DEFAULT_TEST_MAPS[@]}; do
            restart_map_volume_if_needed "${map_name}" "${VOLUME_VERSION}"
        done
    fi
}

function mount_other_volumes() {
    info "Mount other volumes ..."
    local volume_conf=

    # AUDIO
    local audio_volume="apollo_audio_volume_${USER}"
    local audio_image="${MAP_REPO}:data_volume-audio_model-${TARGET_ARCH}-latest"
    local audio_path="/apollo/modules/audio/data/"
    docker_restart_volume "${audio_volume}" "${audio_image}" "${audio_path}"
    volume_conf="${volume_conf} --volume ${audio_volume}:${audio_path}"

    # YOLOV4
    local yolov4_volume="apollo_yolov4_volume_${USER}"
    local yolov4_image="${MAP_REPO}:yolov4_volume-emergency_detection_model-${TARGET_ARCH}-latest"
    local yolov4_path="/apollo/modules/perception/camera/lib/obstacle/detector/yolov4/model/"
    docker_restart_volume "${yolov4_volume}" "${yolov4_image}" "${yolov4_path}"
    volume_conf="${volume_conf} --volume ${yolov4_volume}:${yolov4_path}"

    # FASTER_RCNN
    local faster_rcnn_volume="apollo_faster_rcnn_volume_${USER}"
    local faster_rcnn_image="${MAP_REPO}:faster_rcnn_volume-traffic_light_detection_model-${TARGET_ARCH}-latest"
    local faster_rcnn_path="/apollo/modules/perception/production/data/perception/camera/models/traffic_light_detection/faster_rcnn_model"
    docker_restart_volume "${faster_rcnn_volume}" "${faster_rcnn_image}" "${faster_rcnn_path}"
    volume_conf="${volume_conf} --volume ${faster_rcnn_volume}:${faster_rcnn_path}"

    # SMOKE
    if [[ "${TARGET_ARCH}" == "x86_64" ]]; then
        local smoke_volume="apollo_smoke_volume_${USER}"
        local smoke_image="${MAP_REPO}:smoke_volume-yolo_obstacle_detection_model-${TARGET_ARCH}-latest"
        local smoke_path="/apollo/modules/perception/production/data/perception/camera/models/yolo_obstacle_detector/smoke_libtorch_model"
        docker_restart_volume "${smoke_volume}" "${smoke_image}" "${smoke_path}"
        volume_conf="${volume_conf} --volume ${smoke_volume}:${smoke_path}"
    fi

    OTHER_VOLUMES_CONF="${volume_conf}"
}

function docker_pull() {
    local img="$1"
    if [[ "${USE_LOCAL_IMAGE}" -gt 0 ]]; then
        if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "${img}"; then
            info "Local image ${img} found and will be used."
            return
        fi
        warning "Image ${img} not found locally although local mode enabled. Trying to pull from remote registry."
    fi
    if [[ -n "${GEO_REGISTRY}" ]]; then
        img="${GEO_REGISTRY}/${img}"
    fi

    info "Start pulling docker image ${img} ..."
    if ! docker pull "${img}"; then
        error "Failed to pull docker image : ${img}"
        exit 1
    fi
}

function determine_gpu_use_host() {
    if [[ "${HOST_ARCH}" == "x86_64" ]]; then
        if [[ ! -x "$(command -v nvidia-smi)" ]]; then
            warning "No nvidia-smi found. CPU will be used"
        elif [[ -z "$(nvidia-smi)" ]]; then
            warning "No GPU device found. CPU will be used."
        else
            USE_GPU_HOST=1
        fi
    else
        error "Unsupported CPU architecture: ${HOST_ARCH}"
        exit 1
    fi

    local nv_docker_doc="https://github.com/NVIDIA/nvidia-docker/blob/master/README.md"
    if [[ "${USE_GPU_HOST}" -eq 1 ]]; then
        if [[ -x "$(which nvidia-container-toolkit)" ]]; then
            local docker_version
            docker_version="$(docker version --format '{{.Server.Version}}')"
            if dpkg --compare-versions "${docker_version}" "ge" "19.03"; then
                DOCKER_RUN_CMD="docker run --gpus all"
            else
                warning "Please upgrade to docker-ce 19.03+ to access GPU from container."
                USE_GPU_HOST=0
            fi
        elif [[ -x "$(which nvidia-docker)" ]]; then
            DOCKER_RUN_CMD="nvidia-docker run"
        else
            USE_GPU_HOST=0
            warning "Cannot access GPU from within container. Please install latest Docker" \
                "and NVIDIA Container Toolkit as described by: "
            warning "  ${nv_docker_doc}"
        fi
    fi
}

function remove_container_if_exists() {
    local container="$1"
    if docker ps -a --format '{{.Names}}' | grep -q "${container}"; then
        info "Removing existing Apollo container: ${container}"
        docker stop "${container}" >/dev/null
        docker rm -v -f "${container}" 2>/dev/null
    fi
}

function check_can_restart() {
    if [[ ${RESTART} -eq 1 ]]; then
        return
    else
        if [[ ! -z "$(docker ps | grep ${DEV_CONTAINER})" ]]; then
            ok "${DEV_CONTAINER} is still running, please run the following command:"
            ok "    bash scripts/apollo_neo.sh enter"
            ok "Enjoy!"
            exit 0
        else
            if [[ ! -z "$(docker ps -a | grep ${DEV_CONTAINER})" ]]; then
                info "${DEV_CONTAINER} is down, try to restart."
                docker restart "${DEV_CONTAINER}"
                if [[ $? != 0 ]]; then
                    error "restart ${DEV_CONTAINER} failed"
                    error "if you want a new container, please run the following command:"
                    error " bash scripts/apollo_neo.sh start -f"
                    exit -1
                else
                    ok "${DEV_CONTAINER} successfully restart, please run the following command:"
                    ok "    bash scripts/apollo_neo.sh enter"
                    ok "Enjoy!"
                    exit 0
                fi
            fi
        fi
    fi
}

function main() {
    check_host_environment
    check_target_arch

    parse_arguments "$@"

    info "Determine whether host GPU is available ..."
    determine_gpu_use_host
    info "USE_GPU_HOST: ${USE_GPU_HOST}"

    determine_dev_image "${USER_VERSION_OPT}"

    if ! docker_pull "${DEV_IMAGE}"; then
        error "Failed to pull docker image ${DEV_IMAGE}"
        exit 1
    fi

    check_can_restart

    info "Remove existing Apollo Development container ..."
    remove_container_if_exists ${DEV_CONTAINER}

    local local_volumes=
    setup_devices_and_mount_local_volumes local_volumes

    #mount_map_volumes
    #mount_other_volumes

    info "Starting Docker container \"${DEV_CONTAINER}\" ..."

    local local_host="$(hostname)"
    local display="${DISPLAY:-:0}"
    local user="${USER}"
    local uid="$(id -u)"
    local group="$(id -g -n)"
    local gid="$(id -g)"

    set -x

    ${DOCKER_RUN_CMD} -itd \
        --privileged \
        --name "${DEV_CONTAINER}" \
        -e DISPLAY="${display}" \
        -e DOCKER_USER="${user}" \
        -e USER="${user}" \
        -e DOCKER_USER_ID="${uid}" \
        -e DOCKER_GRP="${group}" \
        -e DOCKER_GRP_ID="${gid}" \
        -e DOCKER_IMG="${DEV_IMAGE}" \
        -e USE_GPU_HOST="${USE_GPU_HOST}" \
        -e NVIDIA_VISIBLE_DEVICES=all \
        -e NVIDIA_DRIVER_CAPABILITIES=compute,video,graphics,utility \
        ${local_volumes} \
        --net host \
        -w /apollo_workspace \
        --add-host "${DEV_INSIDE}:127.0.0.1" \
        --add-host "${local_host}:127.0.0.1" \
        --hostname "${DEV_INSIDE}" \
        --shm-size "${SHM_SIZE}" \
        --pid=host \
        -v ${APOLLO_ROOT_DIR}:/apollo_workspace \
        -v /dev/null:/dev/raw1394 \
        "${DEV_IMAGE}" \
        /bin/bash

    if [ $? -ne 0 ]; then
        if [[ "${USE_GPU_IMAGE}" -eq 1 ]]; then
            USE_GPU_IMAGE=0
            USER_VERSION_OPT=
            determine_dev_image "${USER_VERSION_OPT}"

            warning "Failed to start docker gpu container \"${DEV_CONTAINER}\" based on image: ${DEV_IMAGE}"
            warning "It may caused by your incorrect drivers installation"
            info "Try docker cpu container"
            
            ${DOCKER_RUN_CMD} -itd \
                --privileged \
                --name "${DEV_CONTAINER}" \
                -e DISPLAY="${display}" \
                -e DOCKER_USER="${user}" \
                -e USER="${user}" \
                -e DOCKER_USER_ID="${uid}" \
                -e DOCKER_GRP="${group}" \
                -e DOCKER_GRP_ID="${gid}" \
                -e DOCKER_IMG="${DEV_IMAGE}" \
                -e USE_GPU_HOST="${USE_GPU_HOST}" \
                -e NVIDIA_VISIBLE_DEVICES=all \
                -e NVIDIA_DRIVER_CAPABILITIES=compute,video,graphics,utility \
                ${local_volumes} \
                --net host \
                -w /apollo_workspace \
                --add-host "${DEV_INSIDE}:127.0.0.1" \
                --add-host "${local_host}:127.0.0.1" \
                --hostname "${DEV_INSIDE}" \
                --shm-size "${SHM_SIZE}" \
                --pid=host \
                -v ${APOLLO_ROOT_DIR}:/apollo_workspace \
                -v /dev/null:/dev/raw1394 \
                "${DEV_IMAGE}" \
                /bin/bash 
        else
            error "Failed to start docker container \"${DEV_CONTAINER}\" based on image: ${DEV_IMAGE}"  
            exit 1   
        fi
    fi
    set +x

    postrun_start_user "${DEV_CONTAINER}"

    ok "Congratulations! You have successfully finished setting up Apollo Dev Environment."
    ok "To login into the newly created ${DEV_CONTAINER} container, please run the following command:"
    ok "  bash scripts/apollo_neo.sh enter"
    ok "Enjoy!"
}

main "$@"
