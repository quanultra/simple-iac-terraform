# Terraform Project Rules

Đây là các quy tắc cốt lõi khi làm việc với dự án **simple-iac-terraform**:

## 1. Cấu trúc Code và Module

- **Luôn tách biệt State**: Sử dụng S3/DynamoDB (backend) để lưu state cho môi trường thực tế.
- **Cấu trúc Module**: Mỗi module phải có ít nhất 3 file: `main.tf`, `variables.tf`, và `outputs.tf`.
- **Tái sử dụng**: Hạn chế lặp lại code, sử dụng module khi cần thiết để đóng gói logic (VPC, ALB, EC2, RDS...).

## 2. Tiêu chuẩn viết Code (Coding Standards)

- **Formatting**: Luôn chạy lệnh `terraform fmt -recursive` trước khi commit code.
- **Naming Convention**:
  - Dùng snake_case cho tên resource và biến (VD: `vpc_id`, `web_server`).
  - Đặt tên mang ý nghĩa rõ ràng (VD: `aws_instance.app_server` thay vì `aws_instance.main`).
- **Mô tả (Description)**: Luôn bao gồm thuộc tính `description` cho mọi biến (`variable`) và kết quả đầu ra (`output`).

## 3. Quản lý Biến và Security

- **Hardcode**: Không bao giờ hardcode các thông tin nhạy cảm (Access Key, Secret Key, Passwords) trong mã nguồn. Hãy sử dụng biến môi trường (`TF_VAR_...`) hoặc AWS Secrets Manager/Parameter Store.
- **Giá trị mặc định**: Tránh đặt `default` cho những biến thay đổi theo môi trường (như `instance_type`, `db_password`).
- **Least Privilege**: Cấu hình IAM Roles và Security Groups theo nguyên tắc quyền tối thiểu.

## 4. Quy trình triển khai (Workflows)

- Luôn chạy `terraform validate` và `terraform plan` trước khi thực hiện `terraform apply`.
- Lưu output của plan (`-out=tfplan`) và sử dụng file đó để apply nhằm tránh sự khác biệt.
- Không tự động thực thi các lệnh mang tính phá hủy (như `terraform destroy` hoặc `terraform apply -auto-approve` ở môi trường production).

## 5. Quản lý Phiên bản (Versioning)

- **Provider version**: Luôn khóa (pin) phiên bản của các Terraform provider trong khối `required_providers` (VD: `version = "~> 5.0"`).
- **Terraform version**: Chỉ định rõ phiên bản Terraform yêu cầu trong khối `terraform` (`required_version`).
