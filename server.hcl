module "server" {
  disabled = var.use_modules == false
  source = "./server"
}