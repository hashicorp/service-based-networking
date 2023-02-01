# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

kind = "service-intentions"
name = "users"
sources = [
  {
    name   = "orders"
    action = "allow"
  },
]
