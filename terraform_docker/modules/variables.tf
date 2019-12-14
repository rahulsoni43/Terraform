variable "container_name" {
  description = "name of the container"
  default     = "blog"
}

variable "image_name" {
  description = "name of the image"
  default     = "ghost:alpine"
}

variable "int_port" {
  default = "2368"
}

variable "ext_port" {
  default = "8181"
}

