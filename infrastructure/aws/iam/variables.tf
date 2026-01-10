variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "IAM role managed by Terraform"
}

variable "assume_role_policy" {
  description = "JSON policy document for assume role"
  type        = string
  default     = null
}

variable "trusted_service" {
  description = "AWS service that can assume this role (e.g., ec2.amazonaws.com, lambda.amazonaws.com)"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "Inline policy JSON document to attach to the role"
  type        = string
  default     = null
}

variable "inline_policy_name" {
  description = "Name for the inline policy"
  type        = string
  default     = "inline-policy"
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for the role"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
