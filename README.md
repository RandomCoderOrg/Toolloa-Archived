# Toolloa
>ToolLOA is a modified version of proot-distro made to make linux installation for education purpose easier
for termux.
> Basically my modded version of proot-distro

###### see here latest mods [ Unstable ]
https://github.com/SaicharanKandukuri/Toolloa


# Installation
To install dependencies first upgrade your termux packages
```bash
apt update && apt upgrade -y
```
Next install dependencies
```bash
apt install bzip2 axel ncurses-utils tar proot git -y
```
Next get the source of ToolLOA
```bash
git clone https://github.com/1X1-Tech/Toolloa.git
```
Next we need cd to the Toolloa folder give permissions & install the toolloa
```bash
cd Toolloa
chmod +x install-toolloa.sh
./install-toolloa.sh
```
🧐 Toolloa is installed now
# Usage
> - Assuming that you want to install ubuntu 18.04 (bionic)

## To install
```bash
toolloa install bionic
```
## To login to installed distro
```bash
toolloa login bionic
```
## To list Avalible distros
```bash
toolloa list
```

## To re-install installed distro
```bash
toolloa reset bionic
```
> - `reset` argument reinstalles distro by wiping previous installation ( all your data will get lost ) (dosen\`t effect your internal storage)

## To remove installed distro
```bash
toolloa remove bionic
```
> - `remove` argument deletes all files in installed directory (dosen\`t effect your internal storage)

# direct CMD line 
```bash
toolloa login bionic $(echo "Hello World!")
```

###### see in below brackets for distro-alias.
## Avalible distros
- [x] ubuntu 20.10 groovy (groovy)
- [x] ubuntu 20.04 focal (focal)
- [x] ubuntu 18.04 bionic (bionic)
- [x] kali nethunter-rootless (nethunter)
- [x] alpine (alpine)
- [x] arch Linux (archlinux)

> - Old builds like Ubuntu bionic are recomended to install cause Android blocks important syscalls in newer builds like (ubuntu(groovy,focal) , kali nethunter) which lead to problems like kde-desktop crash and etc. Be sure to notice me in issues if you find any problems except `init` dependent in newer builds and common issues so that i can provide more accurate description and docs.

## Tested & supported desktop environment
- [x] xfce4
- [x] mate
- [x] lxde
- [x] lxqt
