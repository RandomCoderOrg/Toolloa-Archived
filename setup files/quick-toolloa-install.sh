#!/bin/bash
apt_exit_status=$(apt install axel ; echo $?)

if [[ $apt_exit_status == 100 ]]; then
    apt update && apt upgrade -y
else
    apt upgrade -y
fi

apt install -y git proot ncurses-utils tar axel || {
    exit_stat=1
}

if [[ -d "Toolloa" ]]; then
    rm -rvf Toolloa
fi

if [[ -z ${tbranch} ]]; then
    branch=master
else
    branch=${tbranch}
fi

function install() {
    clear

    echo "[*] Cloning Toolloa [${branch}]"
    git clone -b ${branch} https://github.com/1X1-Tech/Toolloa.git
    echo "[*] Installing ..."
    cd Toolloa
    bash install-toolloa.sh

    if [ $(command -v toolloa) ]; then
        echo "[*] Installation completed"
    fi

}

if (($exit_stat != 1)); then
    install
fi