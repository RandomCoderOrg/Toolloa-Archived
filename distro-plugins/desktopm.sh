#
# Plug-In for Toolloa 
#
DISTRO_NAME="DesktopM"
DISTRO_COMMENT="Official Full kali-nethunter with kali-tools- (1.3+Gb download size!)"

# Rootfs is in subdirectory.
DISTRO_TARBALL_STRIP_OPT=1

# Returns download URL.
get_download_url() {
	case "$(uname -m)" in
		aarch64)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-arm64-full.tar.xz"
			;;
		armv7l|armv8l)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-armhf-full.tar.xz"
			;;
		i686)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-i386-full.tar.xz"
			;;
		x86_64)
			echo "https://build.nethunter.com/kalifs/kalifs-latest/kalifs-amd64-full.tar.xz"
			;;
	esac
}

distro_setup() {
	# Fix ~/.bash_profile.
	cat <<- EOF > ./root/.bash_profile
	. /root/.bashrc
	. /root/.profile
	EOF
    printf "\n Making Updates.. Please wait \n"

	run_proot_cmd touch install.log
	run_proot_cmd apt update >> install.log
    install_vs_code() {

        printf "\n[*]Resolving apt keys ... \n"
	    axel -o /root/kali-archive-keyring_2020.2_all.deb https://github.com/1X1-Tech/Toolloa/raw/Desktopl-patch/setup%20files/packages/kali-archive-keyring_2020.2_all.deb
	    run_proot_cmd apt install -y kali-archive-keyring_2020.2_all.deb
		run_proot_cmd rm -rf kali-archive-keyring_2020.2_all.deb


		printf "\nsleeping 5 seconds before installing Code-oss"
        sleep 5
		printf "\n> \e[1;32mInstalling \e[1;35mOfficial Visual studio ...\e[0m\n"
        sleep 2
		# link of latest version https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600638_arm64.deb
        # https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600660_armhf.deb

        vs_arm64="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600638_arm64.deb"
        vs_armhf="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600660_armhf.deb"
        vs_amd64="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600906_amd64.deb"

        Filename="Visual_code_release_0v_1.50.1$(uname -m).deb"
        
        function vsinstall() {   
           axel -o ${Filename} ${link}
           
           run_proot_cmd sudo apt install -y ${HOME}/${Filename}
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

}
	