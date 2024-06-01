# API token is set via env var
provider "vercel" {}

resource "vercel_project" "this" {
  name      = "multiplayer-client"
  framework = "nextjs"

  git_repository = {
    type = "github"
    repo = "${var.github_org}/${var.github_repository}"
  }
}

resource "vercel_deployment" "this" {
  project_id = vercel_project.this.id
  ref        = "master"
  production = true
}
