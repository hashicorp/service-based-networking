# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

service {
  name = "orders"
  id = "orders-2"
  port = 9090

  check {
    id = "health"
    http = "http://localhost:9090/health"
    interval = "10s"
    timeout = "1s"
  }

  connect { 
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "users"
          local_bind_port = 9190
        }
      }
    }
  }
}