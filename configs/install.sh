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
        git clone git://github.com/altercation/vim-colors-solarized.git
        cd vim-colors-solarized
        git pull

        cd ..
        git clone https://github.com/terryma/vim-multiple-cursors
        cd vim-multiple-cursors
        git pull

        cd ..
        git clone git://github.com/tpope/vim-sensible.git
        cd vim-sensible
        git pull
}

install_tmux "$@"
install_vim "$@"
