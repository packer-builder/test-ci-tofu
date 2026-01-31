# Infrastructure Modules

This repository contains reusable Terraform/OpenTofu modules for AWS and Azure infrastructure.

## Available Modules

<!-- BEGIN_MODULES -->
| Module | Type | Description |
|--------|------|-------------|
| [dns](./infrastructure/aws/dns) | Terraform/OpenTofu | Creates AWS Route53 public and private hosted zones with optional VPC associations |
| [iam](./infrastructure/aws/iam) | Terraform/OpenTofu | Creates and manages AWS IAM roles with optional policies and instance profiles |
| [rds](./infrastructure/aws/rds) | Terraform/OpenTofu | Creates an AWS RDS database instance with configurable settings |
| [s3](./infrastructure/aws/s3) | Terraform/OpenTofu | Creates an AWS S3 bucket with advanced configurations |
| [vpc](./infrastructure/aws/vpc) | Terraform/OpenTofu | Creates a complete VPC with public and private subnets in AWS |
| [sql](./infrastructure/azure/sql) | Terraform/OpenTofu | Creates an Azure SQL Server and Database with security configurations |
| [storage](./infrastructure/azure/storage) | Terraform/OpenTofu | Creates an Azure Storage Account with optional blob containers, lifecycle management, and network rules |
| [vnet](./infrastructure/azure/vnet) | Terraform/OpenTofu | Creates an Azure Virtual Network with public and private subnets and associated Network Security Groups |
| [code_repository](./infrastructure/code_repository) | Terraform/OpenTofu | Configures Git provider integrations for repository management |
<!-- END_MODULES -->

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/packer-builder/test-ci-tofu.git//infrastructure/aws/vpc?ref=v1.18.0"

  vpc_cidr = "10.0.0.0/16"
  vpc_name = "my-vpc"
}
```

## Development Guidelines

### Branch Naming

Branches must follow the conventional commit pattern:

```
type/description
```

**Valid types:**
- `feat/` - New feature
- `fix/` - Bug fix
- `docs/` - Documentation changes
- `style/` - Code style changes (formatting, etc.)
- `refactor/` - Code refactoring
- `perf/` - Performance improvements
- `test/` - Adding or updating tests
- `build/` - Build system changes
- `ci/` - CI/CD changes
- `chore/` - Other changes
- `revert/` - Revert a previous commit

**Examples:**
```
feat/add-s3-module
fix/vpc-subnet-cidr
docs/update-readme
```

### Commit Messages

Commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
type(scope): description

[optional body]

[optional footer]
```

**Examples:**
```
feat(vpc): add support for multiple NAT gateways
fix(iam): correct assume role policy for Lambda
docs(dns): update usage examples
```

### Pull Requests

1. Create a branch following the naming convention
2. Make your changes and commit using conventional commits
3. Push and create a Pull Request
4. CI checks will run automatically:
   - **Validate Branch Name** - Ensures branch follows naming convention
   - **Validate Commits** - Ensures commits follow conventional commits
   - **Validate** - Runs `tofu fmt` and `tofu validate` on all modules
5. Merge when all checks pass

## CI/CD Workflows

| Workflow | Trigger | Description |
|----------|---------|-------------|
| Commitlint | PR | Validates branch name and commit messages |
| Validate | PR | Runs `tofu fmt` and `tofu validate` |
| Security Scan | PR | Runs tfsec to detect security issues |
| Generate README | Push to main | Generates module READMEs with AI and terraform-docs |
| Release Please | Push to main | Creates Release PR with version bump and CHANGELOG |
| Update README Versions | Release published | Updates module READMEs to reference the new version |

## Local Development

### Prerequisites

- [OpenTofu](https://opentofu.org/) or Terraform
- [Node.js](https://nodejs.org/) (for commit hooks)
- [terraform-docs](https://terraform-docs.io/)

### Setup

```bash
# Install dependencies
npm install

# Pre-commit hooks are automatically installed via Husky
```

### Pre-commit Hooks

The following validations run automatically on commit:

1. **Branch name validation** - Ensures branch follows naming convention
2. **tofu fmt** - Formats Terraform files
3. **tofu validate** - Validates all modules
4. **commitlint** - Validates commit message format

## Releases

Releases are managed using [Release Please](https://github.com/googleapis/release-please):

1. When PRs are merged to `main`, Release Please creates/updates a **Release PR**
2. The Release PR contains the version bump and updated CHANGELOG
3. When you merge the Release PR, the release is published

**Version bumps based on commits:**
- `feat:` commits trigger a **minor** version bump (1.x.0)
- `fix:` commits trigger a **patch** version bump (1.0.x)
- `feat!:` or `BREAKING CHANGE:` trigger a **major** version bump (x.0.0)

## License

MIT
