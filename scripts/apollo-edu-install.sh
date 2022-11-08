#!/bin/bash

SCRIPT_TOOLS_NAME="apollo-edu.tar.gz"
DIR_NANE="apollo-edu"
SCRIPT_TOOLS_URL="https://apollo-pkg-beta.bj.bcebos.com/e2e/${SCRIPT_TOOLS_NAME}"

function main() {

    if [[ ! -f ${SCRIPT_TOOLS_NAME} ]]; then
        wget ${SCRIPT_TOOLS_URL}
        if [ ! $? -eq 0 ]; then
            echo "download apollo-edu failed!"
            exit -1
        fi
    fi

    if [[ ! -d ${DIR_NANE} ]]; then
        tar -xzvf ${SCRIPT_TOOLS_NAME}  
        if [ ! $? -eq 0 ]; then
            echo "decompress ${SCRIPT_TOOLS_NAME} failed!"
            exit -1
        fi
    fi

    echo "To set up Apollo Dev Enviroment, please run the follow command:"
    echo "  cd apollo-edu && bash scripts/edu-launcher.sh start"
    return 0
}

main