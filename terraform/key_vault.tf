resource "azurerm_key_vault" "akv" {
  name                = "${local.project_name}-vault"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tenant_id           = var.azure_tenant_id

  enabled_for_disk_encryption   = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = true
  purge_protection_enabled      = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "akv" {
  key_vault_id = data.azurerm_key_vault.akv.id
  tenant_id    = data.azurerm_key_vault.akv.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Purge", "Recover", "Delete"
  ]
}

resource "azurerm_key_vault_access_policy" "akv" {
  key_vault_id = data.azurerm_key_vault.akv.id
  tenant_id    = data.azurerm_key_vault.akv.tenant_id
  object_id    = data.azurerm_kubernetes_cluster.cluster.key_vault_secrets_provider[0].secret_identity[0].object_id

  secret_permissions = [
    "Get", "List"
  ]
}

resource "azurerm_subnet" "akv" {
  name                 = "akv-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "akv" {
  name                = "akv-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  security_rule {
    name                       = "Allow-AKV"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_subnet_network_security_group_association" "akv" {
  subnet_id                 = azurerm_subnet.akv.id
  network_security_group_id = azurerm_network_security_group.akv.id
}

resource "azurerm_private_dns_zone" "akv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_private_endpoint" "akv" {
  name                          = "pvep-akv"
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = azurerm_resource_group.resource_group.location
  subnet_id                     = azurerm_subnet.akv.id
  custom_network_interface_name = "pvep-akv-nic"

  private_service_connection {
    name                           = "akv-private-endpoint"
    private_connection_resource_id = azurerm_key_vault.akv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.akv.name
    private_dns_zone_ids = [azurerm_private_dns_zone.akv.id]
  }

  depends_on = [azurerm_subnet.akv, azurerm_private_dns_zone.akv]
}

resource "azurerm_private_dns_zone_virtual_network_link" "akv" {
  name                  = "akv"
  private_dns_zone_name = azurerm_private_dns_zone.akv.name
  virtual_network_id    = azurerm_virtual_network.network.id
  resource_group_name   = azurerm_resource_group.resource_group.name
}
