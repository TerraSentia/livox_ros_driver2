FROM ros:humble
ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION_ROS="ROS2"
ENV ROS_DISTRO=humble
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Update and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    build-essential \
    cmake \
    git \
    wget \
    python3-pip \
    libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ROS 2 Humble and other dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-ament-cmake \
    ros-${ROS_DISTRO}-ament-cmake-auto \
    ros-${ROS_DISTRO}-ament-lint-auto \
    ros-${ROS_DISTRO}-ament-lint-common \
    ros-${ROS_DISTRO}-ros2cli \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-rosidl-default-generators \
    libqt5x11extras5 \
    python3-colcon-common-extensions \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# Install Livox SDK dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpcap-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Livox SDK2
WORKDIR /workspace
RUN git clone https://github.com/Livox-SDK/Livox-SDK2.git \
    && cd Livox-SDK2 \
    && mkdir build && cd build \
    && cmake .. && make -j$(nproc) \
    && make install

RUN echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH" >> /etc/bash.bashrc

# Build gtsam
RUN wget -O gtsam.zip https://github.com/borglab/gtsam/archive/refs/tags/4.1.1.zip \
    && unzip gtsam.zip \
    && rm -rf gtsam.zip \
    && cd gtsam-4.1.1 \
    && mkdir build \
    && cd build \
    && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_USE_SYSTEM_EIGEN=ON .. \
    && make install -j$(nproc)

# Build yaml-cpp
WORKDIR /workspace
RUN git clone https://github.com/jbeder/yaml-cpp.git \
    && cd yaml-cpp \
    && mkdir build \
    && cd build \
    && cmake .. && make -j$(nproc) \
    && make install

# Setup ROS2 workspace
WORKDIR /root/ros2_ws

# Clone and build Livox ROS Driver
RUN mkdir -p src \
    && cd src \
    && git clone https://github.com/TerraSentia/livox_ros_driver2.git \
    && cd livox_ros_driver2 \
    && cp -f package_ROS2.xml package.xml \
    && rm -rf launch_ROS1 \
    && cp -rf launch_ROS2 launch

# Build ROS workspace
RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
    && colcon build --cmake-args -DROS_EDITION=${VERSION_ROS} -DHUMBLE_ROS=${ROS_DISTRO}

# Source ROS setup and workspace in bashrc
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc \
    && echo "source /root/ros2_ws/install/setup.bash" >> /etc/bash.bashrc

WORKDIR /root/ros2_ws
