#!/bin/sh
# Run the best "vim" we have

VIMS="nvim vim vi"

for v in ${VIMS}; do
    if command -v "$v" ; then
        exec "$v" "$@"
    fi
done

echo "Could not find a vim from list: ${VIMS}" >&2
exit 1
