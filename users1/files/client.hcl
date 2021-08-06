node_name = "users1"
data_dir = "/tmp"
server = false

datacenter = "dc1"

log_level = "DEBUG"

verify_incoming = false
verify_outgoing = true
verify_server_hostname = true

ca_file = "/certs/consul-agent-ca.pem"

retry_join = ["server.container.shipyard.run"]

connect {
  enabled = true
}

addresses {
  https = "0.0.0.0"
  http = "0.0.0.0"
  grpc = "0.0.0.0"
}

ports {
  http = -1,
  https = 8501
  grpc = 8502
}

auto_encrypt {
  tls = true
}