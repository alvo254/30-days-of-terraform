resource "azurerm_resource_group" "example" {
  name     = "api-rg-pro"
  location = "West Europe"
}

resource "azurerm_mariadb_server" "example" {
  name                         = "mariadb-server-1"
  location                     = azurerm_resource_group.example.location
  resource_group_name          = azurerm_resource_group.example.name
  sku_name                     = "B_Gen5_2"
  ssl_enforcement_enabled      = true
  administrator_login          = "mariadbadmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "10.2"
}

resource "azurerm_mariadb_configuration" "example" {
  name                = "interactive_timeout"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mariadb_server.example.name
  value               = "600"
}
