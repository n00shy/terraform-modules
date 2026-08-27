output "network_id" {
  description = "ID of the Civo network"
  value       = module.network.network_id
}

output "firewall_id" {
  description = "Created Civo firewall ID"
  value       = module.firewall.firewall_id
}

output "instance_id" {
  description = "Created Civo instance ID"
  value       = module.instance.instance_id
}

output "instance_public_ip" {
  description = "Public IP of the instance"
  value       = module.instance.public_ip
}
