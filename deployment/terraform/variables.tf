#DigitalOcean
variable "digitalocean_token" {
  default = ""
}
variable "pub_ssh_key" {
  type = string
}
variable "priv_ssh_key" {
  type = string
}

#DigitalOcean Droplet
variable "digitalocean_region" {
  default = "fra1"
}

variable "digitalocean_size" {
  default = "s-1vcpu-2gb"
}

variable "digitalocean_image" {
  default = "debian-10-x64"
}

#DigitalOcean DNS
variable "domainname" {
  default = "gruema.de"
}
variable "subdomainnames" {
  type    = list(string)
  default = ["www", "react", "dating"]
}
