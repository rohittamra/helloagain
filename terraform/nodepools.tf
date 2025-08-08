resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = 2
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  mode                  = "User"
  os_type               = "Linux"
}
