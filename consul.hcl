//
// Create CA certificate.
//
exec_remote "create_ca" {
  image {
    name = "consul:1.9.5"
  }
  
  working_directory = "/certs"

  cmd = "consul"
  args = [
    "tls",
    "ca",
    "create"
  ]
  
  volume {
    source = "${data("shared")}/certs"
    destination = "/certs"
  }
}

//
// Create certificates.
//
exec_remote "create_certs" {
  depends_on = ["exec_remote.create_ca"]

  image {
    name = "consul:1.9.5"
  }
  
  working_directory = "/certs"

  cmd = "consul"
  args = [
    "tls",
    "cert",
    "create",
    "-server",
    "-dc", "dc1",
    "-node", "consul",
    "-ca", "/certs/consul-agent-ca.pem",
    "-key", "/certs/consul-agent-ca-key.pem"
  ]
  
  volume {
    source = "${data("shared")}/certs"
    destination = "/certs"
  }
}

//
// Consul server node.
//
container "consul" {
  depends_on = ["exec_remote.create_certs"]

  network {
      name = "network.dc1"
  }

  image {
      name = "ubuntu-systemd"
  }

  privileged = true

  volume {
    source      = "/sys/fs/cgroup"
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

  // Temporarily add this here until volume on exec_remote works.
  volume {
    source = "./files/bootstrap.sh"
    destination = "/files/bootstrap.sh"
  }

  volume {
    source      = "${data("shared")}/certs"
    destination = "/certs"
  }

  volume {
    source      = "./files/server.hcl"
    destination = "/etc/consul.d/server.hcl"
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
    value = "/certs/consul-agent-ca.pem"
  }

  env {
    key = "CONSUL_CLIENT_CERT"
    value = "/certs/dc1-server-consul-0.pem"
  }
   
  env {
    key = "CONSUL_CLIENT_KEY"
    value = "/certs/dc1-server-consul-0-key.pem"
  }
}

//
// Install Consul.
//
exec_remote "install_consul" {
  target = "container.consul"

  cmd = "bash"
  args = [
    "-c",
    "/files/bootstrap.sh",
  ]
}