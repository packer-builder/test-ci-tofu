variable "vnet_name" {
  description = "Name of the Virtual Network (must be unique within the resource group)"
  type        = string
  default     = "main-vnet"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_prefixes" {
  description = "Address prefixes for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_prefixes" {
  description = "Address prefixes for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "allowed_ingress_cidr" {
  description = "CIDR block allowed for HTTP/HTTPS ingress (use specific CIDR for production)"
  type        = string
  default     = "10.0.0.0/8"
}
