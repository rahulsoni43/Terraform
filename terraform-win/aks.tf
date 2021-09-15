provider "azurerm" {
  version = "=2.5"
  features {}
}

resource "azurerm_resource_group" "aks-win" {
  name     = "aks-win"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-cluster-win" {
  name                = "aks-cluster-win"
  resource_group_name = azurerm_resource_group.aks-win.name
  location            = azurerm_resource_group.aks-win.location
  dns_prefix          = "aks-cluster-win"

  default_node_pool {
    name       = "node01"
    node_count = var.node_count
    vm_size    = var.vm_size
    type       = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = azuread_service_principal.aks-pc.application_id
    client_secret = azuread_service_principal_password.aks-password.value
  }

  windows_profile {
    admin_username = "azure"
    admin_password = "azure"
    }
  }


# resource "azurerm_kubernetes_cluster_node_pool" "example" {
#   name                  = "internal"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster-win.id
#   vm_size               = "Standard_DS2_v2"
#   node_count            = 1
#   availability_zones  = var.zones
#   os_type = "Windows"
#   tags = {
#     Environment = "Production"
#   }
# }

# resource "azurerm_container_registry" "aks-cnt" {
#   name = "aksregabc1234"
#   resource_group_name = azurerm_resource_group.aks-win.name
#   location = azurerm_resource_group.aks-win.location
#   sku = "Standard"

# }

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks-cluster-win.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster-win.kube_config_raw
}
