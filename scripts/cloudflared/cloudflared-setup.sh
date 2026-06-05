#!/usr/bin/env bash

read -rsp "Enter Cloudflare tunnel token: " token
echo
sudo mkdir -p /etc/cloudflared
echo "TUNNEL_TOKEN=${token}" | sudo tee /etc/cloudflared/token > /dev/null
sudo chmod 600 /etc/cloudflared/token
echo "Token saved to /etc/cloudflared/token"
