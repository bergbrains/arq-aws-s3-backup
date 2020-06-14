output "arq_user_aws_secret" {
  value       = "${aws_iam_access_key.arq_backup.secret}"
  description = "Arq backup user AWS API secret token"
}

output "arq_user_aws_id" {
  value       = "${aws_iam_access_key.arq_backup.id}"
  description = "Arq backup user AWS API ID"
}

output "backup_bucket_name" {
  value       = module.backup_bucket.this_s3_bucket_id
  description = "Name of S3 bucket created for backups"
}
output "backup_bucket_arn" {
  value       = module.backup_bucket.this_s3_bucket_arn
  description = "ARN of S3 bucket created for backups"
}
