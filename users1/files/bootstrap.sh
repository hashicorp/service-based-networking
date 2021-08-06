#!/bin/bash
#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
#sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
#sudo apt-get update && sudo apt-get install consul

# Add the server config
sudo ln -s /files/client.hcl /etc/consul.d/client.hcl

# Set the Consul token
export CONSUL_TOKEN=$(cat /tokens/users.token)

cat > /etc/consul.d/acl.hcl <<EOF
acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true

  tokens {
    default = "${CONSUL_TOKEN}"
  }
}
EOF

# Add the Consul service registration config for the users service
sudo ln -s /files/users.hcl /etc/consul.d/users.hcl

# Setup the Users service in SystemD
cat <<EOF > /etc/systemd/system/users.service
[Unit]
Description=Users Service
After=network-online.target

[Service]
ExecStart=/usr/bin/fake-service
Environment="LISTEN_ADDR=0.0.0.0:9090"
Environment="NAME=Users"
Environment="MESSAGE=Hello from the Users service"
Restart=always
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=multi-user.target
EOF

# Setup Envoy Service in SystemD
cat <<EOF > /etc/systemd/system/envoy.service
[Unit]
Description=Envoy
After=network-online.target
Wants=consul.service

[Service]
ExecStart=/usr/bin/consul connect envoy -sidecar-for users-1 -envoy-binary /usr/bin/envoy -- -l debug
Environment="CONSUL_HTTP_TOKEN_FILE=/tokens/users.token"
Environment="CONSUL_HTTP_ADDR=https://localhost:8501"
Environment="CONSUL_GRPC_ADDR=https://localhost:8502"
Environment="CONSUL_CACERT=/certs/consul-agent-ca.pem"
Restart=always
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=multi-user.target
EOF

# Restart SystemD
systemctl daemon-reload

systemctl enable consul
systemctl start consul

systemctl enable envoy
systemctl start envoy

systemctl enable users
systemctl start users