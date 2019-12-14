module "image" {
  source     = "./image"
  image_name = var.image_name
}

module "container" {
  source         = "./container"
  container_name = var.container_name
  image          = module.image.image_out
  int_port       = var.int_port
  ext_port       = var.ext_port
}

