resource "azurerm_virtual_network" "this" {
  name                = local.project_name
  location            = azurerm_resource_group.resouce_group.location
  resource_group_name = azurerm_resource_group.resouce_group.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "db" {
  name                 = "db-sn"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "db" {
  name                = "multiplayer.database.azure.com"
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "db" {
  name                  = "database.com"
  private_dns_zone_name = azurerm_private_dns_zone.db.name
  virtual_network_id    = azurerm_virtual_network.this.id
  resource_group_name   = azurerm_resource_group.resource_group.name
  depends_on            = [azurerm_subnet.db]
}
