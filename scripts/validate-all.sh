#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVS=("dev" "stg" "prod")

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$1"
}

for env in "${ENVS[@]}"; do
  ENV_DIR="${ROOT_DIR}/envs/${env}"

  if [[ ! -d "${ENV_DIR}" ]]; then
    echo "[ERROR] Không tìm thấy thư mục môi trường: ${ENV_DIR}" >&2
    exit 1
  fi

  log "Bắt đầu validate môi trường: ${env}"
  cd "${ENV_DIR}"

  rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

  terraform init -backend=false -reconfigure -input=false
  terraform fmt -recursive
  terraform validate

  log "Validate thành công: ${env}"
done

log "Hoàn tất validate cả 3 môi trường (dev/stg/prod)."
