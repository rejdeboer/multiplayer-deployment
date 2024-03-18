
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "multiplayer-server-api-cluster"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "multiplayer-server-cluster"

  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "mem" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = "mem"
  node_count            = "1"
  vm_size               = "standard_d11_v2"
}
