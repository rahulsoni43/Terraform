### Comment this first while create the storage account
### Uncomment after creation of storage account.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
    backend "azurerm" {
        resource_group_name  = "enablon"
        storage_account_name = "tfstateacme"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}

provider "azurerm" {
  version = "=2.5"
  features {}
}

# Resource Group where all the resource that we are creating will exist under this.

resource "azurerm_resource_group" "aks-grp" {
  name     = "enablon"
  location = var.location
}

# Creationg of AKS Cluster

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

# Creation of Azure Container Registry

resource "azurerm_container_registry" "aks-cnt" {
  name = "enablon"
  admin_enabled = true
  resource_group_name = azurerm_resource_group.aks-grp.name
  location = azurerm_resource_group.aks-grp.location
  sku = "Standard"
}

# Creation of Storage Account

resource "azurerm_storage_account" "storage" {
  name                     = "tfstateacme"
  resource_group_name      = azurerm_resource_group.aks-grp.name
  location                 = azurerm_resource_group.aks-grp.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Creation of Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}