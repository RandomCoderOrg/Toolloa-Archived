#!/bin/bash -e
###########################################
## this script is to increase apt in kali

#######################################
## Test results




if [ ! $(commnad -v sudo) ]; then
apt install sudo -y || {
    printf "network FAilure"
    exit
}
fi
printf "\n>"
printf "\n> This scripts is supposed to run only in kali nethunter.Running in any other distributions may cause apt failure!!"
printf "\n> Are you sure and want to continue "
printf "\n Press Enter To continue"
read

###########################
## setting up home
H=$(echo $HOME)
case H in
/root)
printf "\n> [\e[1;32m HOME ok... \e[0m]\n"
;;
"/data/data/com.termux/files/home")
printf "\n[ Opps ] You are running this script in \e[1;32m Termux\e[0m\n"
printf "\n -_-> toolloa install nethunter (To install nethunter)"
printd "\n -_-> toolloa login nethunter (To start nethunter)\n\n"
exit
;;
*)
user=$(whoami)
case $user in
     root)
     export HOME=/root
     ;;
     *)
     printf "\n\e[1;31m Please Run this in root\e[0m\n"
     exit
     ;;
esac
;;
esac
mkdir $HOME/.1x1toolloa
cd $HOME
############################################
## setting up name server
## /etc/resolv.conf
cat > resolv.conf <<- 'EndOfFile'
# Google nameservers (fastest i know)
nameserver 8.8.8.8
nameserver 8.8.4.4
EndOfFile

###############################################
## setting repos to https
cat > sources.lsit <<- 'EndOfFile'
deb https://http.kali.org/kali kali-rolling main contrib non-free
# For source packages
# deb-src https://http.kali.org/kali kali-rolling main contrib non-free
EndOfFile

#################################################
## setting up
if [ -r /etc/resolv.conf ]; then
cp /etc/resolv.conf $HOME/.1x1toolloa
rm -rf /etc/resolv.conf
cp $HOME/resolv.conf /etc/
else
cp $HOME/resolv.conf /etc/ 
fi
if [ -r /etc/apt/sources.list ]; then
cp /etc/apt/sources.list $HOME/.1x1toolloa
rm -rf /etc/apt/source.list
cp $HOME/sources.list /etc/apt/
else
cp $HOME/sources.list /etc/apt/
fi

#######################################
## setting up
apt clean
apt update -y 
printf "\n\e[1;32Process Done \e[0m \n"
