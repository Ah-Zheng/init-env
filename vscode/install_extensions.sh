#!/bin/bash

# ==============================================================================
# 說明：VS Code Insiders 擴充套件 (Extensions) 自動安裝腳本
# 讀取同目錄下的 extensions.txt，透過 VS Code Insiders CLI (code-insiders) 批次安裝外掛。
# ==============================================================================

# 「set -e」表示當任何指令執行失敗時，腳本會立即中斷並退出。
set -e

echo "===================================================="
echo "       VS Code Insiders Extensions Installer        "
echo "===================================================="

# ------------------------------------------------------------------------------
# 1. 偵測 VS Code Insiders CLI 可執行檔路徑
# ------------------------------------------------------------------------------
VSCODE_INSIDERS_APP="/Applications/Visual Studio Code - Insiders.app"
CLI_BIN=""

if command -v code-insiders &> /dev/null; then
    CLI_BIN="$(command -v code-insiders)"
elif [ -x "$HOME/.local/bin/code-insiders" ]; then
    CLI_BIN="$HOME/.local/bin/code-insiders"
elif [ -x "$VSCODE_INSIDERS_APP/Contents/Resources/app/bin/code" ]; then
    CLI_BIN="$VSCODE_INSIDERS_APP/Contents/Resources/app/bin/code"
fi

if [ -z "$CLI_BIN" ]; then
    echo "[!] 找不到 VS Code Insiders 命令列工具 (code-insiders)。"
    echo "    請確認已先透過「brew/」安裝 VS Code Insiders (或執行 ./brew/install.sh)。"
    exit 1
fi

echo "[✓] 找到 VS Code Insiders CLI: $CLI_BIN"

# ------------------------------------------------------------------------------
# 2. 讀取清單並批次安裝擴充套件
# ------------------------------------------------------------------------------
EXTENSIONS_FILE="$(dirname "$0")/extensions.txt"

if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo "[!] 找不到擴充套件清單檔案: $EXTENSIONS_FILE"
    exit 1
fi

echo "[*] 開始讀取 extensions.txt 並批次安裝外掛..."

TOTAL_COUNT=0
SUCCESS_COUNT=0

while IFS= read -r line || [ -n "$line" ]; do
    # 移除行尾註解與前後多餘空白
    ext="${line%%#*}"
    ext=$(echo "$ext" | xargs)

    # 略過空行
    [ -z "$ext" ] && continue

    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    echo "----------------------------------------------------"
    echo ">>> [${TOTAL_COUNT}] 正在安裝外掛: $ext"

    if "$CLI_BIN" --install-extension "$ext" --force; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "[!] 安裝失敗: $ext"
    fi
done < "$EXTENSIONS_FILE"

echo "===================================================="
echo "[✓] VS Code Insiders 擴充套件安裝完畢！(成功: ${SUCCESS_COUNT}/${TOTAL_COUNT})"
echo "===================================================="
