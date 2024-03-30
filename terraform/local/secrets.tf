resource "azurerm_key_vault_secret" "application_client_secret" {
  name         = "${local.project_name}-client-secret"
  value        = azuread_application_password.this.value
  key_vault_id = azurerm_key_vault.this.id
}
