module "network" {
  source = "./modules/network"

  network_name = "devops-network"
}

module "firewall" {
  source = "./modules/firewall"

  firewall_name = "devops-firewall"
  network_id    = module.network.network_id
}

module "instance" {
  source = "./modules/instance"

  instance_name = "devops-server"
  instance_type = "g3.small"

  network_id  = module.network.network_id
  firewall_id = module.firewall.firewall_id
  ssh_key_id  = "366bbae3-5abe-4152-9825-44be7921b3d7"

  disk_image = var.disk_image
}
