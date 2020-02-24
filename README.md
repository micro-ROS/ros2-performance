This is a fork of the iRobot cross-compilation tool adapted to work with the micro-ROS requirements. The copyright is base on the original repository and can be check on the [License](LICENSE) file.

# Micro-ROS cross-compilation tool.

The building process of the micro-ROS Agent for the micro-ROS bridge could take several hours, so is necessary to provide a tool that improves this issue. The result is this fork which simplifies the building process and maintenance process.
You can use this tool in an isolated way, but the usage is focused on integrate with the [micro-ROS build system](https://github.com/micro-ROS/micro-ros-build)

# How to use it:

(The next instructions are to use this tool without the Micro-ROS build system)

## Dependencies:
This tool has been tested on **Ubuntu 18.04**, is not warranty the good perfomance on a different Linux distributions. On the other hand, they report from the official repository that this solution doesn't work on Mac OS and Windows.

You need the next list of dependencies on your host PC (Is necessary to follow the installation order to obtain succesfull results):
- Qemu:
``` 
sudo apt-get install -y --no-install-recommends qemu-user-static binfmt-support 
update-binfmts --enable qemu-arm 
update-binfmts --display qemu-arm
```
- Docker:
  - You can find the install instructions here: [Docker Installation](https://docs.docker.com/install/linux/

- Python 3.6:
```
sudo apt-get install python3.6
```
- VCS Tools:
```
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xAB17C654
sudo apt-get update
sudo apt-get install python3-vcstool
```

Now you have everything ready to use the cross-compilation tool

## Cross-Compile Micro-ROS Agent:

- Download the repository:
```
git clone -b microros_cc_tool https://github.com/micro-ROS/ros2-performance uROS-CC
```

- Go to the next folder: 
```
uROS-CC/ros2-performance/cross-compiling
```

- Open a terminal on the previous folder.

- Set the target device by tipying the next command(At this moment is only available Raspbian):
```
export TARGET=raspbian
```

- Set the micro-ROS distribution (crystal / dashing):
```
export ROS2_DISTRO=dashing
```

- Create the build space:
```
bash build.sh
```

- Execute the automatic cross-compilation process:
```
bash automatic_cross_compile.sh
```

# Result:

This will return a folder called ``micro-ros_cc_ws`` which contains the micro-ROS Agent cross-compiled for ARM. 


# Possible problems and answers:

This is a set of known problems that could raise during the first set-up of this tool:

## Docker ARM compilation:
(Solution obtain from the original repository)
In some cases, Docker could raise problems when you try to compile for ARM architecture on X86/64 machine, this is a set of solutions extracted from the original repository.

The first step to being sure if your machine is working properly is to compile a basic ARM docker. You can try by typing the next command on a terminal:
```
docker run -it arm32v7/debian:stretch-slim
```

If it doesn't fail, your set-up is fine and you can run this tool without any problem. Otherwise, this is a set of possible solutions:

### Solution 1:

```
sudo apt-get install qemu-user-static
sudo systemctl restart systemd-binfmt.service
```

### Solution 2:

```
git clone https://github.com/computermouth/qemu-static-conf.git
sudo mkdir -p /lib/binfmt.d
sudo cp qemu-static-conf/*.conf /lib/binfmt.d/
sudo systemctl restart systemd-binfmt.service
```

### Solution 3:

The last solution has to be repeated for each Dockerfile.

```
cd <Dockerfile_directory>
sudo apt-get install qemu-user-static
mkdir qemu-user-static
cp /usr/bin/qemu-*-static qemu-user-static
```

Then add a line to your Dockerfile, immediately after the `FROM` command and before any other instruction.

```
COPY qemu-arm-static /usr/bin
```

Then you can build and run your Dockerfile as usual.

