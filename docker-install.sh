#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "==> Updating package index..."
sudo apt-get update -y

echo "==> Installing prerequisite packages..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

echo "==> Setting up Docker's official GPG key (forcing overwrite if exists)..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> Setting up the Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Installing Docker Engine and Compose..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "==> Adding current user to the docker group..."
sudo usermod -aG docker $USER

echo "==> Docker installation completed successfully!"