# {{MODULE_NAME}}

{{DESCRIPTION}}

## Features

{{FEATURES}}

## Usage

### Basic Example

```hcl
module "{{MODULE_ID}}" {
  source = "{{SOURCE}}"

{{VARIABLES}}
}
```

### Using Outputs

```hcl
# Example: Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.{{MODULE_ID}}.{{FIRST_OUTPUT}}
}

# Available outputs:
{{OUTPUTS_LIST}}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
