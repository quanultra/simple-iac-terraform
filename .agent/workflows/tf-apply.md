---
description: Áp dụng các thay đổi Terraform (Apply)
---

# Terraform Apply Workflow
Workflow này thực thi file plan đã được tạo từ bước `tf-plan` để cập nhật cơ sở hạ tầng.

> **Chú ý:** Đảm bảo bạn đã kiểm tra kỹ file plan trước khi chạy workflow này.

## Bước 1: Apply Changes
// turbo
terraform apply "tfplan"
