node_name = "server"
data_dir = "/opt/consul"

datacenter = "dc1"

server = true
bootstrap_expect = 1
log_level = "DEBUG"

ui = true

auto_encrypt {
  allow_tls = true
}

verify_incoming_rpc = true
verify_outgoing = true
verify_server_hostname = true

key_file = "/certs/server/dc1-server-consul-0-key.pem"
cert_file = "/certs/server/dc1-server-consul-0.pem"
ca_file = "/certs/ca/consul-agent-ca.pem"

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

acl {
  enabled = true
  default_policy = "deny"
  down_policy    = "extend-cache"
  enable_token_persistence = true

  tokens {
    master = "00000000-0000-0000-0000-000000000000"
  }
}