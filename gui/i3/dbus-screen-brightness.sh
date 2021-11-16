#!/bin/sh
# Modify screen brightness in GNOME
# Useful when using i3-gnome settings

# Sources:
# https://chrigl.de/posts/2016/01/23/gnome-3-color-profile-and-screen-brightness.html
# https://unix.stackexchange.com/questions/109568/how-do-i-get-my-laptop-screen-backlight-brightness-controls-to-work

set -eu

PROG="$(basename -- "$0")"

Error() {
    echo "ERROR:" "$@" 1>&2
    exit 1
}

set_brightness() {
    new_level="$1"; shift

    [ $# -eq 0 ] || Error "too many args for set commadn"

    [ "${new_level}" -ge 0 -a ${new_level} -le 100 ] \
        || Error "brightness must be in [0, 100]"

    dbus-send --session --type=method_call \
        --dest="org.gnome.SettingsDaemon.Power" \
        /org/gnome/SettingsDaemon/Power \
        org.freedesktop.DBus.Properties.Set \
        string:"org.gnome.SettingsDaemon.Power.Screen" \
        string:"Brightness" \
        variant:int32:${new_level}
}

brightness_step() {
    dbus-send --session --type=method_call \
      --dest="org.gnome.SettingsDaemon.Power" \
      /org/gnome/SettingsDaemon/Power \
      "org.gnome.SettingsDaemon.Power.Screen.Step${1}"
}

usage() {
    cat << EOF
usage $0: [-h] CMD [args]

-h,--help
    Show help

Examples:
$PROG set 75
$PROG up
$PROG down -5
EOF
}

if [ $# -eq 0 -o $# -gt 2 ]; then
    usage
    exit 1
fi

case "${1:-}" in
    -h|--help)
        usage
        exit
        ;;
    set)
        shift
        set_brightness "$@"
        ;;
    up)
        brightness_step Up
        ;;
    down)
        brightness_step Down
        ;;
    *)
        Error "Unknown option $1"
        ;;
esac

#new_level "$1"
