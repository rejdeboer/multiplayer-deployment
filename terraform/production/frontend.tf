# API token is set via env var
provider "vercel" {}

resource "vercel_project" "this" {
  name      = "multiplayer-client"
  framework = "nextjs"

  git_repository = {
    type = "github"
    repo = "rejdeboer/multiplayer-client"
  }
}

resource "vercel_deployment" "this" {
  project_id = vercel_project.this.id
  ref        = "master"
  production = true

  environment = {
    NEXT_PUBLIC_SERVER_ENDPOINT    = "https://api.rejdeboer.com"
    NEXT_PUBLIC_WEBSOCKET_ENDPOINT = "https://api.rejdeboer.com/sync"
  }
}

resource "azurerm_dns_cname_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.this.name
  resource_group_name = azurerm_resource_group.resource_group.name
  ttl                 = 300
  record              = vercel_deployment.this.domains[0]
}
