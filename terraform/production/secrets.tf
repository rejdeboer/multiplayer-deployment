resource "random_string" "postgres_username" {
  length  = 16
  special = false
  numeric = false
}

resource "random_password" "postgres_password" {
  length  = 32
  special = false
}

resource "random_password" "jwt_secret_key" {
  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-username"
  value        = random_string.postgres_username.result
  key_vault_id = azurerm_key_vault.akv.id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = random_password.postgres_password.result
  key_vault_id = azurerm_key_vault.akv.id
}

resource "azurerm_key_vault_secret" "jwt_secret_key" {
  name         = "jwt-secret-key"
  value        = random_password.jwt_secret_key.result
  key_vault_id = azurerm_key_vault.akv.id
}

resource "azurerm_key_vault_secret" "application_client_secret" {
  name         = "${local.project_name}-client-secret"
  value        = azuread_application_password.this.value
  key_vault_id = azurerm_key_vault.akv.id
}

resource "azurerm_key_vault_secret" "external_dns_secret" {
  name = "external-dns-secret"
  value = jsonencode({
    "tenantId" : data.azurerm_client_config.current.tenant_id,
    "subscriptionId" : data.azurerm_client_config.current.subscription_id,
    "resourceGroup" : azurerm_resource_group.resource_group.name,
    "aadClientId" : azuread_application.external_dns.client_id,
    "aadClientSecret" : random_string.external_dns_password.result,
  })
  key_vault_id = azurerm_key_vault.akv.id
}
