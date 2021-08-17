//
// Create certificates for server
//
exec_remote "bootstrap_server_security" {
  image {
    name = "consul:1.10.1"
  }
  
  working_directory = "/files"

  cmd = "/bin/sh"
  args = [
    "-c", "./bootstrap_server_security.sh"
  ]
  
  volume {
    source = "${data("shared")}/certs/ca"
    destination = "/certs/ca"
  }
  
  volume {
    source = "${data("shared")}/certs/server"
    destination = "/certs/server"
  }
  
  volume {
    source = "${data("shared")}/tokens/gossip"
    destination = "/tokens/gossip"
  }
  
  volume {
    source      = "./files"
    destination = "/files"
  }
}

//
// Consul server node.
//
container "server" {
  depends_on = ["exec_remote.bootstrap_server_security"]

  network {
    name = "network.dc1"
  }

  image {
      //name = "nicholasjackson/ubuntu-systemd:latest"
    name = "nicholasjackson/ubuntu-systemd:consul-${var.consul_version}"
  }

  privileged = true

  port {
    local = 8501
    remote = 8501
    host = 8501
  }
  
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

  volume {
    source      = "${data("shared")}/certs/ca"
    destination = "/certs/ca"
  }
  
  volume {
    source      = "${data("shared")}/certs/server"
    destination = "/certs/server"
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
    key = "CONSUL_HTTP_TOKEN"
    value = "00000000-0000-0000-0000-000000000000"
  }

  env {
    key = "CONSUL_CACERT"
    value = "/certs/ca/consul-agent-ca.pem"
  }

  env {
    key = "CONSUL_CLIENT_CERT"
    value = "/certs/server/dc1-server-consul-0.pem"
  }
   
  env {
    key = "CONSUL_CLIENT_KEY"
    value = "/certs/server/dc1-server-consul-0-key.pem"
  }
}

//
// Install Consul.
//
exec_remote "install_consul" {
  target = "container.server"

  cmd = "bash"
  args = [
    "-c",
    "/files/init.sh",
  ]
}

exec_remote "configure_acl_policy" {
  target = "container.server"
  depends_on = ["exec_remote.install_consul"]

  working_directory = "/files"
  cmd = "bash"
  args = [
    "-c",
    "./configure_policy.sh",
  ]
}