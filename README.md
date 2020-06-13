# Terraform to create Arq backup bucket

This module sets up an AWS S3 bucket for use as a storage location for Arq backup

It sets up the following AWS resources
* An S3 bucket for the backups
* Bucket encryption
* A user with login credentials
* Required IAM policy and role for that user to manage the backup bucket

# Usage

```hcl
module "arc_backup" {
  source "..."
  backup_bucket_name = "my_arq_backup"
}
```
# Author

Eric Berg <eberg@bergbrains.com>

You can find this module at [bergbrains s3-mac-backup repo](https://github.com/bergbrains/arq-aws-s3-backup)

# API Specs

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_bucket\_name | Arq backup bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arq\_user\_aws\_id | n/a |
| arq\_user\_aws\_secret | n/a |
| backup\_bucket\_arn | n/a |
| backup\_bucket\_name | n/a |

