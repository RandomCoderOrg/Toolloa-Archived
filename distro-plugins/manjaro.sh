 
DISTRO_NAME="Manjaro"
DISTRO_COMMENT="Official Build is only avalible for aarch64 arch based Android devices "

get_download_url() {
	case "$(uname -m)" in
		aarch64)
			echo "https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro-arm/.rootfs/Manjaro-ARM-aarch64-latest.tar.gz"
			;;
		    *)
            exit
	esac
}
# Define here additional steps which should be executed
# for configuration.
distro_setup() {
folder=""
folder=/data/data/com.termux/files/usr/var/lib/toolloa/installed-rootfs/manjaro
cat > $folder/etc/pacman.d/mirrorlist <<'EOL'
##
## Manjaro Linux repository mirrorlist
## Generated on 02 May 2020 14:22
##
## Use pacman-mirrors to modify
##
## Location  : Germany
## Time      : 99.99
## Last Sync :
Server = http://manjaro-arm.moson.eu/arm-stable/$repo/$arch/
EOL
rm -rf $folder/etc/resolv.conf && echo "nameserver 1.1.1.1" > $folder/etc/resolv.conf
echo "pacman-mirrors -g -c  Japan && pacman -Syyuu --noconfirm && pacman-key --init && pacman-key --populate && pacman -Syu --noconfirm" > $folder/usr/local/bin/fix-repo
chmod +x $folder/usr/local/bin/fix-repo
rm -rf $folder/root/.bash_profile && echo "pacman-key --init && pacman-key --populate && pacman -Syu --noconfirm && rm -rf ~/.bash_profile" > $folder/root/.bash_profile

}
