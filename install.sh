#!/usr/bin/env bash

{ # ensure entire script is downloaded #

# Run with:
# curl -o- https://raw.githubusercontent.com/flyrev/pi/main/install.sh | bash

# Delete what we do not need
sudo apt remove -yqq --purge libreoffice*
sudo apt -yqq clean
sudo apt -yqq autoremove

# Run update and upgrade if we haven't done that in a while
[ -z "$(find -H /var/lib/apt/lists -maxdepth 0 -mtime -7)" ] && sudo apt update && sudo apt -yqq upgrade && sudo apt -yqq dist-upgrade && sudo apt -yqq autoremove

sudo apt install -yqq git

# pip
pip install --upgrade pip

# west
pip install --upgrade west

# nRF Connect Tools
export NRF_CONNECT_TOOLS_VERSION=10.15.4
wget -P /tmp -c https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/10-15-4/nrf-command-line-tools_${NRF_CONNECT_TOOLS_VERSION}_arm64.deb
sudo dpkg -i /tmp/nrf-command-line-tools_${NRF_CONNECT_TOOLS_VERSION}_arm64.deb

# nRF Connect SDK
export NRF_SDK_VERSION=v1.9.1
mkdir -p ~/ncs
cd ~/ncs
west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NRF_SDK_VERSION}
west update
west zephyr-export
pip3 install --user -r zephyr/scripts/requirements.txt
pip3 install --user -r nrf/scripts/requirements.txt
pip3 install --user -r bootloader/mcuboot/scripts/requirements.txt
cd -

# Utilities
sudo apt -yqq install screen minicom

} # ensure entire script is downloaded #
