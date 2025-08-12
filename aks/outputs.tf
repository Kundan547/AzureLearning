output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.aks_rg.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.aks_vnet.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    azurerm_subnet.public_subnet1.id,
    azurerm_subnet.public_subnet2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = [
    azurerm_subnet.private_subnet1.id,
    azurerm_subnet.private_subnet2.id
  ]
}

output "aks_cluster_name" {
  description = "Name of the AKS Cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_kube_config" {
  description = "Kube config for accessing AKS"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
