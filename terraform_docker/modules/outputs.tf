output "ip" {
  value = module.container.ip
}

output "container_name" {
  value = module.container.container_name
}

output "image_name" {
  value = module.image.image_out
}

output "int_port" {
  value = module.container.int_port
}
