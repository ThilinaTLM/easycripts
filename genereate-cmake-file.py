#!/bin/python3

import os
from os import path
import re

# Tempaltes

CMAKE_TEMPLATE = """
cmake_minimum_required(VERSION 3.20)
project({project})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")
set(CMAKE_CXX_STANDARD 20)

add_executable({project} main.cpp)
""".strip('\n')

MAKE_FILE_TEMPLATE = """
TARGET_DIR = {target}
EXECUTABLE_NAME = {project}

.DEFAULT_GOAL := run

.SILENT:
.ONESHELL:
config:
\tmkdir -p ${{TARGET_DIR}}
\tcd ${{TARGET_DIR}}
\tcmake ..
\tcp compile_commands.json ../
\tcd ..

build:
\tcd ${{TARGET_DIR}}
\tmake -s
\tcd ..

run: build
\t./${{TARGET_DIR}}/${{EXECUTABLE_NAME}}

clean:
\tcd ${{TARGET_DIR}}
\tcmake --build . --target clean
\tcd ..
"""

MAIN_CPP_TEMPPLATE = """
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
""".strip('\n')

# ------------------- Util Functions -------------------


def to_hiphen_snake_case(s):
    """
        Convert a string to snake case.
    """
    return re.sub('(.)([A-Z][a-z]+)', r'\1-\2', s).lower()


def get_project_path():
    return os.getcwd()


def get_project_name():
    cwd = os.getcwd()
    base_name = path.basename(cwd)
    return to_hiphen_snake_case(base_name)


def get_taget_directory():
    return "target"


# ---------------- Modules ----------------

def module_cmake_file():
    """
    Generate CMakeLists.txt file.
    if not exists, create it.
    """

    if os.path.exists('CMakeLists.txt'):
        print('CMakeLists.txt already exists.')
        return
    # get project name
    project_name = get_project_name()
    project_path = get_project_path()

    with open(path.join(project_path, 'CMakeLists.txt'), 'w') as f:
        f.write(CMAKE_TEMPLATE.format(project=project_name))
    print('CMakeLists.txt generated.')


def module_create_maincpp():
    """
    Generate main.cpp file.
    if not exists, create it.
    """
    if os.path.exists('main.cpp'):
        print('main.cpp already exists.')
        return
    with open('main.cpp', 'w') as f:
        f.write(MAIN_CPP_TEMPPLATE)
    print('main.cpp generated.')


def module_create_makefile():
    """
    Generate makefile.
    if not exists, create it.
    """
    if os.path.exists('Makefile'):
        print('Makefile already exists.')
        return
    # get project name
    project_name = get_project_name()
    target_dir = get_taget_directory()

    with open('Makefile', 'w') as f:
        f.write(MAKE_FILE_TEMPLATE.format(
            project=project_name, target=target_dir
        ))
    print('Makefile generated.')


def main():
    module_cmake_file()
    module_create_maincpp()
    module_create_makefile()


if __name__ == '__main__':
    main()
