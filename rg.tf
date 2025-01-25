resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = var.location
}
