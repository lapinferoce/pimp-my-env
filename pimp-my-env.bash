#!/usr/bin/env bash

#DISTRO=`grep -ihs "buntu\|SUSE\|Fedora\|PCLinuxOS\|MEPIS\|Mandriva\|Debian\|Damn\|Sabayon\|Slackware\|KNOPPIX\|Gentoo\|Zenwalk\|Mint\|Kubuntu\|FreeBSD\|Puppy\|Freespire\|Vector\|Dreamlinux\|CentOS\|Arch\|Xandros\|Elive\|SLAX\|Red\|BSD\|KANOTIX\|Nexenta\|Foresight\|GeeXboX\|Frugalware\|64\|SystemRescue\|Novell\|Solaris\|BackTrack\|KateOS\|Pardus" /etc/{issue,*release,*version}`

#function install_zsh(){
   #sudo pacman -S zsh       #Archlinux
#   su -c  apt-get install zsh #Debian/Ubuntu
   #sudo  yum install zsh     #RedHat/CentOs
#}


#if which zsh >/dev/null;then
#    echo "zsh found"
#else 
#    install_zsh
#fi

function required {
    if which $1 > /dev/null;then
        echo -n "."
    else
        echo "\nplease install the [$1] package"
    fi
}

function config_zsh {
    cd $HOME
    echo  "ZSH Configuration :"
    select zsh_conf in "oh-my-zsh" "leave default one"; do
            case $REPLY in 
                2)
                    echo ".zshrc leave as is"
                    break;;
                *)
                    wget --no-check-certificate https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
                    break;;
            esac
    done
}

function config_powerline {
    cd $HOME
    echo "POWELINE Configuration"
    select pwl in "skip" "install & setup"; do
        case $REPLY in
            1)
                echo "skipping powerline setup "
                break;;
            *)
                git clone https://github.com/Lokaltog/powerline.git
                cd powerline
                su -c python setup.py install
                echo "$HOME/powerline/powerline/bindings/zsh/powerline.zsh" >> $HOME/.zshrc
                echo "export TERM=xterm-256color"
                mkdir -p $HOME/.config/fontconfig/a
                mkdir -p $HOME/.fonts/
                cp $HOME/powerline/font/PowerlineSymbols.otf  $HOME/.fonts/
                fc-cache -vf $HOME/.fonts/PowerlineSymbols.otf
                mkdir -p $HOME/.config/fontconfig/conf.d/
                cp $HOME/powerline/font/10-powerline-symbols.conf  $HOME/.config/fontconfig/
                break;;
            esac
    done
}

for p in "zsh" "python" "git" "wget" "vim"
do
    required $p
done

config_zsh
config_powerline
