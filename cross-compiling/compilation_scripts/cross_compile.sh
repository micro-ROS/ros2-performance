#!/bin/bash

## script for cross-compiling the current workspace
## accepts as argument the path to the toolchain file to be used
## if no argument is provided, it looks for a default toolchain in the current directory.


if [ -z "$1" ]; then
    TOOLCHAIN_PATH=`pwd`/toolchainfile.cmake
else
    TOOLCHAIN_PATH=$1
fi
git clone https://github.com/eProsima/Micro-CDR
# clear out everything first
rm -rf build install log

colcon \
    build \
    --merge-install \
    --cmake-force-configure \
    --executor sequential \
    --cmake-args \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_PATH \
    -DUAGENT_ISOLATED_INSTALL=OFF \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DTHIRDPARTY=ON \
    -DBUILD_TESTING:BOOL=OFF

chown -R user ~/ws


# --merge-install is used to avoid creation of nested install dirs for each package
# --executtor sequential is used because parallel build fails in random ways

