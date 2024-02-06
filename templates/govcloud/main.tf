terraform {
  required_providers {
    anypoint = {
      source = "mulesoft-anypoint/anypoint"
      version = "> 1.3.0"
    }
  }
}

provider "anypoint" {
  username      = var.username
  password      = var.password
  client_id     = var.client_id
  client_secret = var.client_secret
  access_token  = var.access_token
  cplane        = var.cplane
}