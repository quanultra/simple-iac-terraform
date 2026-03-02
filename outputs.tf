output "vpc_id" {
  value       = module.network.vpc_id
  description = "ID VPC đã tạo"
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Danh sách ID mạng con công khai"
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Danh sách ID mạng con riêng tư"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Tên DNS của ALB"
}

output "alb_security_group_id" {
  value       = module.alb.alb_security_group_id
  description = "ID nhóm bảo mật của ALB"
}

output "app_security_group_id" {
  value       = module.alb.app_security_group_id
  description = "ID nhóm bảo mật của ứng dụng"
}

output "s3_bucket_name" {
  value       = module.s3.s3_bucket_name
  description = "Tên bucket S3"
}
