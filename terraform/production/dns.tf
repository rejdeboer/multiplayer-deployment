provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "azurerm_dns_zone" "this" {
  name                = "rejdeboer.com"
  resource_group_name = azurerm_resource_group.resource_group.name
}

# resource "cloudflare_record" "name_server_0" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   value   = azurerm_dns_zone.this.name_servers.0
#   type    = "NS"
#   ttl     = 86400
#   proxied = false
# }
#
# resource "cloudflare_record" "name_server_1" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   value   = azurerm_dns_zone.this.name_servers.1
#   type    = "NS"
#   ttl     = 86400
#   proxied = false
# }
#
# resource "cloudflare_record" "name_server_2" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   value   = azurerm_dns_zone.this.name_servers.2
#   type    = "NS"
#   ttl     = 86400
#   proxied = false
# }
#
# resource "cloudflare_record" "name_server_3" {
#   zone_id = var.cloudflare_zone_id
#   name    = "@"
#   value   = azurerm_dns_zone.this.name_servers.3
#   type    = "NS"
#   ttl     = 86400
#   proxied = false
# }
