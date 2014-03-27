function config_tmux {
    cd $HOME
    echo "TMUX Configuration"
    select viml in "skip" "custom configuration" "with powerline support (not yet implemented)" ;do
        case $REPLY in
            1)
                echo "skipping tmux"
                break;;
            2)
                echo "custom tmux"
                default_tmux
                break;;
            *)
                echo "xxx not yet implemented xxx "
                break;;
        esac

    done
}
