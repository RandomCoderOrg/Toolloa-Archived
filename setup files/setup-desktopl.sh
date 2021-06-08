#!/bin/bash

script_version="0.1"
commit_state="0.02"

printf "\n[@]Starting setup...."
function Dependencies() {

    if [ ! $(command -v sudo) ]; then
    apt install sudo -y || {
        printf "\n> Error something happened? \n"
    }
    else
    printf "\n> sudo    [\e[1;32m OK \e[0m]\n"
    fi
    if [ ! $(command -v whiptail) ]; then
    sudo apt install whiptail
    else
    printf "\n> whiptail    [\e[1;32m OK \e[0m]\n"
    fi
    if [ ! $(command -v wget) ]; then
    sudo apt install wget -y
    else
    printf "\n> wget  [\e[1;32m OK \e[0m]"
    fi
    #########
    DE
}
function DE(){
    printf "\n> <<<<Starting Desktop setup in 6 seconds.. "
    sleep 6
    printf "[\e[1;32m OK \e[0m]\n"
    sudo apt install kali-linux-core kali-desktop-core -y || {
        printf "\n>   DE setup [\e[1;31m FAIL \e[0m]\n"
        printf "\n>   e[1;35mRetrying \e[1;32min 10 seconds!!\e[0m"
        Dependencies     
    }
    if [ ! $(command -v qterminal) ]; then
    sudo apt remove qtermianl -y
    fi
    sudo apt-get install gnome-terminal xfce* -y
    ## 
    printf "\n> DE setup [\e[1;32m DONE \e[0m]\n"
    create_nonroot_user
    printf "\n> Setting up vnc server in 2 seconds\n"
    sleep 2
    sudo apt-get install tigervnc* -y
    setup_stopvnc
    Setup_startvnc
    mv stopvnc /bin
    mv startvnc /bin
    chmod 777 /bin/startvnc
    chmod 777 /bin/stopvnc
    setup_vnc_password


    ### ##########
    ### Setup apps
    ### ##########
    Install_chromium
    Install_vlc
    install_vs_code
    Install_Libre
    ##### Cleaning
    sudo apt autoclean
    sudo apt clean
    sudo apt autoremove -y
    printf "\e5m Installion Completed\e[0m\n"
}
setup_vnc_password() {
              ## Using whiptail for convinience
			  vnc_passwd=$(whiptail --inputbox "Please a short & sweet password to setup vnc minimum length 6 charecters" 0 50 --title "1x1 Toolloa VNC setup" 3>&1 1>&2 2>&3)
              passwd_length=$(echo -n ${vnc_passwd} | wc -L)

			  if ((${passwd_length} < 6)); then
			  printf "\nYour password lenght ${passwd_length}\n"
			  printf "\n\e[1;31m Your password is too short\e[0m\n"
			  printf "\e[1;35m Try again in 2 secomds"
			  sleep 2
			  setup_vnc_password
			  fi
			  printf "\n> your password is ${vnc_passwd}\n"
			  mkdir -p ~/.vnc
			  cd ~/.vnc
			  echo "${vnc_passwd}" | vncpasswd -f >passwd
			  chmod 600 passwd
			  printf "\n\e[1;32m you can type \e[5m\e[7m startvnc \e[0m to start vnc\n"
			  printf "\n\e[1;32m you can type to \e[5m\e[7m stopvnc \e[0mto stop vnc-server\n"
			  printf "\n \e[7m only works in root for now\e[0m\n"

}
Setup_startvnc() {
		cat > startvnc <<- 'EndOfFile'
		#!/bin/bash
		export USER="${whoami}"
		if [ ${HOME} != '/root' ]; then
		CURRENT_USER_NAME=$(cat /etc/passwd | grep "${HOME}" | awk -F ':' '{print $1}')
		CURRENT_USER_GROUP=$(cat /etc/passwd | grep "${HOME}" | awk -F ':' '{print $5}' | cut -d ',' -f 1)
		if [ -z "${CURRENT_USER_GROUP}" ]; then
		   CURRENT_USER_GROUP=${CURRENT_USER_NAME}
		fi
		CURRENT_USER_VNC_FILE_PERMISSION=$(ls -l ${HOME}/.vnc/passwd | awk -F ' ' '{print $3}')
		if [ "${CURRENT_USER_VNC_FILE_PERMISSION}" != "${CURRENT_USER_NAME}" ];then
		   cd ${HOME}
		   sudo -E chown -R ${CURRENT_USER_NAME}:${CURRENT_USER_GROUP} ".ICEauthority" ".ICEauthority" ".vnc" || su -c "chown -R ${CURRENT_USER_NAME}:${CURRENT_USER_GROUP} .ICEauthority .ICEauthority .vnc"
		fi
		fi
		vncserver -geometry 1280x720 -depth 24 -name DesktopX_1x1 :1

		EndOfFile
	
}
setup_stopvnc() {
		cat > stopvnc <<-'EndOfFile'
		#!/bin/bash
		export USER="${whoami}"
		export HOME="${HOME}"
		CURRENT_PORT=$(cat /bin/startvnc | grep '\-geometry' | awk -F ' ' '$0=$NF' | cut -d ':' -f 2 | tail -n 1)
		vncserver -kill :${CURRENT_PORT}
		rm -rf /tmp/.X1-lock
		rm -rf /tmp/.X11-unix/X1
		pkill Xtightvnc
	EndOfFile
	}
