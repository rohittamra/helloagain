locals {
  rg_name     = "${var.prefix}-rg"
  aks_name    = "${var.prefix}-aks"
  la_name     = "${var.prefix}-la"
  vnet_name   = "${var.prefix}-vnet"
  subnet_name = "${var.prefix}-subnet"
  aks_sku     = "Basic"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = local.la_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = "Standard_D2s_v3"
    type            = "VirtualMachineScaleSets"
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
  }


  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  tags = {
    environment = "challenge-helloagain"
  }
}
