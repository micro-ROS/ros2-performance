#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# build a docker image of the target system
#docker build -t raspbian_sysroot -f $THIS_DIR/Dockerfile_raspbian $THIS_DIR

# eventually remove old docker containers
docker kill micro-ros-raspbian-sysroot
docker rm micro-ros-raspbian-sysroot

# create new docker container
#docker create --name micro-ros-raspbian-sysroot raspbian_sysroot
docker create --name micro-ros-raspbian-sysroot jfm92/microroshwb

# extract sysroot from docker container as tar file
docker container export -o $THIS_DIR/$TARGET_ARCHITECTURE.tar micro-ros-raspbian-sysroot

# uncompress sysroot
chmod 777 $THIS_DIR/$TARGET_ARCHITECTURE.tar
mkdir $THIS_DIR/$TARGET_ARCHITECTURE
tar -xf $THIS_DIR/$TARGET_ARCHITECTURE.tar -C $THIS_DIR/$TARGET_ARCHITECTURE etc lib opt usr

# remove tar file
rm $THIS_DIR/$TARGET_ARCHITECTURE.tar

# fix the sysroot ld.so.conf file removing the regex and manually inserting all the possibilities
# clear the file
> $THIS_DIR/$TARGET_ARCHITECTURE/etc/ld.so.conf

# copy included files
for filename in $THIS_DIR/$TARGET_ARCHITECTURE/etc/ld.so.conf.d/*; do
    cat ${filename} >> $THIS_DIR/$TARGET_ARCHITECTURE/etc/ld.so.conf
done