node "users-1" {
  policy = "write"
}

agent "users-1" {
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