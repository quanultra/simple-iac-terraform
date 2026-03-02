output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "Tên DNS của ALB"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "ID nhóm bảo mật của ALB"
}

output "app_security_group_id" {
  value       = aws_security_group.app.id
  description = "ID nhóm bảo mật của ứng dụng"
}

output "alb_arn" {
  value       = aws_lb.app.arn
  description = "ARN của ALB"
}
