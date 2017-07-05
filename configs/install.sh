#!/bin/bash

SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SDIR"

install_tmux() {
        if [ "$1" == "server" ]; then
                TMUX_CONF=tmux/server/.tmux.conf
        else
                TMUX_CONF=tmux/desktop/.tmux.conf  
        fi

        cp $TMUX_CONF ~/
}

install_vim() {
        rsync -vaAHD vim/ ~/

        mkdir -p ~/.vim/bundle

        cd ~/.vim/bundle
        git clone https://github.com/VundleVim/Vundle.vim.git
}

install_tmux "$@"
install_vim "$@"
