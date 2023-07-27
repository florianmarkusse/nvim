#!/bin/bash
set -e

YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NO_COLOR='\033[0m'

if [[ $# -ne 2 ]]; then
	echo -e "${RED}${BOLD}Usage: $0 <EXECUTABLE> <BUILD_TYPE>${NO_COLOR}"
	echo -e "Valid options for BUILD_TYPE: ${YELLOW}debug${NO_COLOR}, ${YELLOW}release${NO_COLOR}"
	exit 1
fi

EXECUTABLE=$1
BUILD_TYPE=$2

# Check if the provided BUILD_TYPE is valid
if [[ "$BUILD_TYPE" != "debug" && "$BUILD_TYPE" != "release" ]]; then
	echo -e "${RED}${BOLD}Invalid BUILD_TYPE. Valid options:${NO_COLOR} ${YELLOW}debug${NO_COLOR}, ${YELLOW}release${NO_COLOR}"
	exit 1
fi

cmake -S . -B build/ -D CMAKE_BUILD_TYPE="$BUILD_TYPE"
cmake --build build/
./run-executable.sh build "$EXECUTABLE"-"$BUILD_TYPE"

if [ -f "tests/CMakeLists.txt" ]; then
	cmake -S tests -B tests/build/ -D CMAKE_BUILD_TYPE="$BUILD_TYPE"
	cmake --build tests/build/

	./run-executable.sh tests/build "$EXECUTABLE"-tests-"$BUILD_TYPE"
fi
