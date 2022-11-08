#!/usr/bin/env python3

###############################################################################
# Copyright 2019 The Apollo Authors. All Rights Reserved.
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
"""setup cyberfile.xml"""
import os
import sys
import argparse
import logging
import xml.etree.ElementTree as ET

from pathlib import Path

logger = None
parser = None
APP = os.path.basename(sys.argv[0]).split(".")[0]
root = os.path.dirname(os.path.abspath(os.path.dirname(os.path.realpath(__file__))))
cyberfile_wrapper = Path(root) / "edu-launch" / "cyberfile.xml"
required_packages = [
    "dreamview",
    "prediction",
    "monitor", 
    "task_manager",
    "routing",
    "3rd-rules-python",
    "3rd-grpc",
    "3rd-bazel-skylib",
    "3rd-rules-proto",
    "3rd-py",
    "3rd-gpus"
]
required_packages_info = {
    "3rd-rules-python": {
        "package_name": "3rd-rules-python-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "3rd-grpc": {
        "package_name": "3rd-grpc-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "3rd-bazel-skylib": {
        "package_name": "3rd-bazel-skylib-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "3rd-rules-proto": {
        "package_name": "3rd-rules-proto-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "3rd-py": {
        "package_name": "3rd-py-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "3rd-gpus": {
        "package_name": "3rd-gpus-dev",
        "default_type": None,
        "repo_name": None,
        "expose": "False",
        "lib_names": None
    },
    "task_manager": {
        "package_name": "task-manager-dev",
        "default_type": "binary",
        "repo_name": "task-manager",
        "expose": None,
        "lib_names": None
    },
    "monitor": {
        "package_name": "monitor-dev",
        "default_type": "binary",
        "repo_name": "monitor",
        "expose": None,
        "lib_names": None
    },
    "dreamview": {
        "package_name": "dreamview-dev",
        "default_type": "binary",
        "repo_name": "dreamview",
        "expose": None,
        "lib_names": None
    },
    "prediction": {
        "package_name": "prediction-dev",
        "default_type": "binary",
        "repo_name": "prediction",
        "expose": None,
        "lib_names": None
    },
    "routing": {
        "package_name": "routing-dev",
        "default_type": "binary",
        "repo_name": "routing",
        "expose": None,
        "lib_names": None
    }
}
packages_info = {
    "planning": {
        "package_name": "planning-dev",
        "available_type": "src",
        "repo_name": "planning",
        "lib_names": None
    },
    "routing": {
        "package_name": "routing-dev",
        "available_type": "src",
        "repo_name": "routing",
        "lib_names": None
    },
    "task_manager": {
        "package_name": "task-manager-dev",
        "available_type": "src",
        "repo_name": "task-manager",
        "lib_names": None
    },
    "monitor": {
        "package_name": "monitor-dev",
        "available_type": "src",
        "repo_name": "monitor",
        "lib_names": None
    },
    "dreamview": {
        "package_name": "dreamview-dev",
        "available_type": "src",
        "repo_name": "dreamview",
        "lib_names": None
    },
    "prediction": {
        "package_name": "prediction-dev",
        "available_type": "src",
        "repo_name": "prediction",
        "lib_names": None
    },
}


BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = list(range(8))
RESET_SEQ = "\033[0m"
COLOR_SEQ = "\033[1;%dm"
BOLD_SEQ = "\033[1m"
COLORS = {
    'INFO':     GREEN,
    'WARNING':  YELLOW,
    'DEBUG':    BLUE,
    'ERROR':    RED,
    'CRITICAL': YELLOW
}

_usage = """\033[0;34m\nedu-launch is a end to end project, focusing on the source code  
learning and experimentation of Apollo packages in educational scenarios.
At present, the source code packages of Apollo that can be learned and experimented are:\033[0m
\033[32m\033[1m{}\033[0m
\033[0;34mTo use edu-launch to learn and experiment Apollo package, please run the following command:
\033[32m\033[1m  bash scripts/edu_launcher.sh build planning\033[0m
""".format("\n".join([i for i in packages_info]))
    

