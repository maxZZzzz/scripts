#!/bin/bash

SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SDIR"

if [ $1 == "server" ]; then
        TMUX_CONF=tmux/server/.tmux.conf
else
        TMUX_CONF=tmux/desktop/.tmux.conf  
fi

cp $TMUX_CONF ~/
rsync -vaAHD vim/ ~/

