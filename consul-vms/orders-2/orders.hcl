//
// Consul client node.
//
container "orders-2" {
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
    source      = "${data("shared")}/tokens/orders-2"
    destination = "/tokens/orders-2"
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
    value = "/tokens/orders-2/orders-2.token"
  }

  env {
    key = "CONSUL_CACERT"
    value = "/local-ca/local-agent-ca.pem"
  }

  # Name of the server for the init scripts 
  env {
    key = "SERVERNAME"
    value = "orders-2"
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

exec_local "create_token_folder_orders_2" {
  cmd = "mkdir"
  args = [
    "-p",
    "${data("shared")}/tokens/orders-2"
  ]
}

exec_remote "generate_token_for_orders_2" {
  target = "container.server"
  depends_on = ["exec_remote.configure_acl_policy"]

  cmd = "/bin/bash"
  args = [
    "-c",
    "consul acl token create -policy-name=orders --format=json | jq -r .SecretID > /tokens/orders-2/orders-2.token"
  ]
}

//
// Install Consul.
//
exec_remote "install_consul_orders_2" {
  target = "container.orders-2"
  depends_on = ["exec_remote.generate_token_for_orders_2"]

  cmd = "bash"
  args = [
    "-c",
    "/files/init.sh",
  ]
}