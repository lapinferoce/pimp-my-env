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
                chmod a+x ./powerline -Rv
                cd powerline
                su -c python setup.py install
                echo "export TERM=xterm-256color" >> $HOME/.zshrc
                echo ". $HOME/powerline/powerline/bindings/zsh/powerline.zsh" >> $HOME/.zshrc
                mkdir -p $HOME/.config/fontconfig/a
                mkdir -p $HOME/.fonts/
                cp $HOME/powerline/font/PowerlineSymbols.otf  $HOME/.fonts/
                fc-cache -vf $HOME/.fonts/PowerlineSymbols.otf
                mkdir -p $HOME/.config/fontconfig/conf.d/
                cp $HOME/powerline/font/10-powerline-symbols.conf  $HOME/.config/fontconfig/conf.d
                echo "close all your xterm instances on next launch you should have the powerline properly configured or you will have to restart your X server"
                break;;
            esac
    done
}

