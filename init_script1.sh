#!/bin/bash

sudo echo "Starting the script"

sudo yum update -y

#install nvm
sudo echo "Installing NVM"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

sudo echo "NODE VERSION: $(node -v)"
sudo echo "NPM VERSION: $(npm -v)"

#open firewall ports
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-port=5000/tcp
sudo firewall-cmd --reload