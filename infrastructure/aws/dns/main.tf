# AWS DNS Module
# Creates Route53 public and private hosted zones with VPC associations

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Public Hosted Zone
resource "aws_route53_zone" "public" {
  count = var.create_public_zone ? 1 : 0

  name    = var.domain_name
  comment = var.public_zone_comment

  tags = merge(var.tags, {
    Name = "${var.domain_name}-public"
    Type = "public"
  })
}

# Private Hosted Zone
resource "aws_route53_zone" "private" {
  count = var.create_private_zone ? 1 : 0

  name    = var.private_domain_name != null ? var.private_domain_name : var.domain_name
  comment = var.private_zone_comment

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.tags, {
    Name = "${var.domain_name}-private"
    Type = "private"
  })

  lifecycle {
    ignore_changes = [vpc]
  }
}

# Associate additional VPCs with private zone
resource "aws_route53_zone_association" "additional" {
  for_each = var.create_private_zone ? toset(var.additional_vpc_ids) : []

  zone_id = aws_route53_zone.private[0].zone_id
  vpc_id  = each.value
}
