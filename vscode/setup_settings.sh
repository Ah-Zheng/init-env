#!/bin/bash

# ==============================================================================
# 說明：VS Code / VS Code Insiders 偏好設定自動化配置腳本
# 呼叫同目錄下的 configure_settings.py，以安全合併 (merge) 方式配置 settings.json。
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/configure_settings.py"

if ! command -v python3 &> /dev/null; then
    echo "[!] 系統未安裝 python3，無法執行 VS Code 設定配置。"
    exit 1
fi

if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "[!] 找不到設定配置腳本: $PYTHON_SCRIPT"
    exit 1
fi

python3 "$PYTHON_SCRIPT" "$@"
