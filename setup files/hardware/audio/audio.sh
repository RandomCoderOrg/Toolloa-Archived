#!/data/data/com.termux/files/usr/bin/bash -e
TPREFIX=/data/data/com.termux/files

###############################################
## Setting   Up  Pulseaudio to work in VNC & also in itself
## Logic Version Code : 000\\1x1//000
## Script version=0.0.1


##################################################
## Iam sorry if you cant understand code !!!!!


#########################
### C     O    D    E ###
#########################
##

###############
#Checking up for lock

if [ ! $(command -v 1x1-h-audio-lock) ]; then
printf "\n> No lock found.... Starting ...."
else
     lock=$(1x1-h-audio-lock beep)
    case $lock in
    1)
    printf "\n> lock File found ($TPREFIX/usr/bin/1x1-h-audio-lock).. \n\n"
    printf "\n>This script is already executed in this device\n\n"
    printf "[\e[1;32m Exiting ! \e[0m]"
    exit
    ;;
    *)
    rm -rf $TPREFIX/usr/bin/1x1-h-audio-lock
    ;;
    esac
fi



## Settin up $HOME
case $HOME in
     "/data/data/com.termux/files/home")
     ;;
     *)
     export HOME="/data/data/com.termux/files/home"
     ;;
esac
##Checking for pulse audio presence
if [ ! $(command -v pulseaudio) ]; then
apt update && apt upgrade -y 
apt install pulseaudio -y
else
printf "\n> Pulseaudio [\e[1;32m OK \e[0m]"
fi

###################
### Setting Up pulse audio 
## Setting up to load pulse audio native protocol tcp module ( module-native-protocol-tcp )
## ..... setting up auth-ip-acl to loopback address (127.0.0.1) 
## You can add more by sepereating with semicolon (;)
## setting anonymous value = 1 (true) cause no authentication is required in connecting to loopback service!
## See more in https://www.freedesktop.com/wiki/Software/PulseAudio/Documentation/User/Modules

echo "load-module module-native-potocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ${HOME}/../usr/etc/pulse/default.pa

## Setting up daemon.conf
if ! grep -q "exit-idle-time = -1" ${HOME}/../usr/etc/pulse/daemon.conf; then
		
        sed -i '/exit-idle/d' ${HOME}/../usr/etc/pulse/daemon.conf
		
        echo "exit-idle-time = -1" >> ${HOME}/../usr/etc/pulse/daemon.conf

fi
###################
## Setting up lock to stop errors in re-running

cat > 1x1-h-audio-lock <<- 'EndOfFile'
function lock() {
    echo "1"
}
case $1 in
    beep)
    lock
    ;;
    *)
    exit 1
    ;;
esac
EndOfFile
 mv 1x1-h-audio-lock ${TPREFIX}/usr/bin/
 chmod 777 ${TPREFIX}/usr/bin/1x1-h-audio-lock

##########################
## Running audio test
printf "\n> Audio Fix [\e[1;32m DONE \e[0m]"

printf "\n> Performing tests\n"
if [ ! $(command -v sox) ]; then
apt install sox -y
fi
if [ ! $(command -v wget) ]; then
apt install wget -y 
fi
case $sound_trail in
    "")
    wget -q -o minions.mp3 https://raw.githubusercontent.com/1X1-Tech/Toolloa/extras/Minions_intro_movie-11df12af-5e51-3c55-807d-b4718ec7ab05.mp3

play Minions_intro_movie-11df12af-5e51-3c55-807d-b4718ec7ab05.mp3
printf "did you hear minions sound [y/n] : "
read aa
case $aa in
 y)
 printf "\naudio ok.....\n\n "
 printf "\n##------------------------------------------"
 printf "\nGitHub"
 printf "\n@saicharanKandukuri\n     https://github.com/SaicharanKandukuri\n"
 printf "\n1X1 Tech \n        https://github.com/1X1-Tech/Toolloa\n"
 printf "\n\e[7mLicenced Under GPL 3.0\e[0m\n\n"
 printf "\n##------------------------------------------"
 
 ;;
 n)
 printf "\nWe are constantly working on audio please contact us and share your log\n"
 ;;
 *)
 ;;
 esac
 ;;
 NO)
 ;;
 esac
 ##########################################
 ## A script 1x1Tech @SaicharanKandukuri



