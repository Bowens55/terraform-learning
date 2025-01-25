locals {
  # saving this, I like this example with the explanations, I know its overly complicated... for no reason.
  subnet_id = {
    for idx in range(3) : 
      # Key: the index (idx)
      idx => 
        # Value: conditional logic to choose subnet ID
        idx < 2 ? azurerm_subnet.subnet-a.id : azurerm_subnet.subnet-b.id
  }
}

resource "azurerm_network_interface" "vm-nic" {
  count               = 3
  name                = "${local.prefix}-${count.index}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id[count.index]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
  count               = 3
  name                = "${local.prefix}-vm-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm-nic[count.index].id,
  ]

  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

