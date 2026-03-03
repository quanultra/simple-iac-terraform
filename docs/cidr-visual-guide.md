# CIDR Cheat Sheet cho project simple-iac-terraform

Tài liệu này giúp bạn nhìn nhanh:
- Mỗi CIDR bao phủ dải IP nào (IP đầu / IP cuối)
- Dải nào nằm trong dải nào (subset)
- Dải nào chồng lấn giữa các môi trường

---

## 1) Quy tắc đọc nhanh

- Prefix càng nhỏ thì dải càng lớn (`/16` lớn hơn `/24`).
- Nếu một dải nằm trọn trong dải khác thì **có chồng lấn theo nghĩa toán học**.
- Trong cùng VPC, subnet nằm trong VPC là **đúng thiết kế**, không phải lỗi.
- Lỗi nguy hiểm là chồng lấn giữa:
  - subnet với subnet khác trong cùng VPC, hoặc
  - VPC này với VPC/mạng khác cần kết nối (peering/VPN).

---

## 2) Bảng CIDR theo từng môi trường

## Dev (`envs/dev/terraform.tfvars`)

| Loại | CIDR | IP đầu | IP cuối | Ghi chú |
|---|---|---|---|---|
| VPC | `10.0.0.0/16` | `10.0.0.0` | `10.0.255.255` | Dải mạng tổng |
| Public Subnet 1 | `10.0.1.0/24` | `10.0.1.0` | `10.0.1.255` | Nằm trong VPC Dev |
| Public Subnet 2 | `10.0.2.0/24` | `10.0.2.0` | `10.0.2.255` | Nằm trong VPC Dev |
| Private Subnet 1 | `10.0.11.0/24` | `10.0.11.0` | `10.0.11.255` | Nằm trong VPC Dev |
| Private Subnet 2 | `10.0.12.0/24` | `10.0.12.0` | `10.0.12.255` | Nằm trong VPC Dev |

Kết luận nhanh cho Dev:
- Không có subnet nào chồng lấn nhau.
- Tất cả subnet đều là subset hợp lệ của VPC `10.0.0.0/16`.

## Staging (`envs/stg/terraform.tfvars`)

| Loại | CIDR | IP đầu | IP cuối | Ghi chú |
|---|---|---|---|---|
| VPC | `10.10.0.0/16` | `10.10.0.0` | `10.10.255.255` | Dải mạng tổng |
| Public Subnet 1 | `10.10.1.0/24` | `10.10.1.0` | `10.10.1.255` | Nằm trong VPC Stg |
| Public Subnet 2 | `10.10.2.0/24` | `10.10.2.0` | `10.10.2.255` | Nằm trong VPC Stg |
| Private Subnet 1 | `10.10.11.0/24` | `10.10.11.0` | `10.10.11.255` | Nằm trong VPC Stg |
| Private Subnet 2 | `10.10.12.0/24` | `10.10.12.0` | `10.10.12.255` | Nằm trong VPC Stg |

Kết luận nhanh cho Stg:
- Không có subnet nào chồng lấn nhau.
- Tất cả subnet đều là subset hợp lệ của VPC `10.10.0.0/16`.

## Production (`envs/prod/terraform.tfvars`)

| Loại | CIDR | IP đầu | IP cuối | Ghi chú |
|---|---|---|---|---|
| VPC | `10.20.0.0/16` | `10.20.0.0` | `10.20.255.255` | Dải mạng tổng |
| Public Subnet 1 | `10.20.1.0/24` | `10.20.1.0` | `10.20.1.255` | Nằm trong VPC Prod |
| Public Subnet 2 | `10.20.2.0/24` | `10.20.2.0` | `10.20.2.255` | Nằm trong VPC Prod |
| Private Subnet 1 | `10.20.11.0/24` | `10.20.11.0` | `10.20.11.255` | Nằm trong VPC Prod |
| Private Subnet 2 | `10.20.12.0/24` | `10.20.12.0` | `10.20.12.255` | Nằm trong VPC Prod |

Kết luận nhanh cho Prod:
- Không có subnet nào chồng lấn nhau.
- Tất cả subnet đều là subset hợp lệ của VPC `10.20.0.0/16`.

---

## 3) So sánh chồng lấn giữa các môi trường

| Cặp VPC | Chồng lấn? | Lý do |
|---|---|---|
| Dev `10.0.0.0/16` vs Stg `10.10.0.0/16` | Không | Khác block mạng |
| Dev `10.0.0.0/16` vs Prod `10.20.0.0/16` | Không | Khác block mạng |
| Stg `10.10.0.0/16` vs Prod `10.20.0.0/16` | Không | Khác block mạng |

Kết luận tổng:
- Thiết kế CIDR hiện tại **không chồng lấn giữa các môi trường**.
- Phù hợp để mở rộng peering/VPN trong tương lai.

---

## 4) Mẹo kiểm tra cực nhanh

Cho hai dải `A` và `B`:
- Viết thành khoảng `[IP_đầu, IP_cuối]`.
- Nếu hai khoảng giao nhau -> chồng lấn.
- Nếu tách rời hoàn toàn -> không chồng lấn.

Công thức:
- Chồng lấn khi: `A_start <= B_end` và `B_start <= A_end`.

---

## 5) Tham chiếu file nguồn

- `envs/dev/terraform.tfvars`
- `envs/stg/terraform.tfvars`
- `envs/prod/terraform.tfvars`
