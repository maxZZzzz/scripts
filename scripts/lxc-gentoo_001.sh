#!/bin/bash

# config
#SSH_KEY=''
HOST_NUMBER='5'

# script

cat > /etc/conf.d/net <<EOF
modules="dhcpcd"

config_eth0="dhcp fd00::$HOST_NUMBER/64"
dhcpcd_eth0="-6"
routes_eth0="fd00::/64"
EOF

cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 boot
rc-update add sshd boot

cd /root
mkdir .ssh
chmod go= .ssh
cd .ssh
echo "${SSH_KEY}" > authorized_keys

echo 'USE="$USE bash-completion"' >> /etc/portage/make.conf
echo 'MAKEOPTS="-j4"' >> /etc/portage/make.conf
emerge app-misc/mc vim tmux bash-completion dhcpcd gentoolkit htop
service net.eth0 restart

echo 'set-option -g prefix C-a

set-option -g mouse on

# Active pane border colour
set-option -g pane-active-border-fg yellow
' > /root/.tmux.conf

mkdir /root/bin
echo '#!/bin/bash


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
' > /root/bin/update-system.sh
chmod +x /root/bin/update-system.sh
