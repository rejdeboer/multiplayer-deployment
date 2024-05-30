resource "azurerm_dns_zone" "this" {
  name                = "rejdeboer.com"
  resource_group_name = azurerm_resource_group.this.name
}
