resource "azurerm_virtual_network" "vnet-a" {
  name                = "vnet-a"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet-a" {
  name                              = "subnet-a"
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet-a.name
  address_prefixes                  = ["10.10.1.0/24"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_virtual_network" "vnet-b" {
  name                = "vnet-b"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet-b" {
  name                 = "subnet-b"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-b.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_virtual_network_peering" "vneta-vnetb" {
  name                      = "vnet-a-to-vnet-b"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-a.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-b.id
}

resource "azurerm_virtual_network_peering" "vnetb-vneta" {
  name                      = "vnet-b-to-vnet-a"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-b.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-a.id
}
