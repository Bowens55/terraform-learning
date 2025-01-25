resource "azurerm_network_security_group" "nsg" {
  name                = "${local.prefix}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

locals {
  rules = {
    victor_rule = {
      priority = 100
      ip       = var.victor_ip
    },
    chris_rule = {
      priority = 110
      ip       = var.chris_ip
    }
  }
}

resource "azurerm_network_security_rule" "rules" {
  for_each                    = local.rules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = each.value.ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

locals {
  subnets = {
    "subnet-a" = azurerm_subnet.subnet-a.id,
    "subnet-b" = azurerm_subnet.subnet-b.id,
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgc-ass" {
  for_each                  = local.subnets
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
}