output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    azurerm_subnet.public_subnet_1.id,
    azurerm_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = [
    azurerm_subnet.private_subnet_1.id,
    azurerm_subnet.private_subnet_2.id
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

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_sql_server.sql.name
}

output "sql_database_name" {
  description = "Name of the SQL Database"
  value       = azurerm_sql_database.sqldb.name
}

output "nat_gateway_public_ip" {
  description = "Public IP used by NAT Gateway for outbound traffic"
  value       = azurerm_public_ip.nat_ip.ip_address
}
