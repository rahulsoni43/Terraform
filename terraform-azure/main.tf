resource "azurerm_virtual_machine" "vm" {
  count                 = 2
  name                  = "${var.vm_name}-${count.index}"
  location              = azurerm_resource_group.myrg.location
  resource_group_name   = azurerm_resource_group.myrg.name
  availability_set_id   = azurerm_availability_set.avset.*.id[count.index]
  network_interface_ids = [azurerm_network_interface.mynic.*.id[count.index]]
  vm_size               = var.vm_size

/*
  zones                 = ["1","2"]
  sku {
  name = "Standard_A1_v2"
  tier = "Standard"        # basic doesn't have AZ support but Standard does
  capacity = 2
}
*/
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.publisher
    offer     = var.os
    sku       = var.os_version
    version   = var.type
  }

  storage_os_disk {
    name              = "azure_disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "azure-instance-${count.index}"
    admin_username = "ubuntu"
    custom_data    = "!/bin/bash\n\n sudo apt-get update && sudo apt-get install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("/home/ubuntu/.ssh/id_rsa.pub")
      path     = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  count               = 2
  name                = "azure_ip-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Dynamic"

}


resource "azurerm_availability_set" "avset" {
  count                        = 2
  name                         = "avset-${count.index}"
  location                     = azurerm_resource_group.myrg.location
  resource_group_name          = azurerm_resource_group.myrg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
