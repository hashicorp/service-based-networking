//
// Consul client node.
//
container "users-2" {
  network {
    name = "network.dc1"
  }

  image {
    name = "nicholasjackson/ubuntu-systemd:consul-${var.consul_version}"
  }

  privileged = true

  volume {
    source      = "${data("shared")}/certs/ca"
    destination = "/certs/ca"
  }
  
  volume {
    source      = "${data("shared")}/tokens/users-2"
    destination = "/tokens/users-2"
  }
  
  volume {
    source      = "${data("shared")}/tokens/gossip"
    destination = "/tokens/gossip"
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
    value = "/tokens/users-2/users-2.token"
  }

  env {
    key = "CONSUL_CACERT"
    value = "/local-ca/local-agent-ca.pem"
  }

  # Name of the server for the init scripts 
  env {
    key = "SERVERNAME"
    value = "users-2"
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

exec_local "create_token_folder_users_2" {
  cmd = "mkdir"
  args = [
    "-p",
    "${data("shared")}/tokens/users-2"
  ]
}

exec_remote "generate_token_for_users_2" {
  target = "container.server"
  depends_on = ["exec_remote.configure_acl_policy"]

  cmd = "/bin/bash"
  args = [
    "-c",
    "consul acl token create -policy-name=users --format=json | jq -r .SecretID > /tokens/users-2/users-2.token"
  ]
}

//
// Install Consul.
//
exec_remote "install_consul_users_2" {
  target = "container.users-2"
  depends_on = ["exec_remote.generate_token_for_users_2"]

  cmd = "bash"
  args = [
    "-c",
    "/files/init.sh",
  ]
}