class ColoredFormatter(logging.Formatter):
    """colored formatter for logger"""
    def __init__(self, msg):
        logging.Formatter.__init__(self, msg)
        
    def format(self, record):
        """format the log"""
        levelname = record.levelname
        if levelname in COLORS:
            if levelname == 'DEBUG':
                record.levelname = COLOR_SEQ % (30 + COLORS[levelname]) + \
                    record.msg.split('#')[0] + RESET_SEQ
                record.msg = COLOR_SEQ % (30 + COLORS[levelname]) + \
                    record.msg.split('#')[-1] + RESET_SEQ
            else:
                record.levelname = COLOR_SEQ % (30 + COLORS[levelname]) + \
                    APP + RESET_SEQ
                record.msg = COLOR_SEQ % (30 + COLORS[levelname]) + levelname + \
                    " " + record.msg.split('#')[-1] + RESET_SEQ
        return logging.Formatter.format(self, record)


def _init_logger(name):
    global logger
    logger = logging.getLogger(name)
    color_formatter = ColoredFormatter("[%(levelname)-18s] %(message)s")
    console = logging.StreamHandler()
    console.setFormatter(color_formatter)
    logger.addHandler(console)
    logger.setLevel(logging.INFO)
    return logger


def setup_cyberfile_content(cyberfile_wrapper, packages):
    """
    setup cyberfile content based on input packages.

    parms: 
        cyberfile_wrapper: Path, a Path wrapper of cyberfile
        packages: list of str, input packages
    ret:
        retcode: int, 20 is ok while others are error
    """
    if not cyberfile_wrapper.exists():
        logger.error("Can not find cyberfile: {}".format(str(cyberfile_wrapper)))
        logger.error("Redownload this project may solve this problem.")
        return -1

    cyberfile_xml_wrapper = ET.parse(str(cyberfile_wrapper))
    root = cyberfile_xml_wrapper.getroot()

    # delete all depend label
    for item in root.findall("depend"):
        root.remove(item)
    
    for i in packages:
        if i in required_packages:
            required_packages.remove(i)
        
        package_info = packages_info[i]
        new_dep = ET.Element("depend")
        new_dep.text = package_info["package_name"]
        new_dep.set("type", package_info["available_type"])
        if package_info["repo_name"] is not None:
            new_dep.set("repo_name", package_info["repo_name"])
        if package_info["lib_names"] is not None:
            new_dep.set("lib_names", package_info["lib_names"])
        root.append(new_dep)
    
    for i in required_packages:
        required_package_info = required_packages_info[i]
        new_dep = ET.Element("depend")
        new_dep.text = required_package_info["package_name"]
        if required_package_info["default_type"] is not None:
            new_dep.set("type", required_package_info["default_type"])
        if required_package_info["repo_name"] is not None:
            new_dep.set("repo_name", required_package_info["repo_name"])
        if required_package_info["expose"] is not None:
            new_dep.set("expose", required_package_info["expose"])
        if required_package_info["lib_names"] is not None:
            new_dep.set("lib_names", required_package_info["lib_names"])
        root.append(new_dep)
    
    try:
        cyberfile_xml_wrapper.write(str(cyberfile_wrapper), encoding='utf-8', xml_declaration=True)
    except Exception as ex:
        logger.error(str(ex))
        return -1
    return 20


def setup_parser():
    """
    setup script arguments parser

    parms: None
    ret: None
    """
    global parser
    parser = argparse.ArgumentParser(description='cyberfile setup script', usage=_usage)
    parser.add_argument(
        '--packages', nargs='*', metavar='*', 
        type=str.lstrip, help="Specify the packages to build."
    )


def show_available_packages():
    """
    show currently available packages
    """
    print(_usage)


def _main():
    global cyberfile_wrapper
    global APP
    packages = list()

    _init_logger(APP)
    setup_parser()
    args = parser.parse_args()
    query_packages = args.packages if args.packages is not None else []

    for package in query_packages:
        if package not in packages_info:
            logger.error("Package {} currently is not support, ignore.".format(package))
            continue
        packages.append(package)

    if len(packages) < 1:
        logger.error("Packages that need to be compiled are not specified")
        show_available_packages()
        return -1

    ret = setup_cyberfile_content(cyberfile_wrapper, packages)
    return ret


if __name__ == "__main__":
    sys.exit(0 or _main())


