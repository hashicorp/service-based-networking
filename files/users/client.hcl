node_name = "users"
data_dir = "/tmp"
server = false

datacenter = "dc1"

log_level = "DEBUG"

verify_outgoing = true

ca_file = "/certs/consul-agent-ca.pem"

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

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true

  tokens {
    master = "00000000-0000-0000-0000-000000000000"
  }
}