variable "project_name" {
  description = "Tên dự án dùng để đặt tên tài nguyên"
  type        = string
  default     = "simple-iac"
}

variable "environment" {
  description = "Nhãn môi trường"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Khu vực AWS"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "Dải CIDR cho VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con công khai"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Bạn phải cung cấp đúng 2 dải CIDR cho mạng con công khai."
  }
}

variable "private_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con riêng tư"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Bạn phải cung cấp đúng 2 dải CIDR cho mạng con riêng tư."
  }
}

variable "s3_force_destroy" {
  description = "Cho phép Terraform xóa bucket S3 không rỗng khi hủy hạ tầng"
  type        = bool
  default     = false
}
