function default_vim {
cat<<EOF >> $HOME/.vimrc
include_default_resource vimrc
EOF
}

function default_tmux {
cat<< EOF > $HOME/.tmux.conf
include_default_resource tmux.conf
EOF
}


for p in "zsh" "python" "git" "wget" "vim" "tmux"
do
    required $p
done

config_zsh
config_powerline
config_vim
config_tmux
