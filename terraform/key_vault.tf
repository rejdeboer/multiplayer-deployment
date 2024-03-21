resource "azurerm_key_vault" "akv" {
  name                = "${local.project_name}-vault"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enabled_for_disk_encryption   = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = true
  purge_protection_enabled      = false

  access_policy = [
    {
      application_id = ""
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = data.azurerm_client_config.current.object_id
      secret_permissions = [
        "Get", "List", "Set", "Purge", "Recover", "Delete"
      ]
      key_permissions         = []
      certificate_permissions = []
      storage_permissions     = []
    },
    {
      application_id = ""
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = azurerm_kubernetes_cluster.cluster.key_vault_secrets_provider[0].secret_identity[0].object_id
      secret_permissions = [
        "Get", "List"
      ]
      key_permissions         = []
      certificate_permissions = []
      storage_permissions     = []
    }
  ]
}
