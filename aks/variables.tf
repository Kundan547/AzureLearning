variable "location" {
  description = "Azure region where AKS and resources will be deployed"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "rg-aks-demo"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-aks-demo"
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet1_cidr" {
  description = "CIDR for Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR for Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet1_cidr" {
  description = "CIDR for Private Subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  description = "CIDR for Private Subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "aks_cluster_name" {
  description = "Name of the AKS Cluster"
  type        = string
  default     = "aks-demo"
}

variable "dns_prefix" {
  description = "DNS prefix for AKS"
  type        = string
  default     = "aksdemo"
}

variable "node_count" {
  description = "Number of nodes in the AKS default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for each node in the AKS node pool"
  type        = string
  default     = "Standard_D4s_v3" # 4 vCPUs, 16GB RAM
}
