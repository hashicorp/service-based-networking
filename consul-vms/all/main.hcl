module "base" {
  source = "../"
}

module "server" {
  source = "../server"
}

module "users-1" {
  source = "../users-1"
}

module "users-2" {
  source = "../users-2"
}

module "orders-1" {
  source = "../orders-1"
}

module "orders-2" {
  source = "../orders-2"
}