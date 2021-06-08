##
## Plug-in for installing Kali Nethunter Rootless.
##

DISTRO_NAME="Kali Nethunter"
DISTRO_COMMENT="Minimal version, most of utilities should be installed manually."

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
distro_setup() {
	# Fix ~/.bash_profile.
	cat <<- EOF > ./root/.bash_profile
	. /root/.bashrc
	. /root/.profile
	EOF
    printf "\n[*]Resolving apt keys ... \n"
	     axel -o /root/kali-archive-keyring_2020.2_all.deb https://github.com/1X1-Tech/Toolloa/raw/Desktopl-patch/setup%20files/packages/kali-archive-keyring_2020.2_all.deb
	     run_proot_cmd apt install -y kali-archive-keyring_2020.2_all.deb
		 rm -rf kali-archive-keyring_2020.2_all.deb

	run_proot_cmd apt update 
	run_proot_cmd apt install sudo -y
}
