

commit_state="0.01"

##################################################################
# Warning This is not a official installer from microsoft.
# All rights of visual code studio reserved to team microsoft
##################################################################

#################################################################
# This script is intended to work in Termux which is installed with a fs From toolloa
##################################################################


printf "\nSetting Variables... \n"
#######################################################
# CONFIGS
     
     # Downloads Links

vs_arm64="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600638_arm64.deb"
vs_armhf="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600660_armhf.deb"
vs_amd64="https://az764295.vo.msecnd.net/stable/d2e414d9e4239a252d1ab117bd7067f125afd80a/code_1.50.1-1602600906_amd64.deb"
    
    # Download output folder

Filename="Visual_code_release_0v_1.50.1$(uname -m).deb"
filelocation="${HOME}/${Filename}"

#######################################################

function set_links() {
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
        printf"\n \e[1;31m arch $(uname -m) is not supported \e[0m \n"
        ;;
    esac

}

function start() {

## check for preinstalled vscode check for sudo get file and install
    local sudo_user
    
    if [ $(command -v sudo) ]; then
    sudo_user=sudo
    fi

    if [ ! $(command -v code ) ]; then
        set_links
    else
        code_path=$(command -v code)
        printf "\nA preinstalled VS code or an application named \"code\" is found in path \"$code_path\" .."
        sleep 2
        printf "\n Verifying \"$code_path\" ."
        sleep 1
        vs_verify
        case $(vs_verify) in
        0)
            printf "\nTrying to update visual code studio \n\n"
            $sudo_user apt-get upgrade -y code || {
                printf "\n\e[1;31m cant upgrade visual code studio .\e[0m\n"
            }          
        ;;
        1)
           printf "\nFile \"$code_path\" is not vscode"
           printf "\n Renaming \"$code_path\" to \"${code_path}1\""
           mv $code_path ${code_path}1
           sleep 1
           printf "\n running installer ..."
           sleep 2
           set_links
        ;;
        esac
    fi
    printf "\n\e[1;32m Process Complete..\e[0m\n\n"

}
function vs_verify() {

## Basic vscode verifier
    vs_listen=$(code --help | grep -i "Visual Studio Code")

    case $vs_listen in
    "Visual Studio Code"*)
    printf "0"
    ;;
    *)
    printf "1"
    ;;
    esac
}
function vsinstall() {
     
     if [[ -z "$link" ]]; then
     printf "\nCode Failed..."
     else

        if [ ! $(command -v axel) ]; then
        $sudo_user apt-get install -y axel
        fi

        axel -o ${HOME}/${Filename} ${link}
           
        $sudo_user apt install -y .${HOME}/${Filename}
    fi
    if [ ! $(command -v code) ]; then
    printf "\n Failed to install Visual code oss...\n\n"
    else
     case $vs_verify in
     0) printf "\n Visual code installed succesfully.." ;;
     1) printf "\n Installation completed with errors..." ;;
     esac
    fi
    
}
start
