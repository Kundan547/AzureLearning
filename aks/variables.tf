# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-shopsite"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster-shopsite"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-aks-shopsite"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_1_prefix" {
  description = "Address prefix for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_prefix" {
  description = "Address prefix for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_prefix" {
  description = "Address prefix for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_prefix" {
  description = "Address prefix for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "aks_subnet_prefix" {
  description = "Address prefix for AKS subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "aks_min_count" {
  description = "Minimum number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "aks_max_count" {
  description = "Maximum number of nodes in the AKS cluster"
  type        = number
  default     = 5
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.28.3"
}

variable "sql_server_name_prefix" {
  description = "Prefix for SQL Server name"
  type        = string
  default     = "sql-server-shopsite"
}

variable "sql_database_name" {
  description = "Name of the SQL database"
  type        = string
  default     = "sqldb-shopsite"
}

variable "sql_admin_username" {
  description = "SQL Server admin username"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL Server admin password"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"
}

variable "sql_sku_name" {
  description = "SKU name for SQL database"
  type        = string
  default     = "S0"
}

variable "sql_max_size_gb" {
  description = "Maximum size in GB for SQL database"
  type        = number
  default     = 4
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "ShopSite"
    Application = "E-Commerce"
  }
}