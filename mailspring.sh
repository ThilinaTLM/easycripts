#!/bin/sh
#read -s _UNLOCK_PASSWORD || return
_UNLOCK_PASSWORD=TLM98@manjaro
killall -q -u "$(whoami)" gnome-keyring-daemon
eval $(echo -n "${_UNLOCK_PASSWORD}" \
           | gnome-keyring-daemon --daemonize --login \
           | sed -e 's/^/export /')
unset _UNLOCK_PASSWORD
echo '' >&2
mailspring -b &!
