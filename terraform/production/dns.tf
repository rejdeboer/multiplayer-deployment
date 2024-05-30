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
