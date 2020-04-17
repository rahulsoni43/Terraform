provider "azurerm" {
  version = "=2.5"
  features {}
}

resource "azurerm_resource_group" "aks-grp" {
  name = "aks-grp"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = "aks-cluster"
  resource_group_name = azurerm_resource_group.aks-grp.name
  location = azurerm_resource_group.aks-grp.location
  dns_prefix = "aks-cluster"

  default_node_pool {
    name = "node01"
    node_count = 2
    vm_size = var.vm_size
  }

  service_principal {
    client_id = azuread_service_principal.aks-pc.application_id
    client_secret = azuread_service_principal_password.aks-password.value
  }
}

resource "azurerm_container_registry" "aks-cnt" {
  name = "aksregabc1234"
  resource_group_name = azurerm_resource_group.aks-grp.name
  location = azurerm_resource_group.aks-grp.location
  sku = "Standard"

}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}
