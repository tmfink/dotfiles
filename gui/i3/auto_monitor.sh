#!/bin/bash
#
# Uses xrandr to detect and setup active outputs
#
# direction: left|right|above|below
#    default: right

set -euo pipefail

##########
# Set to name of main display
MAIN_MONITOR="${MAIN_MONITOR:-eDP}"
##########

usage() {
    echo "$0: [-h] [left|right|above|below]"
    exit 1
}

for arg in "$@"; do
    case $arg in
    -h|--help) usage ;;
    *) ;;
    esac
done

ACTIVE_OUTPUTS=$(xrandr | grep -oE '^.+ connected' | cut -d" " -f1)
INACTIVE_OUTPUTS=$(xrandr | grep -oE '^.+ disconnected' | cut -d" " -f1)
NUM_ACTIVE_OUTPUTS=$(echo "$ACTIVE_OUTPUTS" | wc -l)

MAIN=$(echo "$ACTIVE_OUTPUTS" | grep "$MAIN_MONITOR")

echo "Found $NUM_ACTIVE_OUTPUTS active outputs"
echo "Active: $(echo $ACTIVE_OUTPUTS | tr '\n' ' ')"
echo "Inactive: $(echo $INACTIVE_OUTPUTS | tr '\n' ' ')"
echo
echo "MAIN: $MAIN"

INACTIVE_OUTPUT_CMD=$(for X in $INACTIVE_OUTPUTS; do echo --output $X --off; done)

EXTERNAL_DIR=${1:-right}

case $EXTERNAL_DIR in
left|right)
    DIRECTION_ARG="--${EXTERNAL_DIR}-of"
    ;;
above|below)
    DIRECTION_ARG="--${EXTERNAL_DIR}"
    ;;
*)
    echo "Unsupported direction ${EXTERNAL_DIR}" 1>&2
    exit 1
    ;;
esac



case $NUM_ACTIVE_OUTPUTS in
    0)
        echo "Error: found no active outputs"
        exit 1
        ;;
    1)
        echo "Found one active output"
        OUTPUT="$ACTIVE_OUTPUTS"
        xrandr $INACTIVE_OUTPUT_CMD --output $OUTPUT --auto --primary
        ;;
    2)
        echo "Found two active outputs"
        EXTERNAL=$(echo "$ACTIVE_OUTPUTS" | grep -v "^${MAIN}$")
        echo "external is $EXTERNAL"
        xrandr $INACTIVE_OUTPUT_CMD --output "$MAIN" --auto --primary \
            --output "$EXTERNAL" "${DIRECTION_ARG}" "$MAIN" --auto
        ;;
    *)
        echo "Unsupported number of active outputs: $NUM_ACTIVE_OUTPUTS"
        exit 1
        ;;
esac

# Set touch screen
#xinput map-to-output 'SYNAPTICS Synaptics Large Touch Screen' "$MAIN"
