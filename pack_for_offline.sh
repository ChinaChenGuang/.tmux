#!/bin/bash
set -e

OUTPUT_FILE="tmux_offline_installer.tar.gz"
STAGING_DIR="tmux_offline_installer"

# Cleanup previous run
rm -rf "$STAGING_DIR" "$OUTPUT_FILE"

echo "Creating staging directory..."
mkdir -p "$STAGING_DIR/dot_tmux"

echo "Copying configuration files..."
cp .tmux.conf "$STAGING_DIR/dot_tmux/"
# Copy plugins
cp -r plugins "$STAGING_DIR/dot_tmux/"

# Copy patch script
cp patch_status_bar.sh "$STAGING_DIR/dot_tmux/"
cp restore_status_bar.sh "$STAGING_DIR/dot_tmux/"
cp copy_wrapper.sh "$STAGING_DIR/dot_tmux/"

# Remove .git directories to save space and avoid issues on offline server
echo "Cleaning up .git directories from plugins..."
find "$STAGING_DIR/dot_tmux/plugins" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true

# Create install script
echo "Creating install script..."
cat > "$STAGING_DIR/install.sh" << 'EOF'
#!/bin/bash
set -e

TMUX_DIR="$HOME/.tmux"
TMUX_CONF="$HOME/.tmux.conf"
BACKUP_SUFFIX="_backup_$(date +%Y%m%d_%H%M%S)"

echo "Installing tmux configuration..."

# Backup existing config
if [ -d "$TMUX_DIR" ]; then
    echo "Backing up existing $TMUX_DIR to ${TMUX_DIR}${BACKUP_SUFFIX}"
    mv "$TMUX_DIR" "${TMUX_DIR}${BACKUP_SUFFIX}"
fi

if [ -f "$TMUX_CONF" ] && [ ! -L "$TMUX_CONF" ]; then
    echo "Backing up existing $TMUX_CONF to ${TMUX_CONF}${BACKUP_SUFFIX}"
    mv "$TMUX_CONF" "${TMUX_CONF}${BACKUP_SUFFIX}"
fi

if [ -L "$TMUX_CONF" ]; then
    echo "Removing existing symlink $TMUX_CONF"
    rm "$TMUX_CONF"
fi

# Install new config
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Copying configuration to $TMUX_DIR..."
cp -r "$SCRIPT_DIR/dot_tmux" "$TMUX_DIR"

# Create symlink
echo "Creating symlink for .tmux.conf..."
ln -s "$TMUX_DIR/.tmux.conf" "$TMUX_CONF"

echo "Installation complete."
echo "If tmux is running, reload it with: tmux source-file ~/.tmux.conf"
EOF

chmod +x "$STAGING_DIR/install.sh"

echo "Creating archive $OUTPUT_FILE..."
tar -czf "$OUTPUT_FILE" "$STAGING_DIR"

echo "Cleaning up staging directory..."
rm -rf "$STAGING_DIR"

echo "Done! Package created: $OUTPUT_FILE"
echo ""
echo "Instructions for the offline server:"
echo "1. Upload $OUTPUT_FILE to the server."
echo "2. Run: tar -xzf $OUTPUT_FILE"
echo "3. Run: cd $STAGING_DIR"
echo "4. Run: ./install.sh"
