output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID VPC đã tạo"
}

output "public_subnet_ids" {
  value       = [for subnet in aws_subnet.public : subnet.id]
  description = "Danh sách ID mạng con công khai"
}

output "private_subnet_ids" {
  value       = [for subnet in aws_subnet.private : subnet.id]
  description = "Danh sách ID mạng con riêng tư"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "ID Internet Gateway"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.main.id
  description = "ID NAT Gateway"
}
