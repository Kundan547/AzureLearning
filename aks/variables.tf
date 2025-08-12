variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "myaks"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = "rg-aks-sql"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
}

variable "node_vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "sql_admin_user" {
  description = "SQL Admin username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Admin password"
  type        = string
  sensitive   = true
}

variable "my_public_ip" {
  description = "Your public IP address to whitelist for SQL access"
  type        = string
}
