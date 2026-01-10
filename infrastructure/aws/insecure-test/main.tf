# INTENTIONALLY INSECURE CODE FOR TESTING TFSEC
# DO NOT USE IN PRODUCTION

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ISSUE 1: S3 bucket without encryption (HIGH)
resource "aws_s3_bucket" "insecure" {
  bucket = "my-insecure-bucket"
}

# ISSUE 2: Security group with unrestricted ingress (CRITICAL)
resource "aws_security_group" "insecure" {
  name        = "insecure-sg"
  description = "Insecure security group"

  ingress {
    description = "Allow all from anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ISSUE 3: RDS without encryption (HIGH)
resource "aws_db_instance" "insecure" {
  identifier        = "insecure-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "admin"
  password          = "insecurepassword123"  # Hardcoded password (CRITICAL)

  storage_encrypted = false  # No encryption
  skip_final_snapshot = true
}
