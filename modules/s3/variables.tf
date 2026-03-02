variable "project_name" {
  description = "Tên dự án dùng để đặt tên tài nguyên"
  type        = string
}

variable "s3_force_destroy" {
  description = "Cho phép Terraform xóa bucket S3 không rỗng khi hủy hạ tầng"
  type        = bool
}

variable "tags" {
  description = "Các tag dùng chung"
  type        = map(string)
  default     = {}
}
