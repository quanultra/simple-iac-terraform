# Terraform Multi-Environment Guide (dev/stg/prod)

Tài liệu này mô tả cách vận hành 3 môi trường độc lập trong thư mục `envs/`, đồng bộ với kiến trúc module trong README chính.

## 1) Mục tiêu của thư mục envs

- Tách `state` theo môi trường để tránh ghi đè lẫn nhau.
- Tách cấu hình biến (`terraform.tfvars`) cho từng môi trường.
- Dùng chung modules, nhưng có root module riêng cho `dev`, `stg`, `prod`.

## 2) Cấu trúc envs

```text
envs/
├── README.md
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── backend.hcl.example
├── stg/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── backend.hcl.example
└── prod/
 ├── main.tf
 ├── variables.tf
 ├── outputs.tf
 ├── terraform.tfvars
 └── backend.hcl.example
```

### Ý nghĩa các file trong mỗi môi trường

- `main.tf`: root module của môi trường, gọi `../../modules/network`, `../../modules/alb`, `../../modules/s3`.
- `variables.tf`: contract input cho môi trường.
- `terraform.tfvars`: giá trị thực tế của môi trường (CIDR, tags, region...).
- `outputs.tf`: thông tin trả ra sau khi apply (VPC ID, ALB DNS, S3 bucket...).
- `backend.hcl.example`: mẫu backend remote state để copy thành `backend.hcl`.

## 3) Quy ước backend state

Mỗi môi trường phải có `key` riêng trong S3 backend:

- dev: `simple-iac-terraform/dev/terraform.tfstate`
- stg: `simple-iac-terraform/stg/terraform.tfstate`
- prod: `simple-iac-terraform/prod/terraform.tfstate`

Khuyến nghị dùng chung:

- cùng một S3 bucket cho state
- cùng một DynamoDB table để lock
- tách key theo môi trường như trên

## 4) Quy trình chạy cho từng môi trường

Ví dụ với `dev`:

```bash
cd envs/dev
cp backend.hcl.example backend.hcl
```

Chỉnh thông tin thật trong `backend.hcl`, sau đó chạy:

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform output
```

Áp dụng tương tự cho `stg` và `prod` bằng cách đổi thư mục.

## 5) Luồng promote khuyến nghị

- Bước 1: chạy và kiểm thử ở `dev`.
- Bước 2: promote thay đổi lên `stg` để xác nhận gần production.
- Bước 3: áp dụng lên `prod` sau khi đã review `plan` kỹ.

Không copy file state giữa các môi trường.

## 6) Checklist an toàn trước apply

- Đang đứng đúng thư mục môi trường (`pwd`).
- `backend.hcl` trỏ đúng `key` của môi trường đó.
- `terraform.tfvars` có `environment` đúng (`dev`, `stg`, `prod`).
- Đã chạy `terraform validate` thành công.
- Đã review kỹ output của `terraform plan`.

## 7) Destroy và kiểm soát chi phí

```bash
terraform destroy
```

Lưu ý:

- Chỉ destroy trong đúng thư mục môi trường cần xóa.
- NAT Gateway phát sinh chi phí theo giờ.
- Nếu S3 bucket có object và `s3_force_destroy = false`, destroy sẽ fail.

## 8) Thông tin liên quan

- Tài liệu tổng quan project: `../README.md`
- File `backend.hcl` thật không nên commit (đã được ignore).
