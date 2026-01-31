# Module: dns

## Description

Creates Route53 public and private hosted zones with VPC associations

## Features

- Creates public hosted zones with optional comments and tags
- Creates private hosted zones with VPC associations
- Supports additional VPC associations for private hosted zones
- Allows customization of domain names for private hosted zones
- Provides outputs for hosted zone IDs, ARNs, and name servers
- Supports tagging for all resources
- Enables conditional creation of public and private hosted zones

## Basic Usage

```hcl
module "dns" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/dns?ref=v1.20.0"

  domain_name = "your-domain-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.dns.public_zone_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_vpc_ids"></a> [additional\_vpc\_ids](#input\_additional\_vpc\_ids) | Additional VPC IDs to associate with the private hosted zone | `list(string)` | `[]` | no |
| <a name="input_create_private_zone"></a> [create\_private\_zone](#input\_create\_private\_zone) | Whether to create a private hosted zone | `bool` | `true` | no |
| <a name="input_create_public_zone"></a> [create\_public\_zone](#input\_create\_public\_zone) | Whether to create a public hosted zone | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for the hosted zones (e.g., example.com) | `string` | n/a | yes |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | The domain name for the private hosted zone (defaults to domain\_name if not specified) | `string` | `null` | no |
| <a name="input_private_zone_comment"></a> [private\_zone\_comment](#input\_private\_zone\_comment) | Comment for the private hosted zone | `string` | `"Private hosted zone managed by Terraform"` | no |
| <a name="input_public_zone_comment"></a> [public\_zone\_comment](#input\_public\_zone\_comment) | Comment for the public hosted zone | `string` | `"Public hosted zone managed by Terraform"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to associate with the private hosted zone | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_zone_arn"></a> [private\_zone\_arn](#output\_private\_zone\_arn) | The ARN of the private hosted zone |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | The ID of the private hosted zone |
| <a name="output_public_zone_arn"></a> [public\_zone\_arn](#output\_public\_zone\_arn) | The ARN of the public hosted zone |
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | The ID of the public hosted zone |
| <a name="output_public_zone_name_servers"></a> [public\_zone\_name\_servers](#output\_public\_zone\_name\_servers) | The name servers for the public hosted zone |
<!-- END_TF_DOCS -->
