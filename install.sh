#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define installation directories
INSTALL_DIR="/usr/local/mytool"
BIN_DIR="$INSTALL_DIR/bin"
LOCAL_BIN="/usr/local/bin"

# Create the install directory and bin directory
sudo mkdir -p "$BIN_DIR"

# Copy scripts to the bin directory
sudo cp bin/manage_server.sh "$BIN_DIR/manage_server.sh"
sudo cp bin/setup_nginx.sh "$BIN_DIR/setup_nginx.sh"
sudo cp bin/setup_ssl.sh "$BIN_DIR/setup_ssl.sh"
sudo cp tool.sh "$INSTALL_DIR/"

# Set appropriate permissions
sudo chmod -R 755 "$INSTALL_DIR"

# Ensure correct ownership
sudo chown -R root:root "$INSTALL_DIR"

# Create or update symbolic link in /usr/local/bin
sudo ln -sf "$INSTALL_DIR/tool.sh" "$LOCAL_BIN/mytool"

# Verify installation
if [ -f "$LOCAL_BIN/mytool" ] && [ -x "$INSTALL_DIR/tool.sh" ]; then
  echo "MyTool installed successfully!"
  echo "You can now use the tool by running: mytool <command> [options]"
else
  echo "Installation failed. Please check permissions and try again."
  exit 1
fi
