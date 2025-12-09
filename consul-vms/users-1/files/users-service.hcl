# Copyright IBM Corp. 2021, 2023
# SPDX-License-Identifier: MPL-2.0

service {
  name = "users"
  id = "users-1"
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