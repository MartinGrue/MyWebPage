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

variable "domainname" {
  type = string
}
variable "subdomainnames" {
  type = list(string)
}

resource "digitalocean_record" "CNAMERECORDS" {
  count  = length(var.subdomainnames)
  domain = var.domainname
  type   = "CNAME"
  # name   = "www."
  name  = "${element(var.subdomainnames, count.index)}."
  value = "${var.domainname}."
  ttl   = 60
}
