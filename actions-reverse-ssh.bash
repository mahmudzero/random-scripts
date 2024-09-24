#!/usr/bin/env bash

# Add this as a stage in a GitHub Action to have it open a tunnel through some PROVIDER

set -e
[ -n "$DEBUG" ] && set -x

ssh_tunnel() {
  # get a reverse ssh tunnel going
  echo "::group:: reverse ssh tunnel for debug"
  sudo apt update
  sudo apt install openssh-server
  sudo ufw allow ssh
  sudo systemctl restart ssh
  
  mkdir -p ~/.ssh
  
  echo $MAHMUDZERO_DEBUG_PUB_KEY >> ~/.ssh/authorized_keys
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
  
  ssh-keygen -f ~/.ssh/actions_reverse_ssh -N "" -t rsa
  cat ~/.ssh/actions_reverse_ssh.pub
  ls -lah ~/.ssh
  sleep 30
  
  ssh -fN -i ~/.ssh/actions_reverse_ssh -o StrictHostKeyChecking=no -R 4096:localhost:22 azureuser@$MAHMUDZERO_DEBUG_IP
  echo "ssh -p 4096 $USER@IP"
  echo "sleeping waiting on go command"
  while [[ ! -f /tmp/ssh-sleep ]] ; do
    sleep 15
  done
  echo "::endgroup::"
}
