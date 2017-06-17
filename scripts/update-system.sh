#!/bin/bash


set -x
set -e

if [ "$1" != "nosync" ]; then
        emerge --sync
fi

emerge --update --newuse --deep --with-bdeps=y --complete-graph=y @world
emerge --depclean
revdep-rebuild
emerge @preserved-rebuild
eclean-dist

