#!/bin/sh -e

# Bootstrap the gossip encryption key
consul keygen > /tokens/gossip/gossip.key

# Create the CA for securing the servers
cd /tmp
if [ ! -f /certs/ca/consul-agent-ca.pem ]; then
  consul tls ca create 
  mv consul-agent-ca-key.pem /certs/consul-agent-ca-key.pem
  mv consul-agent-ca.pem /certs/ca/consul-agent-ca.pem
fi

# Create the server certs
cd /certs/server
if [ ! -f dc1-server-consul-0.pem ]; then
  consul tls cert create \
    -server \
    -dc dc1 \
    -node consul \
    -ca /certs/ca/consul-agent-ca.pem \
    -key /certs/consul-agent-ca-key.pem \
    -additional-dnsname server.container.shipyard.run
fi