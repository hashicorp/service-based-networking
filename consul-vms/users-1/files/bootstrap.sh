#!/bin/bash

# Fetch the CA that can be used to securely access the local agent API endpoints
curl -s --cacert /certs/consul-agent-ca.pem https://server.container.shipyard.run:8501/v1/connect/ca/roots?pem=true > /certs/local-agent-ca.pem

# Set the Consul token and encryption key
export CONSUL_HTTP_TOKEN="$(cat /tokens/users.token)"
export GOSSIP_KEY="$(cat /tokens/gossip.key)"
export CONSUL_HTTP_ADDR="https://localhost:8501"
export CONSUL_GRPC_ADDR="https://localhost:8502"
export CONSUL_CACERT="/certs/local-agent-ca.pem"

# Setup the systemd unit for consul
mkdir -p /etc/consul.d
mkdir -p /opt/consul

cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/consul.d/acl.hcl
acl {
  enabled = true
  default_policy = "deny"
  down_policy    = "extend-cache"
  enable_token_persistence = true

  tokens {
    default = "${CONSUL_HTTP_TOKEN}"
  }
}

encrypt = "${GOSSIP_KEY}"
EOF

# Setup Envoy proxy in SystemD
cat <<EOF > /etc/systemd/system/envoy.service
[Unit]
Description=Envoy
After=network-online.target
Wants=consul.service

[Service]
ExecStart=/usr/bin/consul connect envoy -sidecar-for users-1 -envoy-binary /usr/bin/envoy -- -l debug
Environment="CONSUL_HTTP_TOKEN=${CONSUL_HTTP_TOKEN}"
Environment="CONSUL_CACERT=${CONSUL_CACERT}"
Environment="CONSUL_HTTP_ADDR=${CONSUL_HTTP_ADDR}"
Environment="CONSUL_GRPC_ADDR=${CONSUL_GRPC_ADDR}"
Restart=always
RestartSec=5
StartLimitIntervalSec=0

[Install]
WantedBy=multi-user.target
EOF

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


# Add the consul agent config
sudo ln -s /files/config.hcl /etc/consul.d/config.hcl

# Restart SystemD
systemctl daemon-reload

systemctl enable consul
systemctl start consul

systemctl enable envoy
systemctl start envoy
#
systemctl enable users
systemctl start users

# Wait for the agent to come up then register the service
until curl -s -k https://localhost:8501/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done

# Add the Consul service registration config for the users service
#sudo ln -s /files/users-service.hcl /etc/consul.d/users-service.hcl
consul services register /files/users-service.hcl