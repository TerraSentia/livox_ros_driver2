#!/usr/bin/env bash
set -eo pipefail

export LD_LIBRARY_PATH="/usr/local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

echo "[livox] Sourcing ROS 2..."
source /opt/ros/humble/setup.bash

echo "[livox] Building workspace..."
cd /root/ros2_ws
colcon build

echo "[livox] Sourcing workspace overlay..."
source /root/ros2_ws/install/setup.bash

echo "[livox] Launching livox driver..."
exec ros2 launch livox_ros_driver2 pcl_hap.launch.py
