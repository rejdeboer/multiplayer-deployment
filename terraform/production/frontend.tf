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
}
