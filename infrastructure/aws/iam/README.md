# Module: iam

## Description

Creates IAM roles with policies and optional instance profiles

## Features

- Creates IAM roles with customizable assume role policies
- Attaches managed policies to IAM roles
- Supports inline policies for granular access control
- Generates optional instance profiles for IAM roles
- Allows tagging of all resources for better organization
- Supports permission boundaries for enhanced security

## Basic Usage

```hcl
module "iam" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/iam?ref=v1.19.0"

  role_name = "your-role-name"
}
```

### Usage with Custom Permission Boundary

```hcl
module "iam" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/iam?ref=v1.19.0"

  role_name                = "your-role-name"
  test_custom_boundary_arn = "your-test-custom-boundary-arn"  # Required when test_permission_boundary = "custom"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.iam.role_arn
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
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role (must be unique within the AWS account) | `string` | n/a | yes |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | JSON policy document for assume role | `string` | `null` | no |
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Whether to create an instance profile for the role | `bool` | `false` | no |
| <a name="input_inline_policy"></a> [inline\_policy](#input\_inline\_policy) | Inline policy JSON document to attach to the role | `string` | `null` | no |
| <a name="input_inline_policy_name"></a> [inline\_policy\_name](#input\_inline\_policy\_name) | Name for the inline policy | `string` | `"inline-policy"` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | List of IAM policy ARNs to attach to the role | `list(string)` | `[]` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the IAM role | `string` | `"IAM role managed by Terraform"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_test_custom_boundary_arn"></a> [test\_custom\_boundary\_arn](#input\_test\_custom\_boundary\_arn) | Custom permission boundary ARN (required when test\_permission\_boundary is 'custom') | `string` | `null` | no |
| <a name="input_test_permission_boundary"></a> [test\_permission\_boundary](#input\_test\_permission\_boundary) | Permission boundary type (none, restrictive, custom) | `string` | `"none"` | no |
| <a name="input_trusted_service"></a> [trusted\_service](#input\_trusted\_service) | AWS service that can assume this role (e.g., ec2.amazonaws.com, lambda.amazonaws.com) | `string` | `"ec2.amazonaws.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | ARN of the instance profile (if created) |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Name of the instance profile (if created) |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | ID of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role |
<!-- END_TF_DOCS -->
