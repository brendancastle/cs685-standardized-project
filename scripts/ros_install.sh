#! /bin/bash

if dpkg -l ros-noetic-desktop-full > /dev/null; then 
    echo "ROS Noetic is already installed, skipping";
else
    # Set up sources list
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

    # Set up repository key
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

    # Install ROS Noetic
    sudo apt update && sudo apt install -y ros-noetic-desktop-full

    # Source environment
    echo "source /opt/ros/noetic/setup.bash" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

    # Install dependencies for building packages
    sudo apt install -y \
        python3-rosdep \
        python3-rosinstall \
        python3-rosinstall-generator \
        python3-wstool \
        build-essential
fi