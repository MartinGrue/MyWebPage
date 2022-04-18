terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}
variable "token" { default = "" }

variable "hosts" {
  default = 0
}

variable "pub_ssh_key" {
  type = string
}
variable "priv_ssh_key" {
  type = string
}
data "digitalocean_ssh_key" "main" {
  name = var.pub_ssh_key
}


variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "size" {
  type = string
}

variable "apt_packages" {
  type    = list(any)
  default = []
}

provider "digitalocean" {
  token = var.token
}
resource "digitalocean_droplet" "host" {
  # name               = join(" ", [var.image, var.size])
  name               = "host"
  region             = var.region
  image              = var.image
  size               = var.size
  backups            = false
  private_networking = true
  ssh_keys           = [data.digitalocean_ssh_key.main.id]

  connection {
    host        = self.ipv4_address
    private_key = file(var.priv_ssh_key)
    user        = "root"
    type        = "ssh"
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw ${join(" ", var.apt_packages)}",
    ]
  }
  provisioner "local-exec" {
    command = <<EOT
      sed -i "s/HOSTIP=.*/HOSTIP=${self.ipv4_address}/g" ../ansible/runPlayBook.sh
    EOT
    # command = "echo ${PWD%/*}/ansible/runPlaybook.sh"
  }
  # provisioner "local-exec" {
  #   command = <<EOT
  #   ANSIBLE_HOST_KEY_CHECKING=False \
  #   ansible-playbook -u root -i '${self.ipv4_address},' \
  #   --private-key ${var.priv_ssh_key} \
  #   ../ansible/composePlaybook.yml \
  #   --extra-vars 'token=${var.token}'
  #   EOT
  # }
}
output "public_ip" {
  value = digitalocean_droplet.host.ipv4_address
}
