output "CONSUL_HTTP_ADDR" {
  value = "https://localhost:8501"
}
  
output "CONSUL_HTTP_TOKEN" {
  value = "00000000-0000-0000-0000-000000000000"
}

output "CONSUL_CACERT" {
  value = "${data("shared")}/certs/consul-agent-ca.pem"
}

output "CONSUL_CLIENT_CERT" {
  value = "${data("shared")}/certs/dc1-server-consul-0.pem"
}
 
output "CONSUL_CLIENT_KEY"{
  value = "${data("shared")}/certs/dc1-server-consul-0-key.pem"
}