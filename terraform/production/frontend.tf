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

