provider "flux" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.cluster.kube_config[0].host
    client_certificate     = azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate
    client_key             = azurerm_kubernetes_cluster.cluster.kube_config[0].client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]
  path       = "kubernetes"
}

