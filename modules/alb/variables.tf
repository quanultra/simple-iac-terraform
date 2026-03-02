variable "project_name" {
  description = "Tên dự án dùng để đặt tên tài nguyên"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Danh sách ID mạng con công khai cho ALB"
  type        = list(string)
}

variable "tags" {
  description = "Các tag dùng chung"
  type        = map(string)
  default     = {}
}
