provider "azurerm" {
  version = "=2.5"
  features {}
}

resource "azurerm_resource_group" "aks-grp" {
  name     = "enablon"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "enablon"
  resource_group_name = azurerm_resource_group.aks-grp.name
  location            = azurerm_resource_group.aks-grp.location
  dns_prefix          = "calico"

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

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "aks-cnt" {
  name = "enablon"
  resource_group_name = azurerm_resource_group.aks-grp.name
  location = azurerm_resource_group.aks-grp.location
  sku = "Standard"

}