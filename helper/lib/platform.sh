#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

UBUNTU_IMAGE='ubuntu:latest'
FEDORA_IMAGE='fedora:latest'
CENTOS7_IMAGE='centos:centos7'
CENTOS8_IMAGE='centos:centos8'

platform::get_image_name(){
    case $(basename "$file" | cut -d- -f1) in
        ubuntu | debian)
            echo "$UBUNTU_IMAGE"
            ;;
        fedora)
            echo "$FEDORA_IMAGE"
            ;;
        centos7)
            echo "$CENTOS7_IMAGE"
            ;;
        centos8)
            echo "$CENTOS8_IMAGE"
            ;;
        *)
            echo "Error: unknown image to be used"
            exit 1
            ;;
    esac
}

platform::debian_setup() {
    export USERNAME="user"
    export USERSHELL="/bin/bash"
    export DEBIAN_FRONTEND=noninteractive
    export TZ=UTC

    apt-get update
    apt-get install -y --no-install-recommends tzdata sudo bat qemu
    groupadd -g 108 kvm
    useradd -m -s $USERSHELL -G kvm $USERNAME
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "export DEBIAN_FRONTEND=noninteractive" >> /home/$USERNAME/.profile
}
