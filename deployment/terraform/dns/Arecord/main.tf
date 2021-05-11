terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}
variable "token" { default = "" }

provider "digitalocean" {
  token = var.token
}
variable "public_ip" {
  type = string
}
variable "domainname" {
  type = string
}

resource "digitalocean_record" "Arecord" {
  domain = var.domainname
  type   = "A"
  name   = "@"
  value  = var.public_ip
  ttl    = 60
}