# Copyright IBM Corp. 2021, 2023
# SPDX-License-Identifier: MPL-2.0

node_prefix "orders-" {
  policy = "write"
}

agent_agent "orders-" {
  policy = "write"
}

key_prefix "_rexec" {
  policy = "write"
}

service "orders" {
	policy = "write"
}

service "orders-sidecar-proxy" {
	policy = "write"
}

service_prefix "" {
	policy = "read"
}

node_prefix "" {
	policy = "read"
}