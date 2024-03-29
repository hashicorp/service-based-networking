# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

node_prefix "users-" {
  policy = "write"
}

agent_agent "users-" {
  policy = "write"
}

key_prefix "_rexec" {
  policy = "write"
}

service "users" {
	policy = "write"
}

service "users-sidecar-proxy" {
	policy = "write"
}

service_prefix "" {
	policy = "read"
}

node_prefix "" {
	policy = "read"
}