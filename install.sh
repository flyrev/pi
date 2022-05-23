#!/usr/bin/env bash

{ # ensure entire script is downloaded #

# Run with:
# curl -o- https://raw.githubusercontent.com/flyrev/pi/main/install.sh | bash

# Run update and upgrade if we haven't done that in a while
[ -z "$(find -H /var/lib/apt/lists -maxdepth 0 -mtime -7)" ] && sudo apt update && sudo apt -yqq upgrade && sudo apt -yqq dist-upgrade && sudo apt -yqq autoremove

sudo apt install -yqq screen minicom ripgrep moreutils
sudo apt install -yqq libgit2-dev

# nRF Connect Tools
export NRF_CONNECT_TOOLS_VERSION=10.15.4
wget -P /tmp -c https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-15-4/nrf-command-line-tools_${NRF_CONNECT_TOOLS_VERSION}_arm64.deb
sudo dpkg -i /tmp/nrf-command-line-tools_${NRF_CONNECT_TOOLS_VERSION}_arm64.deb

sudo mkdir -p /opt/gnuarmemb
sudo tar xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /opt/gnuarmemb/

sudo apt -yqq install git

pip3 uninstall west
pip3 install west==0.12

# GN
mkdir ${HOME}/gn
cd ${HOME}/gn
wget -c -O gn.zip https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest
unzip gn.zip
rm gn.zip

echo 'export PATH=${HOME}/gn:"$PATH"' >> ${HOME}/.bashrc
source ${HOME}/.bashrc

# Kitware
wget -c https://apt.kitware.com/kitware-archive.sh
sudo bash kitware-archive.sh
sudo apt install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev

# nRF Connect SDK
export NRF_SDK_VERSION=v1.9.1
mkdir -p ~/ncs
cd ~/ncs
python3 -m venv env
. env/bin/activate
pip install --upgrade pip
pip uninstall west
pip install west==0.12
west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NRF_SDK_VERSION}
west update
west zephyr-export
pip3 install -r zephyr/scripts/requirements.txt
pip3 install -r nrf/scripts/requirements.txt
pip3 install -r bootloader/mcuboot/scripts/requirements.txt
cd -

} # ensure entire script is downloaded #
