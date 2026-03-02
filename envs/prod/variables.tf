variable "project_name" {
  description = "Tên dự án dùng để đặt tên tài nguyên"
  type        = string
}

variable "environment" {
  description = "Nhãn môi trường"
  type        = string
}

variable "aws_region" {
  description = "Khu vực AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải CIDR cho VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con công khai"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Bạn phải cung cấp đúng 2 dải CIDR cho mạng con công khai."
  }
}

variable "private_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con riêng tư"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Bạn phải cung cấp đúng 2 dải CIDR cho mạng con riêng tư."
  }
}

variable "s3_force_destroy" {
  description = "Cho phép Terraform xóa bucket S3 không rỗng khi hủy hạ tầng"
  type        = bool
}
