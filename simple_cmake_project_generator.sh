#!/bin/sh

# Optional arguments
CMAKE_VERSION=3.10.0
C_COMPILER=clang
BUILD_DIR=build
RUN_SCRIPT=run.sh
SRC_DIR=src
TYPE=basic

MAIN_C_TEMPLATE_basic="
#include <stdio.h>

int main(int argc, char *argv[]) {
    printf(\"Hello World\\n\");
    return 0;
}
"

MAIN_C_TEMPLATE_pthread="
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

void *thread_func(void *arg) {
    printf(\"Hello from Thread\\n\");
    return NULL;
}

int main(int argc, char *argv[]) {
    pthread_t thread;    
    pthread_create(&thread, NULL, thread_func, NULL);
    pthread_join(thread, NULL);
    return 0;
}
"

function help() {
    echo "Usage: $0 <project-name> 
        [--type <type>] 
        [--run-script <run-script>] 
        [--cmake-version <cmake-version>] [--c-compiler <c-compiler>] 
        [--build-dir <build-dir>] [--src-dir <src-dir>]"
    echo "Example: $0 my-project --type basic"
    echo "Example: $0 my-project --cmake-version 3.10.0 --type pthread"
}

# parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h|--help)
            help
            exit 0
            ;;
        --type)
            TYPE="$2"
            shift
            shift
            ;;
        --run-script)
            RUN_SCRIPT="$2"
            shift
            shift
            ;;
        --cmake-version)
            CMAKE_VERSION="$2"
            shift
            shift
            ;;
        --c-compiler)
            C_COMPILER="$2"
            shift
            shift
            ;;
        --build-dir)
            BUILD_DIR="$2"
            shift
            shift
            ;;
        --src-dir)
            SRC_DIR="$2"
            shift
            shift
            ;;
        *)
            PROJECT_NAME="$1"
            shift
            ;;
    esac
done

# ------------------------- VALIDATION -------------------------

# project name
if [ -z "$PROJECT_NAME" ]; then
    echo "Project name is required"
    help
    exit 1
fi
if [ -d "$PROJECT_NAME" ]; then
    echo "Project $PROJECT_NAME already exists"
    exit 1
fi

# type - basic,pthread
if [ "$TYPE" != "basic" ] && [ "$TYPE" != "pthread" ]; then
    echo "Invalid type: $TYPE"
    help
    exit 1
fi

# ------------------------- GENERATION -------------------------

# create project directory
echo "Creating project $PROJECT_NAME"
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# create CMakeLists.txt
tee CMakeLists.txt > /dev/null <<EOF
cmake_minimum_required(VERSION $CMAKE_VERSION)
project($PROJECT_NAME)
set(CMAKE_C_COMPILER $C_COMPILER)
add_executable($PROJECT_NAME $SRC_DIR/main.c)
EOF
echo "Created CMakeLists.txt"

# create run script (build quiet)
tee $RUN_SCRIPT > /dev/null <<EOF
#!/bin/sh
cd $BUILD_DIR
cmake ..
make
echo " - - - - - - - "
./$PROJECT_NAME \$@
EOF
chmod +x $RUN_SCRIPT
echo "Created $RUN_SCRIPT"

# create directories
mkdir $SRC_DIR
mkdir $BUILD_DIR

# create main.c
case $TYPE in
    basic)
        tee $SRC_DIR/main.c > /dev/null <<EOF
$MAIN_C_TEMPLATE_basic
EOF
        ;;
    pthread)
        tee $SRC_DIR/main.c > /dev/null <<EOF
$MAIN_C_TEMPLATE_pthread
EOF
        ;;
    *)
        echo "Unknown type: $TYPE"
        exit 1
        ;;
esac
echo "Created $SRC_DIR/main.c"

echo "Done! :)"

# ------------------------- INSTRUCTIONS -------------------------
echo "INSTRUCTIONS:"
echo "   - To build and run the project, run ./$RUN_SCRIPT"
echo "   - Edit the C source code in $SRC_DIR/main.c"
echo "   - Edit the CMakeLists.txt to add more source files"
echo "   - Edit the $RUN_SCRIPT to add more build options"
echo "Thanks for using this script! :)"
echo ":) github.com/ThlinaTLM"