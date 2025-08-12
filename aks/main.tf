provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-demo"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-aks-uat"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Public Subnets
resource "azurerm_subnet" "public_subnet1" {
  name                 = "public-subnet-1"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "public_subnet2" {
  name                 = "public-subnet-2"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Private Subnets
resource "azurerm_subnet" "private_subnet1" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "private_subnet2" {
  name                 = "private-subnet-2"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-UAT"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksuat"

  default_node_pool {
    name       = "nodepool1"
    node_count = 2
    vm_size    = "Standard_D4s_v3" # 4 vCPUs, 16GB RAM
    vnet_subnet_id = azurerm_subnet.private_subnet1.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
  }

  depends_on = [
    azurerm_subnet.private_subnet1
  ]
}
