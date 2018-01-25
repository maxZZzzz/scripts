#!/bin/bash

# config


# script
configure_net() {
    cat > /etc/conf.d/net <<EOF
modules="dhcpcd"

config_eth0="10.2.55.${HOST_NUMBER}
fd00::${HOST_NUMBER}/64"
routes_eth0="10.2.0.0/16
fd00::/64
default via 10.2.0.1"
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
    
    /etc/init.d/net.eth0 restart
}

configure_profile() {
    eselect profile set default/linux/amd64/17.0

    mkdir /root/bin
    cat > /root/bin/update-system.sh <<EOF
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
EOF
    chmod +x /root/bin/update-system.sh

    /root/bin/update-system.sh nosync
}

configure_shell() {
    
    local content="$(cat /etc/portage/make.conf | sed -e 's/^USE="bindist"$/#USE="bindist/')"
    echo "$content" > /etc/portage/make.conf
    echo 'USE="$USE bash-completion"' >> /etc/portage/make.conf
    echo 'MAKEOPTS="-j4"' >> /etc/portage/make.conf
    emerge app-misc/mc vim tmux bash-completion gentoolkit htop dev-vcs/git netcat
    
    cat >/root/.tmux.conf <<EOF
set-option -g prefix C-a
bind a send-prefix

set-option -g mouse on

# Active pane border colour
set-option -g pane-active-border-fg yellow
EOF

}

configure_avahi() {
    emerge net-dns/avahi sys-auth/nss-mdns
    rc-update add avahi-daemon default
    local content=$(cat /etc/nsswitch.conf  | sed -e 's/\(hosts:.*\)/\1 mdns/')
    echo  "$content" > /etc/nsswitch.conf
}

configure_cron() {
    echo 'mail-mta/exim -X maildir mbx syslog' > /etc/portage/package.use/exim
    echo 'mail-client/mutt doc gpg gpgme mbox smime hcache idn' > /etc/portage/package.use/mutt
    
    emerge mutt exim vixie-cron
    
    rc-update add exim
    rc-update add vixie-cron
    
    local content="$(cat /etc/crontab | sed -e 's/MAILTO=root/MAILTO=admin/')"
    echo "$content" > /etc/crontab
    
    useradd -ms /bin/bash admin
    cat > /root/.muttrc << EOF
# character set on sent messages
set send_charset="utf-8"
# if there is no character set given on incoming messages, it is probably windows
set assumed_charset="iso-8859-1"

# make sure Vim knows Mutt is a mail client and that a UTF-8 encoded message will be composed
set editor="vim -c 'set syntax=mail ft=mail enc=utf-8'"
# just scroll one line instead of full page
set menu_scroll=yes

# threading preferences, sort by threads
set sort=threads
set strict_threads=yes

set mbox_type="Maildir"
set folder="~/.maildir"
set mbox="~/.maildir"
set record="+.sent"
set postponed="+.drafts"
set spoolfile="~/.maildir"
EOF
    
    install -o admin -g admin /root/.muttrc ~admin/.muttrc
}

configure_net
configure_profile
configure_shell
configure_avahi
configure_cron

openrc
