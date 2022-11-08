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
source ~/.bashrc

DREAMVIEW_URL="http://localhost:8888"


function start() {
    ${BUILD_TOOL} bootstrap start dreamview-dev
    ${BUILD_TOOL} bootstrap start monitor-dev
    sleep 5 # wait for some time before starting to check
    http_status="$(curl -o /dev/null -x '' -I -L -s -w '%{http_code}' ${DREAMVIEW_URL})"
    if [ $http_status -eq 200 ]; then
      info "Dreamview is running at" $DREAMVIEW_URL
    else
      error "Failed to start Dreamview. Please check dreamview.log or monitor.log for more information"
    fi
}

function stop() {
    ${BUILD_TOOL} bootstrap stop dreamview-dev
    ${BUILD_TOOL} bootstrap stop monitor-dev
}


function help() {
    ${BUILD_TOOL} bootstrap -h
}


function parse_arguments() {
    case $1 in
        start)
            start 
            ;;
        stop)
            stop 
            ;;
        restart)
            stop 
            start 
            ;;
        --help | -h)
            help
            ;;
        *)
            start
            ;;
    esac
}


function main(){
    check_core_installed
    if [ ! $? -eq 0 ]
    then
        exit $?
    fi
    parse_arguments $@
}

main $@
