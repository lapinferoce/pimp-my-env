function config_vim {
    cd $HOME
    echo "VIM Configuration"
    select viml in "skip" "custom configuration" "use full vundle (with powerline support)" ;do
        case $REPLY in
            1)
                echo "skipping vim"
                break;;
            2)
                echo "custom vim"
                default_vim
                break;;
            *)
                wget http://j.mp/spf13-vim3 -O -| sh
                echo "let g:airline_powerline_fonts=1" >> $HOME/.vimrc.before;
                echo "please in vim run :BundleInstall "
                break;;
        esac

    done
}
