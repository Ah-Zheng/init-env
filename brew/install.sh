#!/bin/bash

# ==============================================================================
# 說明：macOS Homebrew 與 GUI 應用程式 (iTerm2, VS Code Insiders) 自動安裝腳本
# ==============================================================================

# 「set -e」表示當任何指令執行失敗時，腳本會立即中斷並退出。
set -e

echo "===================================================="
echo "          macOS Homebrew & Apps Auto Installer      "
echo "===================================================="

# ------------------------------------------------------------------------------
# 1. 檢查並安裝 Homebrew
# ------------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "[*] 未偵測到 Homebrew，開始進行安裝..."
    # 執行 Homebrew 官方安裝指令碼
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 針對 Apple Silicon (M1/M2/M3 等) 與 Intel 晶片的 Mac 設定路徑環境變數
    # 「uname -m」用來讀取晶片架構，"arm64" 代表 Apple Silicon M 系列晶片
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo '[*] 設定 Apple Silicon Mac 的 Homebrew 環境變數...'
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # 寫入 ~/.zprofile，這樣每次開機或重開終端機都會自動載入 brew
        if ! grep -q "shellenv" "$HOME/.zprofile" 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        fi
    else
        echo '[*] 設定 Intel Mac 的 Homebrew 環境變數...'
        eval "$(/usr/local/bin/brew shellenv)"
        if ! grep -q "shellenv" "$HOME/.zprofile" 2>/dev/null; then
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        fi
    fi
else
    echo "[✓] Homebrew 已經安裝。"
fi

# ------------------------------------------------------------------------------
# 2. 使用 Brewfile 進行應用程式的批量安裝
# ------------------------------------------------------------------------------
# 取得目前腳本所在目錄的絕對路徑，藉此尋找同目錄下的 Brewfile
BREWFILE_PATH="$(dirname "$0")/Brewfile"

if [ -f "$BREWFILE_PATH" ]; then
    echo "[*] 偵測到 Brewfile，開始安裝 iTerm2 與 VS Code Insiders..."
    # 「brew bundle」會自動讀取指定的 Brewfile 檔並將裡面列出的套件與 Casks 安裝起來
    brew bundle --file="$BREWFILE_PATH"
else
    echo "[!] 找不到 Brewfile，跳過軟體安裝流程。"
fi

# ------------------------------------------------------------------------------
# 3. 設定 VS Code Insiders 的 Command Line Interface (CLI)
# ------------------------------------------------------------------------------
echo "[*] 設定 VS Code Insiders 終端機指令 (code-insiders)..."
# 建立使用者自訂的可執行檔放置目錄（~/.local/bin），此路徑已在 Zsh 配置中被加入 PATH
mkdir -p "$HOME/.local/bin"

VSCODE_INSIDERS_APP="/Applications/Visual Studio Code - Insiders.app"

if [ -d "$VSCODE_INSIDERS_APP" ]; then
    # 「ln -sf <原始檔案> <目標連結>」：建立軟連結 (Symbolic Link)
    # 將 VS Code 內建的 CLI 執行檔連結到我們的 bin 目錄，讓您可以直接在終端機輸入 `code-insiders` 或 `ci` 開啟專案
    ln -sf "$VSCODE_INSIDERS_APP/Contents/Resources/app/bin/code-insiders" "$HOME/.local/bin/code-insiders"
    echo "[✓] 已成功建立 code-insiders 軟連結至 ~/.local/bin/code-insiders"
else
    echo "[!] 找不到已安裝的 VS Code Insiders，請確認應用程式是否成功寫入 /Applications 目錄。"
fi

echo "===================================================="
echo "[✓] Homebrew 與應用程式配置完成！"
echo "===================================================="
