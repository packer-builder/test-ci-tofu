# Azure VNet Module
# Creates a Virtual Network with public and private subnets

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = merge(var.tags, {
    Name = var.vnet_name
  })
}

# Public Subnets
resource "azurerm_subnet" "public" {
  count = length(var.public_subnet_prefixes)

  name                 = "${var.vnet_name}-public-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_prefixes[count.index]]
}

# Private Subnets
resource "azurerm_subnet" "private" {
  count = length(var.private_subnet_prefixes)

  name                 = "${var.vnet_name}-private-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_prefixes[count.index]]
}

# Network Security Group for Public Subnets
# tfsec:ignore:azure-network-no-public-ingress - Public subnets intentionally allow HTTP/HTTPS from internet for web services
resource "azurerm_network_security_group" "public" {
  name                = "${var.vnet_name}-public-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.allowed_ingress_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.allowed_ingress_cidr
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Name = "${var.vnet_name}-public-nsg"
  })
}

# Network Security Group for Private Subnets
resource "azurerm_network_security_group" "private" {
  name                = "${var.vnet_name}-private-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    Name = "${var.vnet_name}-private-nsg"
  })
}

# Associate NSG with Public Subnets
resource "azurerm_subnet_network_security_group_association" "public" {
  count = length(var.public_subnet_prefixes)

  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.public.id
}

# Associate NSG with Private Subnets
resource "azurerm_subnet_network_security_group_association" "private" {
  count = length(var.private_subnet_prefixes)

  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private.id
}
