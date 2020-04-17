output "Bucket_Name" {
  value = module.storage.bucketname
}

output "Public_Subnets" {
  value = join(", ", module.networking.public_subnets)
}

output "Subnets_Ips" {
  value = join(", ", module.networking.subnet_ips)
}

output "Public_Ips" {
  value = module.compute.server_ip
}

output "Instance_ID" {
  value = module.compute.server_id
}
