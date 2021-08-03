//
// Create CA certificate.
//
// hello
exec_remote "create_ca" {
  image {
    name = "consul:1.10.1"
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
    name = "consul:1.10.1"
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
container "server" {
  depends_on = ["exec_remote.create_certs"]

  network {
      name = "network.dc1"
  }

  image {
      //name = "nicholasjackson/ubuntu-systemd:latest"
      name = "nicholasjackson/ubuntu-systemd:consul"
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
    source      = "${data("shared")}/certs"
    destination = "/certs"
  }

  volume {
    source      = "./files/server"
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
  target = "container.server"

  cmd = "bash"
  args = [
    "-c",
    "/files/bootstrap.sh",
  ]
}
