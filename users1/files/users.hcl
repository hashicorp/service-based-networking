service {
  name = "users"
  id = "users-1"
  port = 9090
  connect { 
    sidecar_service {
      proxy {
      }
    }
  }
}