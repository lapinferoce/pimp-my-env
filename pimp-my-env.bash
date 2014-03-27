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










function default_vim{
cat <<EOF > $HOME/.vimrc
" ~/.vimrc (configuration file for vim only)
" skeletons
function! SKEL_spec()
        0r /usr/share/vim/current/skeletons/skeleton.spec
        language time en_US
        if $USER != ''
            let login = $USER
        elseif $LOGNAME != ''
            let login = $LOGNAME
        else
            let login = 'unknown'
        endif
        let newline = stridx(login, "\n")
        if newline != -1
            let login = strpart(login, 0, newline)
        endif
        if $HOSTNAME != ''
            let hostname = $HOSTNAME
        else
            let hostname = system('hostname -f')
            if v:shell_error
                let hostname = 'localhost'
            endif
        endif
        let newline = stridx(hostname, "\n")
        if newline != -1
            let hostname = strpart(hostname, 0, newline)
        endif
        exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
        exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
        exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
        setf spec
endfunction
autocmd BufNewFile      *.spec  call SKEL_spec()
"" -----------------------------------------------------------------------------                                                                                                                           ----------
""  custom settings
"" -----------------------------------------------------------------------------                                                                                                                           ----------

" http://www.sukria.net/code/vimrc.html
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
set smartcase                   " ... unless they contain at least one capital l                                                                                                                           etter
""extra
set nocompatible

filetype indent on
set autoindent
set smartindent
"set lbr
set laststatus=2              " barre de status always visible
set statusline=\ %<%f%h%m%r%=%{&ff}\ %l,%c%V\ %P
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\                                                                                                                            %l/%L:%c


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

for p in "zsh" "python" "git" "wget" "vim"
do
    required $p
done

config_zsh
config_powerline
config_vim
