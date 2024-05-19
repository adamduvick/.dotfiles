#!/bin/bash

# Check if the network connection is responsive
if ! ping -c 1 -W 1 (link unavailable) &> /dev/null; then
  # Reload the network connection
  systemctl restart NetworkManager.service
fi
