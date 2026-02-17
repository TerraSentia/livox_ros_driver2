#!/bin/bash

pushd `pwd` > /dev/null
cd `dirname $0`
echo "Working Path: "`pwd`

ROS_HUMBLE=""

# Set working ROS version
if [ "$1" = "humble" ]; then
    ROS_HUMBLE="humble"
fi

# clear build folders
rm -rf ../../build/
rm -rf ../../install/

# clear src/CMakeLists.txt if it exists
if [ -f ../CMakeLists.txt ]; then
    rm -f ../CMakeLists.txt
fi

# build
pushd `pwd` > /dev/null
cd ../../
colcon build --cmake-args -DHUMBLE_ROS=${ROS_HUMBLE}
popd > /dev/null

popd > /dev/null
