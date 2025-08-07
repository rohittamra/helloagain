# A user node pool with autoscaler and availability zone distribution.
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.node_vm_size
  os_type               = "Linux"
  node_taints           = []      # add taints if you want scheduling isolation
  type                  = "VirtualMachineScaleSets"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 6
  vnet_subnet_id        = azurerm_subnet.aks_subnet.id
  availability_zones    = ["1","2","3"]
  max_pods              = 110
  mode                  = "User"

  node_labels = {
    "role" = "workload"
  }

  tags = {
    pool = "workload"
  }
}
