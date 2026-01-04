#!/bin/bash
# Patch tmux-gruvbox to use ASCII characters instead of Powerline symbols
# Run this if you see weird characters in your status bar!

THEME_FILE="$HOME/.tmux/plugins/tmux-gruvbox/src/theme_gruvbox_dark.sh"

if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file not found at $THEME_FILE"
    exit 1
fi

echo "Patching $THEME_FILE to use ASCII characters..."

# Replace Powerline separators with ASCII
#  -> >
#  -> <
#  -> |
#  -> |

sed -i 's//>/g' "$THEME_FILE"
sed -i 's//</g' "$THEME_FILE"
sed -i 's//|/g' "$THEME_FILE"
sed -i 's//|/g' "$THEME_FILE"

echo "Patch complete. Reload tmux (Prefix + r) to see changes."
