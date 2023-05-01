#!/bin/bash

# Update package list and install required dependencies
sudo apt update

# Install aria2
sudo apt install -y aria2

# Verify installation
aria2_version=$(aria2c --version | head -n 1)
echo "Aria2 has been installed successfully: ${aria2_version}"
