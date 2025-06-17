#!/usr/bin/env bash

set -eu

lock() {
    #swaylock -c 0989b0 "$@"
    hyprlock -c ~/.config/hypr/hyprlock.conf --no-fade-in
}

case "${1:-}" in
    lock)
        lock
        ;;
    suspend)
        lock & disown
        systemctl suspend
        ;;
    hibernate)
        lock & disown
        systemctl hibernate
        ;;
    reboot)
        reboot
        ;;
    shutdown)
        shutdown
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
        ;;
esac
