#! /bin/bash

sudo apt update; sudo apt-get install -y python3-venv

python3 -m venv "$HOME/nav_challenge"
export PATH="$HOME/nav_challenge/bin:$PATH"

pip3 install \
    wheel \
    defusedxml \
    rospkg \
    netifaces \
    numpy \

mkdir -p "$HOME/jackal_ws/src"
cd "$HOME/jackal_ws/src" || exit

git clone --depth=1 --single-branch https://github.com/Daffan/nav-competition-icra2022.git
git clone --depth=1 --single-branch https://github.com/jackal/jackal.git --branch noetic-devel
git clone --depth=1 --single-branch https://github.com/jackal/jackal_simulator.git --branch melodic-devel
git clone --depth=1 --single-branch https://github.com/jackal/jackal_desktop.git --branch noetic-devel
git clone --depth=1 --single-branch https://github.com/utexas-bwi/eband_local_planner.git

sed -i 's/-std=c++11/-std=c++17/g' "$HOME/jackal_ws/src/nav-competition-icra2022/jackal_helper/CMakeLists.txt"

cd "$HOME/jackal_ws" || exit
source /opt/ros/noetic/setup.bash
sudo rosdep init; rosdep update
rosdep install -y --from-paths . --ignore-src --rosdistro=noetic

catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3