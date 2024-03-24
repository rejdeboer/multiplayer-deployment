resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${local.project_name}-cluster"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "${local.project_name}-cluster"
  sku_tier            = "Free"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "standard_d2_v2"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "mem" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = "mem"
  node_count            = "1"
  vm_size               = "standard_d11_v2"
  vnet_subnet_id        = azurerm_subnet.aks.id
}


resource "azurerm_subnet" "aks" {
  name                 = "aks-sn"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.1.0/24"]
}
