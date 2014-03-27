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

