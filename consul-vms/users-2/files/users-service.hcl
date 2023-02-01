# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

service {
  name = "users"
  id = "users-2"
  port = 9091

  check {
    id = "health"
    http = "http://localhost:9091/health"
    interval = "10s"
    timeout = "1s"
  }

  connect { 
    sidecar_service {
      proxy {}
    }
  }
}