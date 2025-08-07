resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = 1
  availability_zones    = ["1", "2", "3"]
  type                  = "VirtualMachineScaleSets"
  os_type               = "Linux"
  mode                  = "User"
}
