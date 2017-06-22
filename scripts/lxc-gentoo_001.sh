#!/bin/bash

# config
#SSH_KEY=''
HOST_NUMBER='1'

# script

cat > /etc/conf.d/net <<EOF
config_eth0="dhcp"
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
emerge --ask app-misc/mc vim tmux bash-completion dhcpcd

echo 'set-option -g prefix C-a

set-option -g mouse on

# Active pane border colour
set-option -g pane-active-border-fg yellow
' > /root/.tmux.conf


