variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "engine" {
  description = "The database engine to use (mysql, postgres, mariadb, etc.)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "The upper limit for storage autoscaling (0 to disable)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "The storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key (uses default key if not specified)"
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "vpc_id" {
  description = "The VPC ID where the RDS instance will be created"
  type        = string
}

variable "vpc_cidr_blocks" {
  description = "List of VPC CIDR blocks for egress rules"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Make the database publicly accessible"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying the database"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for (0 to disable)"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range for automated backups"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The weekly maintenance window"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "backup_provider" {
  description = "Backup provider to use (native for RDS snapshots, s3 for S3 exports)"
  type        = string

  validation {
    condition     = contains(["native", "s3"], var.backup_provider)
    error_message = "backup_provider must be either 'native' or 's3'"
  }
}

variable "backup_s3_bucket" {
  description = "S3 bucket name for database exports (required when backup_provider is 's3')"
  type        = string
  default     = null

  validation {
    condition     = var.backup_provider != "s3" || var.backup_s3_bucket != null
    error_message = "backup_s3_bucket is required when backup_provider is 's3'"
  }
}

variable "backup_s3_prefix" {
  description = "S3 key prefix for database exports (required when backup_provider is 's3')"
  type        = string
  default     = null

  validation {
    condition     = var.backup_provider != "s3" || var.backup_s3_prefix != null
    error_message = "backup_s3_prefix is required when backup_provider is 's3'"
  }
}
