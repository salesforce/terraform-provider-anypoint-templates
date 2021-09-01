terraform {
  required_providers {
    anypoint = {
      source = "mulesoft-anypoint/anypoint"
      version = "1.0.1"
    }
  }
}

provider "anypoint" {
  username = var.username
  password = var.password
}