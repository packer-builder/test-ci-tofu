# Module: s3

## Description

Creates an S3 bucket with versioning, encryption, and access controls

## Features

- Creates an S3 bucket with customizable name and environment
- Configures versioning and server-side encryption for data protection
- Supports lifecycle rules for object transitions and expirations
- Enables CORS configuration for cross-origin resource sharing
- Blocks public access to the bucket by default
- Provides optional access logging for monitoring
- Supports tagging for resource organization

## Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/s3?ref=v1.20.0"

  bucket_name        = "your-bucket-name"
  environment        = "your-environment"
  test_storage_class = "your-test-storage-class"
}
```

### Usage with Standard Storage Class

```hcl
module "s3" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/s3?ref=v1.20.0"

  bucket_name        = "your-bucket-name"
  environment        = "your-environment"
  test_storage_class = "standard"
}
```

### Usage with Intelligent Tiering Storage Class

```hcl
module "s3" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/s3?ref=v1.20.0"

  bucket_name        = "your-bucket-name"
  environment        = "your-environment"
  test_storage_class = "intelligent_tiering"
}
```

### Usage with Glacier Storage Class

```hcl
module "s3" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/s3?ref=v1.20.0"

  bucket_name        = "your-bucket-name"
  environment        = "your-environment"
  test_glacier_days  = "your-test-glacier-days"  # Required when test_storage_class = "glacier"
  test_storage_class = "glacier"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.s3.bucket_id
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
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_cors_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the bucket (e.g., dev, staging, prod) | `string` | n/a | yes |
| <a name="input_test_storage_class"></a> [test\_storage\_class](#input\_test\_storage\_class) | Storage class for test objects (standard, intelligent\_tiering, glacier) | `string` | n/a | yes |
| <a name="input_block_public_access"></a> [block\_public\_access](#input\_block\_public\_access) | Block all public access to the bucket | `bool` | `true` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | List of CORS rules for the bucket | <pre>list(object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = list(string)<br/>    max_age_seconds = number<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Enable access logging for the bucket | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of non-empty bucket | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of KMS key for server-side encryption (uses AES256 if not specified) | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle rules for the bucket | <pre>list(object({<br/>    id      = string<br/>    enabled = bool<br/>    prefix  = string<br/>    transitions = list(object({<br/>      days          = number<br/>      storage_class = string<br/>    }))<br/>    expiration_days                    = optional(number)<br/>    noncurrent_version_expiration_days = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_test_glacier_days"></a> [test\_glacier\_days](#input\_test\_glacier\_days) | Days before transitioning to Glacier (required when test\_storage\_class is 'glacier') | `number` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable versioning for the bucket | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name of the bucket |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | The AWS region where the bucket is located |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route53 hosted zone ID for the bucket region |
<!-- END_TF_DOCS -->
