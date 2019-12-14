resource "docker_container" "container_id" {
  name = "${var.container_name}"
  image = "${var.image}"
  ports {
    internal = "${var.int_port}"
    external = "${var.ext_port}"
  }
}

output "ip" {
  value = "${docker_container.container_id.ip_address}"
}

output "container_name" {
  value = "${docker_container.container_id.name}"
}

output "int_port" {
  value = "${docker_container.container_id.ports[0]}"
}
