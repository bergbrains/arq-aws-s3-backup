output "arq_user_aws_secret" {
  # value = "${aws_iam_access_key.lb.encrypted_secret}"
  value = "${aws_iam_access_key.arq_backup.secret}"
}

output "arq_user_aws_id" {
  value = "${aws_iam_access_key.arq_backup.id}"
}

output "backup_bucket_name" {
  value = module.backup_bucket.this_s3_bucket_id
}
output "backup_bucket_arn" {
  value = module.backup_bucket.this_s3_bucket_arn
}