# APP functios
install_vs_code() {
		printf "\nsleeping 5 seconds before installing Code-oss"
        sleep 5
		printf "\n> Installing Official Visual studio ...\n"
        sleep 2
        
        # Links to site : https://code.visualstudio.com/Download#

        vs_arm64="https://az764295.vo.msecnd.net/stable/2b9aebd5354a3629c3aba0a5f5df49f43d6689f8/code_1.54.3-1615805708_arm64.deb"
        vs_armhf="https://az764295.vo.msecnd.net/stable/2b9aebd5354a3629c3aba0a5f5df49f43d6689f8/code_1.54.3-1615805722_armhf.deb"
        vs_amd64="https://az764295.vo.msecnd.net/stable/2b9aebd5354a3629c3aba0a5f5df49f43d6689f8/code_1.54.3-1615806378_amd64.deb"

        Filename="Visual_code_release_0v_1.50.1$(uname -m).deb"
        
        function vsinstall() {   
           axel -o ${HOME}/${Filename} ${link}
           
           sudo apt install -y ${HOME}/${Filename}
        }

        

        case $(uname -m) in
        aarch64)
        link="${vs_arm64}"
        vsinstall
        ;;
        armv7l|armv8l)
        link="${vs_armhf}"
        vsinstall
        ;;
        x86_64)
        link="${vs_amd64}"
        vsinstall
        ;;
        *)
        printf"\n    * \e[1;31m arch $(uname -m) is not supported \e[0m \n"
        ;;
        esac

        
       
}
Install_vlc() {
    printf "\n> Installing VLC\n"
    sleep 2
    if [ ! $(command -v vlc) ]; then
    sudo apt install vlc -y
    else
    printf "\n> vlc [\e[1;32m OK \e[0m]"
    
    fi
    #### setting up VLC to run in root
    sudo sed -i 's/geteuid/getppid' /usr/bin/vlc
}
Install_chromium() {
    printf "\n> Installing chrome! \n"
    printf "\n> Chromium is not set to run as root (due to secrity Reasons)\n"
    sleep 2
    if [ ! $(command -v chromium) ]; then
    sudo apt install chromium -y || {
        sudo apt install chromium -y || {
            printf "\n >Chrome Installation Failed"
        }
    }

    else
    printf "\n> Chromium [\e[1;32m OK \e[0m]"
    fi

}
Install_Libre() {
    if (whiptail --title "1X1 Apps | Setup Libre Office Apps" --yesno "Dou want to install libre office apps.Download size 478mb Installation size 1580mb.Do you want to install?" 0 70); then
    sudo apt install libreoffice -y
    else
    printf "\n> User selected not to install  [\e[1;32m DONE \e[0m]"
    fi
}
####### User add
create_nonroot_user() {
    ###### Usinfg user add with whiptail
    ###############################################
    ## => To create a non root user with admiral rights
    ## 1. check for home directory
    ## 2. make user with adduser
    ## 3. set password if want
    ## 5. Giving sudo permissions


    if [ ! -d /home ]; then
    mkdier /home
    fi
    USER_NAME=$(whiptail --title "1X1 SETUP | Add user" --inputbox "In order to run some majour applications like chromium you need to create a non user.Please enter desired name to create a user" 0 70 0 3>&1 1>&2 2>&3)
    adduser --home /home/$USER_NAME --shell /bin/bash $USER_NAME
    cat << EOF > sudoers

#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL
$USER_NAME    ALL=(ALL:ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
EOF
rm -rf /etc/sudoers
cp sudoers /etc/
printf "\n> $USER_NAME IS added"

}
Dependencies

