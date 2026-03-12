---
description: Khởi tạo Project (Init & Validate)
---

# Terraform Init Workflow
Workflow này dùng để khởi tạo Terraform project, tải các providers và modules cần thiết, sau đó kiểm tra tính hợp lệ của code.

## Bước 1: Khởi tạo thư mục làm việc
// turbo
terraform init

## Bước 2: Format Code (ẩn)
// turbo
terraform fmt -recursive

## Bước 3: Kiểm tra cấu hình (Validate)
// turbo
terraform validate
