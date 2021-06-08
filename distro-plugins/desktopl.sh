#
# Plug-In for Toolloa 
#
DISTRO_NAME="DesktopL"
DISTRO_COMMENT="This a tweaked version of kali xfce for termux with minimal DE"

# Rootfs is in subdirectory.
DISTRO_TARBALL_STRIP_OPT=1

# Returns download URL.
get_download_url() {
	case "$(uname -m)" in
		aarch64)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-arm64-minimal.tar.xz"
			;;
		armv7l|armv8l)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-armhf-minimal.tar.xz"
			;;
		i686)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-i386-minimal.tar.xz"
			;;
		x86_64)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-amd64-minimal.tar.xz"
			;;
	esac
}


# Define here additional steps which should be executed
# for configuration.
# this where twaking Goes
distro_setup() {
	# Fix ~/.bash_profile.
	cat <<- EOF > ./root/.bash_profile
	. /root/.bashrc
	. /root/.profile
	EOF
    	# Setting up GPG keys
         printf "\n[*]Resolving apt keys ... \n"
	     axel https://github.com/1X1-Tech/Toolloa/raw/Desktopl-patch/setup%20files/packages/kali-archive-keyring_2020.2_all.deb
	     run_proot_cmd apt install -y /kali-archive-keyring_2020.2_all.deb
		 rm -rf /kali-archive-keyring_2020.2_all.deb

		 run_proot_cmd apt update
		 run_proot_cmd apt install sudo -y
		 run_proot_cmd apt upgrade -y || {
			 run_proot_cmd apt upgrade -y
		 }
		 

         printf "\n[*]Setting up base file\n"
	     axel -o setup-desktopl.sh https://raw.githubusercontent.com/1X1-Tech/Toolloa/master/setup%20files/setup-desktopl.sh
         run_proot_cmd chmod +x /setup-desktopl.sh
	     run_proot_cmd bash /setup-desktopl.sh
}
	
