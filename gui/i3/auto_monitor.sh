#!/bin/bash
#
# Uses xrandr to detect and setup active outputs

set -euo pipefail

########## 
# Set to name of main display
MAIN_PATTERN="eDP-1"
##########

ACTIVE_OUTPUTS=$(xrandr | grep -oE '^.+ connected' | cut -d" " -f1)
INACTIVE_OUTPUTS=$(xrandr | grep -oE '^.+ disconnected' | cut -d" " -f1)
NUM_ACTIVE_OUTPUTS=$(echo "$ACTIVE_OUTPUTS" | wc -l)

MAIN=$(echo "$ACTIVE_OUTPUTS" | grep "$MAIN_PATTERN")

echo "Found $NUM_ACTIVE_OUTPUTS active outputs"
echo "Active: $(echo $ACTIVE_OUTPUTS | tr '\n' ' ')"
echo "Inactive: $(echo $INACTIVE_OUTPUTS | tr '\n' ' ')"
echo
echo "MAIN: $MAIN"

INACTIVE_OUTPUT_CMD=$(for X in $INACTIVE_OUTPUTS; do echo --output $X --off; done)

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
            --output "$EXTERNAL" --right-of "$MAIN" --auto
        ;;
    *)
        echo "Unsupported number of active outputs: $NUM_ACTIVE_OUTPUTS"
        exit 1
        ;;
esac

# Set touch screen
xinput map-to-output 'SYNAPTICS Synaptics Large Touch Screen' "$MAIN"
