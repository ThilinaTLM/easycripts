#!/bin/bash

# Get the current user's username
username=$(whoami)

# Create the aria2 config directory if it doesn't exist
config_dir="/home/${username}/.config/aria2"
mkdir -p "${config_dir}"

# Create the downloads directory
downloads_dir="/home/${username}/downloads"
mkdir -p "${downloads_dir}"

# Create the aria2 daemon config
config_file="${config_dir}/aria2.conf"
cat > "${config_file}" << EOL
dir=${downloads_dir}
file-allocation=trunc
max-connection-per-server=4
max-concurrent-downloads=4
max-overall-download-limit=0
seed-time=0
max-upload-limit=5K
min-split-size=25M
EOL

# Create the aria2 service file
service_file="/etc/systemd/system/aria2.service"
sudo bash -c "cat > '${service_file}'" << EOL
[Unit]
Description=Aria2 RPC Daemon Service
After=network.target

[Service]
User=${username}
Type=simple
ExecStart=/usr/bin/aria2c --console-log-level=warn --enable-rpc --rpc-listen-all --conf-path=${config_file}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd configuration
sudo systemctl daemon-reload

# Enable the aria2 service to start on boot
# sudo systemctl enable aria2.service

# Ask the user if they want to start the service
read -p "Do you want to start the aria2 service now? (y/n) " start_service
if [[ "${start_service,,}" == "y" ]]; then
    sudo systemctl start aria2.service
    echo "Aria2 service started."
else
    echo "Aria2 service not started. You can start it later with 'sudo systemctl start aria2.service'."
fi
