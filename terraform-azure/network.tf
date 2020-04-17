provider "azurerm" {
  version = "=2.5"
  features {}
}

resource "azurerm_resource_group" "myrg" {
  location = var.location
  name     = var.name
}

resource "azurerm_virtual_network" "myvnet" {
  name                = "vnet1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = var.address_space_vnet
}

resource "azurerm_subnet" "public_subnet" {
  count                = 2
  name                 = "public_subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefix       = var.address_space_pnet[count.index]
}

resource "azurerm_network_interface" "mynic" {
  count               = 2
  name                = "azure-nic-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location


  ip_configuration {
    name                          = "Internet-${count.index}"
    subnet_id                     = azurerm_subnet.public_subnet.*.id[count.index]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.*.id[count.index]
  }

  tags = {
    Name = "azure-nic-${count.index}"
  }

}

resource "azurerm_network_interface_security_group_association" "assoc" {
  count                = length(azurerm_network_interface.mynic)
  network_interface_id = azurerm_network_interface.mynic.*.id[count.index]
  #  network_interface_id = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

resource "azurerm_network_security_group" "azure_nsg" {
  name                = "azure_nsg"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
    name                       = "nsgrule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Azure"
  }
}
