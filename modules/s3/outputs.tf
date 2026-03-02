output "s3_bucket_name" {
  value       = aws_s3_bucket.main.bucket
  description = "Tên S3 bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.main.arn
  description = "ARN của S3 bucket"
}
