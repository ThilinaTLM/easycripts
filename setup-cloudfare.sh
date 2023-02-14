#!/bin/bash

## ----- DEPENDENCIES ----- ##
# wget - https://www.gnu.org/software/wget/


function install-package() {
    package=$1
    # check package manager 
    if [ -x "$(command -v apt-get)" ]; then
        apt-get install -y $package
    elif [ -x "$(command -v pacman)" ]; then
        pacman -S --noconfirm $package
    else
        echo "No package manager found"
        exit 1
    fi
}

function download-cloudfare() {
    if [ -f "/usr/bin/cloudflared" ]; then
        return
    fi
    if ! [ -x "$(command -v wget)" ]; then
        install-package wget
    fi
    wget -q -nc https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    mv cloudflared-linux-amd64 /usr/bin/cloudflared
    chmod +x /usr/bin/cloudflared
}

function setenv-var() {
    name=$1
    echo "export $name=$name" >> "/etc/environment"
}

function main() {
    kill -9 $(ps aux | grep 'cloudflared' | awk '{print $2}')
    download-cloudfare || exit 1
    kdir -p /var/run/sshd
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

    # setup environment variables
    setenv-var "LD_LIBRARY_PATH"
    setenv-var "COLAB_TPU_ADDR"
    setenv-var "COLAB_GPU"
    setenv-var "TBE_CREDS_ADDR"
    setenv-var "TF_FORCE_GPU_ALLOW_GROWTH"
    setenv-var "TPU_NAME"
    setenv-var "XRT_TPU_CONFIG"

    service ssh start

    # create tunnel
    cloudflared tunnel --url ssh://localhost:22 --logfile ./cloudflared.log --metrics localhost:45678
}
