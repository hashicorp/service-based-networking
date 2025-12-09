# Copyright IBM Corp. 2021, 2023
# SPDX-License-Identifier: MPL-2.0

kind = "service-intentions"
name = "users"
sources = [
  {
    name   = "orders"
    action = "allow"
  },
]
