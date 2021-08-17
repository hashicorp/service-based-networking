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