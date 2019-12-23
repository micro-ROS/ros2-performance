# This script is intended to be used by the Jenkins night builds.
# But it still possible to use manually setting up this variables:
#
# TARGET=[raspbian]
# ROS2_DISTRO=[ardent,bouncy,crystal,master,...]

# Check that all variables are defined before start
if [[ -z "$TARGET" || -z "$ROS2_DISTRO" ]]
then
  echo "Error: environmental variables are not defined!"
  echo "Set values to: TARGET / ROS2_DISTRO"
  exit 1
fi

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export BASE_DIR="$(dirname "$(pwd)")"

# Prepare cross-compiling environment
source $THIS_DIR/env.sh $TARGET

# Get sysroot
bash $THIS_DIR/get_sysroot.sh

# Remove ROS2 old cross-compilation workspace and get a new one
cd $BASE_DIR
sudo rm -rf ros2_cc_ws
mkdir -p ros2_cc_ws/src
cd ros2_cc_ws
wget https://raw.githubusercontent.com/micro-ROS/micro-ROS-doc/dashing/Installation/repos/agent_minimum.repos
vcs import src < agent_minimum.repos



# Cross-compiling ROS2
cd $BASE_DIR
IGNORE_SCRIPT=cross-compiling/ignore_pkgs.sh
bash $IGNORE_SCRIPT $BASE_DIR/ros2_cc_ws $ROS2_DISTRO

CC_CMD="bash cross-compiling/cc_workspace.sh $BASE_DIR/ros2_cc_ws"
if $CC_CMD; then
  echo "Cross-compilation finished"
else
  exit 1
fi
