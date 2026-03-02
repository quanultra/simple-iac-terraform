variable "project_name" {
  description = "Tên dự án dùng để đặt tên tài nguyên"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải CIDR cho VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con công khai"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "2 dải CIDR cho mạng con riêng tư"
  type        = list(string)
}

variable "tags" {
  description = "Các tag dùng chung"
  type        = map(string)
  default     = {}
}
