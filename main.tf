/**
 * # Terraform to create Arq backup bucket
 *
 * This module sets up an AWS S3 bucket for use as a storage location for Arq backup
 *
 * It sets up the following AWS resources
 * * An S3 bucket for the backups
 * * Bucket encryption
 * * A user with login credentials
 * * Required IAM policy and role for that user to manage the backup bucket
 *
 * # Usage
 *
 * ```hcl
 * module "arc_backup" {
 *   source "ithub.com/bergbrains/terraform-aws-arq-s3-backup"
 *   backup_bucket_name = "my_arq_backup"
 * }
 * ```
 * # Author
 *
 * Eric Berg <eberg@bergbrains.com>
 *
 * You can find this module at [bergbrains s3-mac-backup repo](https://github.com/bergbrains/arq-aws-s3-backup)
 *
 * # API Specs

*/


locals {
  name = "arq-backup"
  tags = {
    owner = local.name
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
  tags                    = local.tags
}

module "backup_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.backup_bucket_name
  acl    = "private"
  tags   = local.tags

  # Allow deletion of non-empty bucket
  force_destroy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  // S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "backup_user" {
  name = local.name
  tags = local.tags
}

data "aws_iam_policy_document" "backup_user_policy" {
  statement {
    actions = [
      "s3:*"
    ]
    sid    = "GrantBackupUserPermissions"
    effect = "Allow"

    resources = [
      "${module.backup_bucket.this_s3_bucket_id}/*"
    ]
  }
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# resource "aws_iam_user_policy" "backup_user" {
#   name   = "backup-user"
#   user   = aws_iam_user.backup_user.name
#   policy = data.aws_iam_policy.AdministratorAccess.policy
# }

resource "aws_iam_user_policy_attachment" "backup_user_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.backup_user.name
}

resource "aws_iam_access_key" "arq_backup" {
  user = aws_iam_user.backup_user.name
}

