output "public_zone_id" {
  description = "The ID of the public hosted zone"
  value       = var.create_public_zone ? aws_route53_zone.public[0].zone_id : null
}

output "public_zone_name_servers" {
  description = "The name servers for the public hosted zone"
  value       = var.create_public_zone ? aws_route53_zone.public[0].name_servers : null
}

output "public_zone_arn" {
  description = "The ARN of the public hosted zone"
  value       = var.create_public_zone ? aws_route53_zone.public[0].arn : null
}

output "private_zone_id" {
  description = "The ID of the private hosted zone"
  value       = var.create_private_zone ? aws_route53_zone.private[0].zone_id : null
}

output "private_zone_arn" {
  description = "The ARN of the private hosted zone"
  value       = var.create_private_zone ? aws_route53_zone.private[0].arn : null
}
