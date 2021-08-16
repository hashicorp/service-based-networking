service {
  name = "users"
  id = "users-2"
  port = 9090

  check {
    id = "health"
    http = "http://localhost:9090/health"
    interval = "10s"
    timeout = "1s"
  }

  connect { 
    sidecar_service {
      proxy {}
    }
  }
}