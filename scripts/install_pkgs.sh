#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


if [[ $UID -eq 0 ]]; then
    echo "Do not run as root"
    exit 1
fi

APPS_DIR="$HOME/apps"

# Install packages
sudo apt-get install \
    python python3 terminator wireshark build-essential valgrind \
    ipython ipython3 nasm vim rsync gnome-do nmap gufw git meld pidgin xournal meld \
    pidgin pidgin-otr sshfs proxychains libgmp3-dev libpcap-dev gengetopt \
    links lynx dos2unix openssh-server socat python-scapy screen python-gpgme \
    keepassx lyx texlive-latex-extra texlive-xetex gksu curl python-pip john \
    execstack tmux zsh kpartx cmake hfsprogs pithos python-apt gdb-multiarch \
    binutils-multiarch autotools-dev autoconf mercurial pm-utils xbacklight \
    gawk irssi clang clang-format python-dev python3-dev bless colordiff \
    fonts-font-awesome

mkdir -p "$APPS_DIR"

