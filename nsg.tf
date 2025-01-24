resource "azurerm_network_security_group" "nsgc" {
  name                = "nsgc"
  location            = "West US 2"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "victor-ip" {
  name                        = "victor-ip"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "47.158.18.24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsgc.name
}

resource "azurerm_subnet_network_security_group_association" "nsgc-ass" {
  subnet_id                 = azurerm_subnet.subnet-b.id
  network_security_group_id = azurerm_network_security_group.nsgc.id
}