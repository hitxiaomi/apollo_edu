#!/usr/bin/env bash

###############################################################################
# Copyright 2017-2021 The Apollo Authors. All Rights Reserved.
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
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
buildtool="apollo-neo-buildtool-dev"
BUILD_TOOL="buildtool"

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

REPO_ADRESS="deb https://apollo-pkg-beta.bj.bcebos.com/neo/beta bionic main"


function check_core_installed() {
    if [ ! -f ~/.installed ]
    then
        error "Core module of apollo is not installed!"
        error "Please run \"apollo_neo.sh install_core\" first!"
        return -1
    fi
    return 0
}

function check_buildtool() {
    local result
    result=$(sudo apt list ${buildtool} 2>/dev/null | grep ${buildtool})
    if [[ $result == "" ]]
    then
        add_repo
        sudo apt install -y --allow-unauthenticated ${buildtool}
        if [ $? -ne 0 ]
        then
            echo "Failed to install ${buildtool}"
            exit -1
        fi
    else
        if [[ ! $result =~ "installed" ]]
        then
            sudo apt install -y --allow-unauthenticated ${buildtool}
            if [ $? -ne 0 ]
            then
                echo "Failed to install ${buildtool}"
                exit -1
            fi
        fi
    fi
}

function add_repo() {
    local ubuntu_source="/etc/apt/sources.list"
    sudo bash -c "echo ${REPO_ADRESS} >> ${ubuntu_source}"
    sudo apt update --allow-insecure-repositories
}


function postrun_start_user() {
    local container="$1"
    if [ "${USER}" != "root" ]; then
        docker exec -u root "${container}" \
            bash -c '/apollo_workspace/scripts/docker_start_user.sh'
    fi
}

function stop_all_apollo_containers() {
    local force="$1"
    local running_containers
    running_containers="$(docker ps -a --format '{{.Names}}')"
    for container in ${running_containers[*]}; do
        if [[ "${container}" =~ apollo_neo_.*_${USER} ]]; then
            #printf %-*s 70 "Now stop container: ${container} ..."
            #printf "\033[32m[DONE]\033[0m\n"
            #printf "\033[31m[FAILED]\033[0m\n"
            info "Now stop container ${container} ..."
            if docker stop "${container}" >/dev/null; then
                if [[ "${force}" == "-f" || "${force}" == "--force" ]]; then
                    docker rm -f "${container}" 2>/dev/null
                fi
                info "Done."
            else
                warning "Failed."
            fi
        fi
    done
}

# Check whether user has agreed license agreement
function check_agreement() {
    local agreement_record="${HOME}/.apollo_agreement.txt"
    if [[ -e "${agreement_record}" ]]; then
        return 0
    fi
    local agreement_file
    agreement_file="${TOP_DIR}/scripts/AGREEMENT.txt"
    if [[ ! -f "${agreement_file}" ]]; then
        error "AGREEMENT ${agreement_file} does not exist."
        exit 1
    fi

    cat "${agreement_file}"
    local tip="Type 'y' or 'Y' to agree to the license agreement above, \
or type any other key to exit:"

    echo -n "${tip}"
    local answer="$(read_one_char_from_stdin)"
    echo

    if [[ "${answer}" != "y" ]]; then
        exit 1
    fi

    cp -f "${agreement_file}" "${agreement_record}"
    echo "${tip}" >> "${agreement_record}"
    echo "${user_agreed}" >> "${agreement_record}"
}

export -f check_agreement
export -f check_buildtool
export -f add_repo
export -f check_core_installed
