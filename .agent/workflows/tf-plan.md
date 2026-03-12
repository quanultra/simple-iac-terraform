---
description: Format, Validate và Plan (chuẩn bị thay đổi)
---

# Terraform Plan Workflow
Workflow này giúp kiểm tra lỗi cú pháp, format code và xem trước các thay đổi sẽ được tạo ra bởi Terraform.

## Bước 1: Format Code
// turbo
terraform fmt -recursive

## Bước 2: Validate Cấu hình
// turbo
terraform validate

## Bước 3: Tạo Plan
// turbo
terraform plan -out=tfplan
