/* digitalocean */
variable "digitalocean_token" {
  default = ""
}
variable "pub_ssh_key" {
  type = string
}
variable "priv_ssh_key" {
  type = string
}


variable "digitalocean_region" {
  default = "fra1"
}

variable "digitalocean_size" {
  default = "s-1vcpu-1gb"
}

variable "digitalocean_image" {
  default = "debian-10-x64"
}