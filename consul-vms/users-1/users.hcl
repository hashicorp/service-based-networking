//
// Consul client node.
//
container "users-1" {
  network {
    name = "network.dc1"
  }

  image {
    name = "nicholasjackson/ubuntu-systemd:consul-${var.consul_version}"
  }

  privileged = true

  volume {
    source      = "${data("shared")}/certs"
    destination = "/certs"
  }
  
  volume {
    source      = "${data("shared")}/tokens"
    destination = "/tokens"
  }

  volume {
    source      = "./files"
    destination = "/files"
  }

  env {
    key = "CONSUL_HTTP_ADDR"
    value = "https://localhost:8501"
  }
  
  env {
    key = "CONSUL_GRPC_ADDR"
    value = "https://localhost:8502"
  }

  env {
    key = "CONSUL_HTTP_TOKEN_FILE"
    value = "/tokens/users.token"
  }

  env {
    key = "CONSUL_CACERT"
    value = "/certs/local-agent-ca.pem"
  }

  # Tmp volumes required by SystemD
  volume {
    type = "tmpfs"
    source      = ""
    destination = "/sys/fs/cgroup"
  }
 
  volume {
    source      = ""
    destination = "/tmp"
    type = "tmpfs"
  }

  volume {
    source      = ""
    destination = "/run"
    type = "tmpfs"
  }

  volume {
    source      = ""
    destination = "/run/lock"
    type = "tmpfs"
  }
}

exec_remote "generate_token_for_users" {
  target = "container.server"
  depends_on = ["exec_remote.configure_acl_policy"]

  cmd = "/bin/bash"
  args = [
    "-c",
    "consul acl token create -policy-name=users --format=json | jq -r .SecretID > /tokens/users.token"
  ]
}

//
// Install Consul.
//
exec_remote "install_consul_users" {
  target = "container.users-1"
  depends_on = ["exec_remote.generate_token_for_users"]

  cmd = "bash"
  args = [
    "-c",
    "/files/bootstrap.sh",
  ]
}