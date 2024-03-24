resource "azurerm_postgresql_flexible_server" "this" {
  name                = local.project_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku_name = "B_Standard_B1ms"

  storage_mb                   = 32768
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login    = random_string.postgres_username.result
  administrator_password = random_password.postgres_password.result
  version                = "16"
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = "${local.project_name}-db"
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"

  # TODO: Set to true for production
  lifecycle {
    prevent_destroy = false
  }
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
