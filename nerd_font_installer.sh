#!/bin/bash

# Get Latest Release from GitHub
LATEST_RELEASE=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

# Fetch Available Fonts from GitHub
AVAILABLE_FONTS=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/tags/$LATEST_RELEASE | grep -oP '"name": "\K(.*)(?=")' | grep -v "zip")

echo $AVAILABLE_FONTS
