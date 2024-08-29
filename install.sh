#!/bin/bash

# Install directory
INSTALL_DIR="/usr/local/mytool"

# Create the install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
  sudo mkdir -p "$INSTALL_DIR"
fi

# Copy the scripts to the install directory
sudo cp -r bin "$INSTALL_DIR/"
sudo cp tool.sh "$INSTALL_DIR/"

# Create a symbolic link to the main tool script in /usr/local/bin
sudo ln -sf "$INSTALL_DIR/tool.sh" /usr/local/bin/mytool

echo "Tool installed successfully!"
echo "You can now run the tool using the 'mytool' command."
