#########################################################
# Azure hub VM
#########################################################

resource "azurerm_network_interface" "hub-vm-nic" {
  name                = "hub-vm-ni01"
  location            = azurerm_resource_group.azure-hub-rg.location
  resource_group_name = azurerm_resource_group.azure-hub-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.hub-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "hub-vm" {
  name                              = "hub-vm"
  resource_group_name               = azurerm_resource_group.azure-hub-rg.name
  location                          = azurerm_resource_group.azure-hub-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.hub-vm-nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "hub-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

}

#########################################################
# Onprem Site1 VM
#########################################################


resource "azurerm_network_interface" "site1-vm-nic" {
  name                = "site1-vm-ni01"
  location            = azurerm_resource_group.onprem-site1-rg.location
  resource_group_name = azurerm_resource_group.onprem-site1-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.onprem-site1-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "site1-vm" {
  name                              = "site1-vm"
  resource_group_name               = azurerm_resource_group.onprem-site1-rg.name
  location                          = azurerm_resource_group.onprem-site1-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.site1-vm-nic.id]
  custom_data                       = base64encode(local.custom_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "site1-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

}

#########################################################
# Onprem Site2 VM
#########################################################


resource "azurerm_network_interface" "site2-vm-nic" {
  name                = "site2-vm-ni01"
  location            = azurerm_resource_group.onprem-site2-rg.location
  resource_group_name = azurerm_resource_group.onprem-site2-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.onprem-site2-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "site2-vm" {
  name                              = "site2-vm"
  resource_group_name               = azurerm_resource_group.onprem-site2-rg.name
  location                          = azurerm_resource_group.onprem-site2-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.site2-vm-nic.id]
  custom_data                       = base64encode(local.custom_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "site2-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

}