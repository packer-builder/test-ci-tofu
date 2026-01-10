variable "domain_name" {
  description = "The domain name for the hosted zones (e.g., example.com)"
  type        = string
}

variable "private_domain_name" {
  description = "The domain name for the private hosted zone (defaults to domain_name if not specified)"
  type        = string
  default     = null
}

variable "create_public_zone" {
  description = "Whether to create a public hosted zone"
  type        = bool
  default     = true
}

variable "create_private_zone" {
  description = "Whether to create a private hosted zone"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The VPC ID to associate with the private hosted zone"
  type        = string
  default     = null
}

variable "additional_vpc_ids" {
  description = "Additional VPC IDs to associate with the private hosted zone"
  type        = list(string)
  default     = []
}

variable "public_zone_comment" {
  description = "Comment for the public hosted zone"
  type        = string
  default     = "Public hosted zone managed by Terraform"
}

variable "private_zone_comment" {
  description = "Comment for the private hosted zone"
  type        = string
  default     = "Private hosted zone managed by Terraform"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
