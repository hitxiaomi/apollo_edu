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


function main() {
    if [ ! -f ~/.installed ]
    then
        check_buildtool
        pip3 install requests -i https://mirror.baidu.com/pypi/simple/ --trusted-host mirror.baidu.com
        sudo apt install -y --allow-unauthenticated uuid-dev apollo-neo-cyber-dev apollo-neo-common-dev apollo-neo-common-msgs-dev
        touch ~/.installed
    fi
    info "Core module have been installed"
}

main $@
