#!/usr/bin/env bash
set -eu

# Copyright ValTech 2023
# Licensed under the Apache License, Version 2.0
#
# REF: https://autowarefoundation.github.io/autoware-documentation/galactic/installation/autoware/source-installation/
# source: https://autowarefoundation.github.io/autoware-documentation/galactic/installation/autoware/source-installation/

ROS_DISTRO=galactic
TARGET_OS=22.04
BRANCH=galactic

# Check OS version
if ! which lsb_release > /dev/null ; then
	sudo apt-get update
	sudo apt-get install -y curl lsb-release
fi

if [[ "$(lsb_release -sr)" == "$TARGET_OS" ]]; then
	echo "OS Check Passed"
else
	printf '\033[33m%s\033[m\n' "=================================================="
	printf '\033[33m%s\033[m\n' "ERROR: This OS (version: $(lsb_release -sr)) is not supported"
	printf '\033[33m%s\033[m\n' "=================================================="
	exit 1
fi

if ! dpkg --print-architecture | grep -q 64; then
	printf '\033[33m%s\033[m\n' "=================================================="
	printf '\033[33m%s\033[m\n' "ERROR: This architecture ($(dpkg --print-architecture)) is not supported"
	printf '\033[33m%s\033[m\n' "See https://www.ros.org/reps/rep-2000.html"
	printf '\033[33m%s\033[m\n' "=================================================="
	exit 1
fi

# Check ROS version
if [[ "$(ROS_DISTRO)" == "$TARGET_OS" ]]; then
	echo "OS Check Passed"
else
	printf '\033[33m%s\033[m\n' "=================================================="
	printf '\033[33m%s\033[m\n' "ERROR: ROS 2 galactic not detected."
    printf '\033[33m%s\033[m\n' "Please ensure ROS 2 galactic is install and/or sourced."
	printf '\033[33m%s\033[m\n' "=================================================="
	exit 1
fi

# Install
sudo apt-get -y update
sudo apt-get -y install git

echo "Cloning autoware.universe galactic branch"
git clone https://github.com/autowarefoundation/autoware.git -b galactic
cd autoware

echo "Installing dependencies using Ansible"
./setup-dev-env.sh

echo "Setting up workspace"
mkdir src
vcs import src < autoware.repos
source /opt/ros/$ROS_DISTRO/setup.bash
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO

echo "Build workspace using colcon"
colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

set +u

source install/setup.bash

echo "success installing Autoware.Universe $BRANCH"
