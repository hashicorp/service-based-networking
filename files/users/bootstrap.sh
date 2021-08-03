#!/bin/bash
#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
#sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#sudo apt-get update && sudo apt-get install consul

# Add the server config
sudo ln -s /files/client.hcl /etc/consul.d/client.hcl

systemctl enable consul
systemctl start consul