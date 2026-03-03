#!/bin/bash

# Script: Kiểm tra hai dải CIDR có chồng lấn (overlap) nhau hay không
# Cách sử dụng: ./cidr-overlap.sh <CIDR_1> <CIDR_2>
# Ví dụ: ./cidr-overlap.sh 10.0.0.0/16 10.10.0.0/16

if [[ $# -ne 2 ]]; then
    echo "❌ Cách sử dụng: $0 <CIDR_1> <CIDR_2>"
    echo ""
    echo "Ví dụ:"
    echo "  $0 10.0.0.0/16 10.10.0.0/16        (Không chồng lấn)"
    echo "  $0 10.0.0.0/16 10.0.1.0/24         (Có chồng lấn)"
    echo "  $0 10.0.0.0/16 10.0.0.0/24         (Subnet - Có chồng lấn)"
    echo ""
    exit 1
fi

CIDR_1="$1"
CIDR_2="$2"

python3 << EOF
import ipaddress
import sys

cidr_1 = "$CIDR_1"
cidr_2 = "$CIDR_2"

try:
    net1 = ipaddress.IPv4Network(cidr_1, strict=False)
    net2 = ipaddress.IPv4Network(cidr_2, strict=False)

    # Check for overlaps
    overlaps = net1.overlaps(net2)

    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("KIỂM TRA CHỒNG LẤN CIDR")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print()
    print(f"📍 Dải CIDR 1: {cidr_1}")
    print(f"   ├─ IP đầu:     {net1.network_address}")
    print(f"   ├─ IP cuối:    {net1.broadcast_address}")
    print(f"   └─ Tổng cộng:  {net1.num_addresses} địa chỉ")
    print()
    print(f"📍 Dải CIDR 2: {cidr_2}")
    print(f"   ├─ IP đầu:     {net2.network_address}")
    print(f"   ├─ IP cuối:    {net2.broadcast_address}")
    print(f"   └─ Tổng cộng:  {net2.num_addresses} địa chỉ")
    print()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    if overlaps:
        print("⚠️  KẾT QUẢ: HAI DẢI CIDR CÓ CHỒNG LẤN!")
        print()

        # Find the relationship
        if net1.subnet_of(net2):
            print(f"📌 Chi tiết: Dải {cidr_1} nằm HOÀN TOÀN TRONG dải {cidr_2}")
            print(f"   → {cidr_1} là subnet của {cidr_2}")
        elif net2.subnet_of(net1):
            print(f"📌 Chi tiết: Dải {cidr_2} nằm HOÀN TOÀN TRONG dải {cidr_1}")
            print(f"   → {cidr_2} là subnet của {cidr_1}")
        else:
            print(f"📌 Chi tiết: Hai dải CÓ MỘT PHẦN CHỒNG LẤN")
            # Calculate overlap
            overlap_start = max(net1.network_address, net2.network_address)
            overlap_end = min(net1.broadcast_address, net2.broadcast_address)
            overlap_count = int(overlap_end) - int(overlap_start) + 1
            print(f"   ├─ Vùng chồng lấn: {overlap_start} → {overlap_end}")
            print(f"   └─ {overlap_count} địa chỉ IP bị chồng lấn")

        print()
        print("⛔ VẤN ĐỀ: Điều này sẽ gây ra xung đột khi triển khai!")
        print("   - Không thể gán hai mạng riêng biệt có IP trùng lặp")
        print("   - Nên sử dụng các dải CIDR hoàn toàn khác nhau")
    else:
        print("✅ KẾT QUẢ: HAI DẢI CIDR KHÔNG CHỒNG LẤN")
        print()

        # Show which is smaller/larger and gap
        if net1.network_address < net2.network_address:
            print(f"📌 Chi tiết: {cidr_1} ở phía TRƯỚC, {cidr_2} ở phía SAU")
            gap = int(net2.network_address) - int(net1.broadcast_address) - 1
            print(f"   └─ Khoảng cách: {gap} địa chỉ IP giữa hai dải")
        else:
            print(f"📌 Chi tiết: {cidr_2} ở phía TRƯỚC, {cidr_1} ở phía SAU")
            gap = int(net1.network_address) - int(net2.broadcast_address) - 1
            print(f"   └─ Khoảng cách: {gap} địa chỉ IP giữa hai dải")

        print()
        print("✨ LỢI ÍCH: Các dải CIDR này có thể được sử dụng đồng thời")
        print("   - Có thể kết nối hai mạng riêng biệt an toàn")
        print("   - Phù hợp cho kiến trúc multi-environment (dev/stg/prod)")

    print()
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

except ipaddress.AddressValueError as e:
    print("❌ Lỗi: CIDR không hợp lệ")
    print(f"   Chi tiết: {e}")
    print()
    print("   Định dạng CIDR đúng: 10.0.0.0/16, 192.168.1.0/24, v.v...")
    sys.exit(1)
except Exception as e:
    print(f"❌ Lỗi lầm: {e}")
    sys.exit(1)

EOF
