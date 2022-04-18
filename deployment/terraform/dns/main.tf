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
variable "subdomainnames" {
  type = list(string)
}
resource "digitalocean_domain" "domain" {
  name       = var.domainname
  ip_address = var.public_ip
}

resource "digitalocean_record" "Arecord" {
  depends_on = [digitalocean_domain.domain]
  domain     = var.domainname
  type       = "A"
  name       = "@"
  value      = var.public_ip
  # ttl    = 60
}

resource "digitalocean_record" "CNAMERECORDS" {
  depends_on = [digitalocean_domain.domain]
  count      = length(var.subdomainnames)
  domain     = var.domainname
  type       = "CNAME"
  name       = "${element(var.subdomainnames, count.index)}."
  value      = "${var.domainname}."
}
