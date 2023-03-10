terraform {
  required_providers {
    digitalocean = {
      source     = "digitalocean/digitalocean"
      version    = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "production_droplet" {
  user_data = templatefile("${path.module}/cloud_init.yaml", {password=var.PASSWORD})
  region    = var.REGION
  image     = "ubuntu-22-10-x64"
  name      = "production-${lower(var.PROJECT_NAME)}-droplet"
  size      = "s-1vcpu-2gb"
  tags      = ["${var.PROJECT_NAME}", "production"]
}

resource "digitalocean_droplet" "dev_staging_droplet" {
  # only create if CREATE_NON_PRODUCTION_RESOURCES is true
  user_data = templatefile("${path.module}/cloud_init.yaml", {password=var.PASSWORD})
  region    = var.REGION
  count     = var.CREATE_NON_PRODUCTION_RESOURCES ? 1 : 0
  image     = "ubuntu-22-10-x64"
  name      = "dev-staging-${lower(var.PROJECT_NAME)}-droplet"
  size      = "s-1vcpu-2gb"
  tags      = ["${var.PROJECT_NAME}", "dev_staging"]
}
