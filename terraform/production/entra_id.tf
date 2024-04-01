resource "azuread_application" "this" {
  display_name = local.project_name
  owners       = [data.azurerm_client_config.current.object_id]

  api {
    requested_access_token_version = 2
  }
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuread_application_password" "this" {
  application_id = azuread_application.this.id
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.this.object_id
}
