# Terraform Lab AWS (Module-based + Multi-Environment)

Project này dùng để thực hành Infrastructure as Code với Terraform trên AWS, theo cấu trúc gần với cách triển khai thực tế trong team.

Hạ tầng mẫu bao gồm:

- VPC
- 2 Public Subnets + 2 Private Subnets
- Network ACLs (public/private)
- Route Tables (public/private)
- Internet Gateway + NAT Gateway
- Security Groups cho ALB và app
- Application Load Balancer (ALB)
- S3 bucket (private, versioning, encryption)

## 1) Mục tiêu học từ project này

- Hiểu cách tách Terraform theo module theo domain (`network`, `alb`, `s3`).
- Hiểu cách tách môi trường `dev/stg/prod` bằng root module riêng.
- Hiểu cách dùng remote state với S3 + state locking bằng DynamoDB.
- Thực hành workflow chuẩn: `init -> fmt -> validate -> plan -> apply -> output -> destroy`.

## 2) Cấu trúc thư mục dự án

```text
simple-iac-terraform/
├── .gitignore
├── README.md
├── versions.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars.example
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── s3/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── envs/
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

## 3) Giải thích vai trò từng phần

### Root level

- `versions.tf`: khóa phiên bản Terraform và provider để tránh drift version.
- `variables.tf`: input cho root module (dùng khi chạy ở root).
- `main.tf`: phần orchestration, gọi các child modules.
- `outputs.tf`: export thông tin quan trọng sau `apply`.
- `terraform.tfvars.example`: mẫu cấu hình biến để copy khi cần chạy nhanh ở root.

### Thư mục `modules/`

- `modules/network`: toàn bộ networking (VPC, subnet, route, NACL, IGW, NAT).
- `modules/alb`: security groups và ALB listener HTTP.
- `modules/s3`: S3 bucket với baseline bảo mật (public access block, versioning, SSE).

Mỗi module đều có 3 file chuẩn:

- `variables.tf`: input contract của module.
- `main.tf`: resource implementation.
- `outputs.tf`: output contract trả về cho root module.

### Thư mục `envs/`

Đây là phần quan trọng cho thực tế:

- Mỗi môi trường (`dev`, `stg`, `prod`) là một root module độc lập.
- Mỗi môi trường có `terraform.tfvars` riêng để tách CIDR/tags/cấu hình.
- Mỗi môi trường có `backend.hcl.example` để cấu hình remote state key riêng.

Kết quả: state của từng môi trường tách biệt, giảm rủi ro apply nhầm môi trường.

## 4) Điều kiện trước khi chạy

- Terraform CLI đã cài (`>= 1.5`)
- AWS credentials hợp lệ (IAM user hoặc role)
- Quyền tạo resource VPC/EC2/ELB/S3/IAM liên quan

Kiểm tra nhanh:

```bash
terraform -version
aws sts get-caller-identity
```

## 5) Chạy theo môi trường (khuyến nghị)

Ví dụ với `dev`:

```bash
cd envs/dev
cp backend.hcl.example backend.hcl
```

Sửa `backend.hcl` với thông tin thật:

- `bucket`: S3 bucket chứa Terraform state
- `key`: đã tách theo môi trường (dev/stg/prod)
- `region`: region chứa backend
- `dynamodb_table`: bảng lock state

Sau đó chạy:

```bash
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform output
```

## 6) Các output quan trọng

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `alb_dns_name`
- `s3_bucket_name`

Kiểm tra ALB:

```bash
curl http://<alb_dns_name>
```

Kỳ vọng nhận được response `ALB is up`.

## 7) Quản lý state và an toàn khi làm việc

- Không commit file `backend.hcl` thật (đã ignore trong `.gitignore`).
- Không commit file state local (`*.tfstate`, `.terraform/`).
- Luôn chạy đúng thư mục môi trường trước khi `plan/apply/destroy`.
- Nên review kỹ `terraform plan` trước khi apply.

## 8) Destroy và dọn dẹp chi phí

```bash
terraform destroy
```

Lưu ý:

- NAT Gateway có phát sinh chi phí theo giờ.
- Nếu S3 bucket có object và `s3_force_destroy = false`, destroy sẽ fail.
- Có thể xóa object trước hoặc bật `s3_force_destroy = true` cho môi trường lab.

## 9) Best practices đã áp dụng trong project

- Tách module theo domain, không gom toàn bộ resource vào một file lớn.
- Tách root module theo môi trường để cô lập state và config.
- Dùng `locals.common_tags` để gắn tag nhất quán.
- Dùng output contract giữa các module để giảm phụ thuộc cứng.

## 10) Tài liệu liên quan

- Hướng dẫn multi-env chi tiết: `envs/README.md`
