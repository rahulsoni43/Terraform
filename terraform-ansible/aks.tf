provider "azurerm" {
  version = "=2.5"
  features {}
}

resource "azurerm_resource_group" "rancher" {
  name     = "rancher"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "rancher" {
  name                = "rancher"
  resource_group_name = azurerm_resource_group.rancher.name
  location            = azurerm_resource_group.rancher.location
  dns_prefix          = "rancher"

  default_node_pool {
    name       = "node01"
    node_count = var.node_count
    vm_size    = var.vm_size
    type       = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = azuread_service_principal.aks-pc.application_id
    client_secret = azuread_service_principal_password.aks-password.value
  }

  # linux_profile {
  #   admin_username = "ubuntu"
  #   ssh_key {
  #     key_data = file("${var.ssh_public_key}")
  #   }
  # }

}
# resource "azurerm_kubernetes_cluster_node_pool" "example" {
#   name                  = "internal"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.rancher.id
#   vm_size               = "Standard_DS2_v2"
#   node_count            = 3
#   availability_zones  = var.zones
#   tags = {
#     Environment = "Production"
#   }
# }

# resource "azurerm_container_registry" "aks-cnt" {
#   name = "aksregabc1234"
#   resource_group_name = azurerm_resource_group.rancher.name
#   location = azurerm_resource_group.rancher.location
#   sku = "Standard"

# }

output "client_certificate" {
  value = azurerm_kubernetes_cluster.rancher.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.rancher.kube_config_raw
}
