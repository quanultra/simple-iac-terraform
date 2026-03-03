#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Cách dùng:
  ./scripts/cidr-range.sh <CIDR>

Ví dụ:
  ./scripts/cidr-range.sh 10.0.1.0/24
  ./scripts/cidr-range.sh 10.0.0.0/16
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 ]]; then
  echo "[ERROR] Bạn phải truyền đúng 1 tham số CIDR."
  usage
  exit 1
fi

CIDR="$1"

python3 - "$CIDR" <<'PY'
import ipaddress
import sys

cidr = sys.argv[1]

try:
    net = ipaddress.ip_network(cidr, strict=False)
except ValueError as exc:
    print(f"[ERROR] CIDR không hợp lệ: {exc}")
    sys.exit(1)

first_ip = net.network_address
last_ip = net.broadcast_address
total_ips = net.num_addresses

print(f"CIDR       : {net.with_prefixlen}")
print(f"IP đầu     : {first_ip}")
print(f"IP cuối    : {last_ip}")
print(f"Tổng số IP : {total_ips}")
PY
