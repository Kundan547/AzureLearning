
# Random integer for unique naming
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Public Subnets
resource "azurerm_subnet" "public_1" {
  name                 = "subnet-public-shopsite-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_1_prefix]
}

resource "azurerm_subnet" "public_2" {
  name                 = "subnet-public-shopsite-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_2_prefix]
}

# Private Subnets
resource "azurerm_subnet" "private_1" {
  name                 = "subnet-private-shopsite-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_1_prefix]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "private_2" {
  name                 = "subnet-private-shopsite-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_2_prefix]
  service_endpoints    = ["Microsoft.Sql"]
}

# AKS Subnet (separate subnet for AKS nodes)
resource "azurerm_subnet" "aks" {
  name                 = "subnet-aks-shopsite"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_prefix]
}

# NAT Gateway for private subnets internet access
resource "azurerm_public_ip" "nat_gateway" {
  name                = "pip-nat-gateway-shopsite"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "main" {
  name                    = "nat-gateway-shopsite"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

# Associate NAT Gateway with private subnets
resource "azurerm_subnet_nat_gateway_association" "private_1" {
  subnet_id      = azurerm_subnet.private_1.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

resource "azurerm_subnet_nat_gateway_association" "private_2" {
  subnet_id      = azurerm_subnet.private_2.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Network Security Group for SQL Server
resource "azurerm_network_security_group" "sql" {
  name                = "nsg-sql-shopsite"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  security_rule {
    name                       = "AllowSQLInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowInternetOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "AllowAKSOutbound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.aks_subnet_prefix
  }
}

# Associate NSG with private subnets
resource "azurerm_subnet_network_security_group_association" "private_1" {
  subnet_id                 = azurerm_subnet.private_1.id
  network_security_group_id = azurerm_network_security_group.sql.id
}

resource "azurerm_subnet_network_security_group_association" "private_2" {
  subnet_id                 = azurerm_subnet.private_2.id
  network_security_group_id = azurerm_network_security_group.sql.id
}

# Azure SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "${var.sql_server_name_prefix}-${random_integer.suffix.result}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  tags                         = var.tags
}

# Azure SQL Database
resource "azurerm_mssql_database" "main" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = var.sql_max_size_gb
  sku_name       = var.sql_sku_name
  tags           = var.tags
}

# SQL Server Firewall Rules
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow access from VNet
resource "azurerm_mssql_virtual_network_rule" "private_1" {
  name      = "sql-vnet-rule-private-shopsite-1"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.private_1.id
}

resource "azurerm_mssql_virtual_network_rule" "private_2" {
  name      = "sql-vnet-rule-private-shopsite-2"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.private_2.id
}

# Allow access from AKS subnet
resource "azurerm_mssql_virtual_network_rule" "aks" {
  name      = "sql-vnet-rule-aks-shopsite"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.aks.id
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-shopsite"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = "shopsite"
    node_count          = var.aks_node_count
    vm_size             = var.aks_vm_size
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.aks.id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = var.aks_min_count
    max_count           = var.aks_max_count

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# Role assignments for AKS
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_virtual_network.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}