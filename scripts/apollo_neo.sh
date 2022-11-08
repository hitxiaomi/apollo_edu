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
    ${BLUE}install_core ${NO_COLOR}: install the core module of apollo.
    ${BLUE}bootstrap ${NO_COLOR}: run dreamview and monitor module.
    ${BLUE}build --packages [path]${NO_COLOR}: build package in workspace.
    ${BLUE}install [packages]${NO_COLOR}: install package in workspace.
    "
}


function main() {
    if [ "$#" -eq 0 ]; then
        _usage
        exit 0
    fi

    local dev_start_sh="${TOP_DIR}/scripts/dev_start_neo.sh"
    local dev_into_sh="${TOP_DIR}/scripts/dev_into_neo.sh" 
    local install_core_sh="${TOP_DIR}/scripts/install_core_neo.sh"
    local bootstrap_sh="${TOP_DIR}/scripts/bootstrap_neo.sh"
    local build_sh="${TOP_DIR}/scripts/apollo_build_neo.sh" 
    

    local cmd=$1

    case $1 in 
        -h | --help | usage | Usage)
            _usage
            ;; 
        start)
            shift
            bash ${dev_start_sh} $@
            ;;
        start_gpu)
            shift
            bash ${dev_start_sh} --gpu $@
            ;;
        enter)
            shift
            bash ${dev_into_sh}
            ;;
        install_core)
            shift
            bash ${install_core_sh}
            ;;
        bootstrap)
	        shift
            bash ${bootstrap_sh} $@
            ;;
        build | install)
             bash ${build_sh} $@
            ;;
        *)
            _usage
            ;;
    esac
}

main $@
