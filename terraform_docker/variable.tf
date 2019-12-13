variable "image_name" {
  default     = "ghost:latest"
  description = "Image for the container"
}

variable "container_name" {
  default     = "blog"
  description = "Name for the container"
}

variable "int_port" {
  default     = "2368"
  description = "Internal port of the container"
}

variable "ext_port" {
  default     = "82"
  description = "Internal port of the container"
}
