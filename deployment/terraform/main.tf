module "provider" {
  source = "./provider"

  token        = var.digitalocean_token
  pub_ssh_key  = var.pub_ssh_key
  priv_ssh_key = var.priv_ssh_key
  region       = var.digitalocean_region
  size         = var.digitalocean_size
  image        = var.digitalocean_image
  apt_packages = ["docker.io", "docker-compose", "python3", "python3-pip"]
}
module "Arecord" {
  source     = "./dns/Arecord"
  token      = var.digitalocean_token
  public_ip  = module.provider.public_ip
  domainname = var.domainname
}
module "CNAMES" {
  source         = "./dns/subdomains"
  token          = var.digitalocean_token
  domainname     = var.domainname
  subdomainnames = var.subdomainnames
}
