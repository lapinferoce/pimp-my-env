#!/usr/bin/env bash

function required {
    if which $1 > /dev/null;then
        echo -n "."
    else
        echo "\nplease install the [$1] package with your favortie package manager "
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
                echo "export TERM=xterm-256color" >> $HOME/.zshrc
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

function config_vim {
    cd $HOME
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
function config_tmux {
    cd $HOME
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





function default_vim {
cat<<EOF >> $HOME/.vimrc
" -----------------------------------------------------------------------------
"  custom settings
" ----------------------------------------------------------------------------
set background=light
set t_Co=256
colorscheme default

syntax on
set nocompatible                " choose no compatibility with legacy vi
"set nu                          " line number
"set autowrite                   " save file
"set spell                       " set spell checker set nospell to remove
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set wrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital 
""extra
set nocompatible

filetype indent on
set autoindent
set smartindent
"set lbr
set laststatus=2              " barre de status always visible
set statusline=\ %<%f%h%m%r%=%{&ff}\ %l,%c%V\ %P
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\%l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

" line number
set numberwidth=10
set cpoptions+=n
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

"" custom commands
" ln show or hide line numbers
cmap ln set invnumber<CR>
EOF
}

function default_tmux {
cat<< EOF > $HOME/.tmuxrc
 use UTF8
set -g utf8
set-window-option -g utf8 on

# make tmux display things in 256 colors
set -g default-terminal "screen-256color"

# set scrollback history to 10000 (10k)
set -g history-limit 10000

# set Ctrl-a as the default prefix key combination
# and unbind C-b to free it up
set -g prefix C-a
unbind C-b

# use send-prefix to pass C-a through to application
bind C-a send-prefix

# shorten command delay
set -sg escape-time 1

# set window and pane index to 1 (0 by default)
set-option -g base-index 1
setw -g pane-base-index 1

# reload ~/.tmux.conf using PREFIX r
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# use PREFIX | to split window horizontally and PREFIX - to split vertically
bind | split-window -h
bind - split-window -v

# Make the current window the first window
bind T swap-window -t 1

# map Vi movement keys as pane movement keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# and use C-h and C-l to cycle thru panes
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# resize panes using PREFIX H, J, K, L
bind H resize-pane -L 5
bind J resize-pane -D 5
bind K resize-pane -U 5
bind L resize-pane -R 5

# explicitly disable mouse control
setw -g mode-mouse off
set -g mouse-select-pane off
set -g mouse-resize-pane off
set -g mouse-select-window off

# ---------------------
# Copy & Paste
# ---------------------
# provide access to the clipboard for pbpaste, pbcopy
set-option -g default-command "reattach-to-user-namespace -l zsh"
set-window-option -g automatic-rename on

# use vim keybindings in copy mode
setw -g mode-keys vi

# setup 'v' to begin selection as in Vim
bind-key -t vi-copy v begin-selection
bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

# update default binding of 'Enter' to also use copy-pipe
unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"

bind y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '
bind C-y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '

# ----------------------
# set some pretty colors
# ----------------------
# set pane colors - hilight the active pane
set-option -g pane-border-fg colour235 #base02
set-option -g pane-active-border-fg colour240 #base01

# colorize messages in the command line
set-option -g message-bg black #base02
set-option -g message-fg brightred #orange

# ----------------------
# Status Bar
# -----------------------
set-option -g status on                # turn the status bar on
set -g status-utf8 on                  # set utf-8 for the status bar
set -g status-interval 5               # set update frequencey (default 15 seconds)
set -g status-justify centre           # center window list for clarity
# set-option -g status-position top    # position the status bar at top of screen

# visual notification of activity in other windows
setw -g monitor-activity on
set -g visual-activity on

# set color for status bar
set-option -g status-bg colour235 #base02
set-option -g status-fg yellow #yellow
set-option -g status-attr dim 

# set window list colors - red for active and cyan for inactive
set-window-option -g window-status-fg brightblue #base0
set-window-option -g window-status-bg colour236 
set-window-option -g window-status-attr dim
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
