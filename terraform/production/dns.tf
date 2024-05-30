provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "azurerm_dns_zone" "this" {
  name                = "rejdeboer.com"
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "cloudflare_record" "name_servers" {
  for_each = azurerm_dns_zone.this.name_servers

  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = each.value
  type    = "NS"
  ttl     = 86400
  proxied = false
}

resource "azuread_application" "external_dns" {
  display_name = "spn-external-dns-aks"
}

resource "azuread_service_principal" "external_dns" {
  client_id = azuread_application.external_dns.client_id
}

resource "azuread_service_principal_password" "external_dns" {
  service_principal_id = azuread_service_principal.external_dns.id
  end_date_relative    = "240h"
}

resource "azurerm_role_assignment" "external_dns_reader" {
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.external_dns.id
}

resource "azurerm_role_assignment" "external_dns_writer" {
  scope                = azurerm_dns_zone.this.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azuread_service_principal.external_dns.id
}
