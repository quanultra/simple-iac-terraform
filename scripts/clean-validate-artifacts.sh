#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENVS=("dev" "stg" "prod")
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

log() {
  printf "\n[%s] %s\n" "$(date +"%H:%M:%S")" "$1"
}

remove_path() {
  local target="$1"

  if [[ -e "${target}" ]]; then
    if [[ "${DRY_RUN}" == true ]]; then
      echo "[DRY-RUN] Sẽ xóa: ${target}"
    else
      rm -rf "${target}"
      echo "[OK] Đã xóa: ${target}"
    fi
  fi
}

cleanup_env() {
  local env="$1"
  local env_dir="${ROOT_DIR}/envs/${env}"

  if [[ ! -d "${env_dir}" ]]; then
    echo "[WARN] Không tìm thấy thư mục môi trường: ${env_dir}"
    return
  fi

  log "Dọn artifact cho môi trường: ${env}"

  remove_path "${env_dir}/.terraform"
  remove_path "${env_dir}/.terraform.lock.hcl"
  remove_path "${env_dir}/terraform.tfstate"
  remove_path "${env_dir}/terraform.tfstate.backup"
  remove_path "${env_dir}/tfplan"
  remove_path "${env_dir}/plan.json"
}

log "Bắt đầu dọn artifact từ quá trình validate/plan"
for env in "${ENVS[@]}"; do
  cleanup_env "${env}"
done

if [[ "${DRY_RUN}" == true ]]; then
  log "Hoàn tất kiểm tra (dry-run). Không có file nào bị xóa."
else
  log "Dọn dẹp hoàn tất."
fi
