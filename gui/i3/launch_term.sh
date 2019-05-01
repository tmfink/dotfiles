#!/bin/sh
# Launch preferred terminal if possible

TERMS="
    noexec
    alacritty
    gnome-terminal
    terminator
    terminal
    uxterm
    xterm
    "

for term in $TERMS; do
    #"$term" "$@" || echo "Failed to exec $term"
    if hash "$term" > /dev/null 2>&1 ; then
        echo "executing $term"
        exec "$term" "$@"
    else
        echo "$term not available"
    fi
done

echo "Failed to find suitable terminal"
exit 1
