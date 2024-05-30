provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "azurerm_dns_zone" "this" {
  name                = "rejdeboer.com"
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "cloudflare_record" "name_server_0" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = tolist(azurerm_dns_zone.this.name_servers)[0]
  type    = "NS"
  ttl     = 86400
  proxied = false
}

resource "cloudflare_record" "name_server_1" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = tolist(azurerm_dns_zone.this.name_servers)[1]
  type    = "NS"
  ttl     = 86400
  proxied = false
}

resource "cloudflare_record" "name_server_2" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = tolist(azurerm_dns_zone.this.name_servers)[2]
  type    = "NS"
  ttl     = 86400
  proxied = false
}

resource "cloudflare_record" "name_server_3" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = tolist(azurerm_dns_zone.this.name_servers)[3]
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
