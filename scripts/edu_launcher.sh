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
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${TOP_DIR}/scripts/apollo_base_neo.sh"


function _usage() {
    echo -e "\n${RED}Usage${NO_COLOR}:
    .${BOLD}/apollo_neo.sh${NO_COLOR} [OPTION]"
    echo -e "\n${RED}Options${NO_COLOR}:
    ${BLUE}start ${NO_COLOR}: start a docker container with apollo development image.
    ${BLUE}start_gpu ${NO_COLOR}: start a docker container with apollo gpu support development image.
    ${BLUE}enter ${NO_COLOR}: enter into the apollo development container.
    ${BLUE}bootstrap ${NO_COLOR}: run dreamview and monitor module.
    ${BLUE}build [package]${NO_COLOR}: build available package, such as 'edu_launcher.sh build planning'.
    ${BLUE}install [package]${NO_COLOR}: install specify package, such as 'edu_launcher.sh install planning-dev'.
    "
}

function _build() {
    local build_sh="${TOP_DIR}/scripts/apollo_build_neo.sh" 
    local setup_sh="${TOP_DIR}/scripts/setup_cyberfile.py"
    local core_sh="${TOP_DIR}/scripts/install_core_neo.sh"
    
    bash ${core_sh}
    ${setup_sh} --packages $@
    ret=$?
    if [[ $ret -eq 20 ]]; then
        bash ${build_sh} build --packages edu-launch
    elif [[ $ret -eq 0 ]]; then
        exit 0
    else
        error "setup cyberfile failed! stop building process!"
        exit -1
    fi
}

function main() {
    if [ "$#" -eq 0 ]; then
        _usage
        exit 0
    fi

    local apollo_neo="${TOP_DIR}/scripts/apollo_neo.sh"  

    local cmd=$1

    case $1 in 
        -h | --help | usage | Usage)
            _usage
            ;; 

        start | start_gpu | enter | bootstrap | install)
            bash ${apollo_neo} $@
            ;;

        build)
            shift
            _build $@
            ;;

        *)
            _usage
            ;;

    esac
}

main $@
