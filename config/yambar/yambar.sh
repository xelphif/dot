#!/bin/sh

CONFIG_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/yambar"
CONFIG="$CONFIG_DIR/config.yml"

# Any YAML file that is not the main configuration file is assumed
# to be a bar file
BARS=$(find $CONFIG_DIR -name "*.yml" ! -name "config.yml" -printf "%f\n")

if [ -z "$BARS" ]; then
    exit 1
fi

killall -q yambar
while pgrep -x yambar >/dev/null; do sleep 1; done

TMP_DIR=$(mktemp --tmpdir -d "yambar.XXXXXXXXXXX")
for bar in $BARS; do
    cat "$CONFIG" "$CONFIG_DIR/$bar" >> "$TMP_DIR/$bar"
    exec yambar --config "$TMP_DIR/$bar" & disown
done
