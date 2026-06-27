#!/bin/bash

# ==============================================================================
# 說明：Zsh + Oh My Zsh + Powerlevel10k 終端機環境一鍵安裝與配置腳本
# 整合了常用內建與第三方外掛，並支援現代化 ls 替代工具 eza
# ==============================================================================

# 「set -e」表示當腳本中任何一個指令執行失敗時，腳本會立即中斷並退出。
set -e

echo "===================================================="
echo "   Zsh + Oh My Zsh + Powerlevel10k Auto Installer   "
echo "===================================================="

# ------------------------------------------------------------------------------
# 1. 檢查並安裝 Zsh 與 eza (現代化 ls 替代品)
# ------------------------------------------------------------------------------
# 檢查 Zsh
if ! command -v zsh &> /dev/null; then
    echo "[*] 偵測到系統未安裝 Zsh，開始安裝..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew &> /dev/null; then
            echo "[!] 偵測不到 Homebrew。請先安裝 Homebrew (https://brew.sh/) 後再試。"
            exit 1
        fi
        brew install zsh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y zsh git curl
        elif command -v yum &> /dev/null; then
            sudo yum install -y zsh git curl
        else
            echo "[!] 找不到支援的 Linux 套件管理器 (apt-get 或 yum)。請手動安裝 Zsh、Git 和 Curl。"
            exit 1
        fi
    else
        echo "[!] 不支援的作業系統。請手動安裝 Zsh 之後再執行此腳本。"
        exit 1
    fi
else
    echo "[✓] Zsh 已經安裝完成。"
fi

# 檢查與安裝 eza
if ! command -v eza &> /dev/null; then
    echo "[*] 偵測到系統未安裝 eza，開始安裝..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install eza
        else
            echo "[!] 找不到 Homebrew，跳過自動安裝 eza。請於後續手動安裝。"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "[*] Linux 環境下請參考官方安裝指南安裝 eza: https://github.com/eza-community/eza"
    fi
else
    echo "[✓] eza 已經安裝完成。"
fi

# ------------------------------------------------------------------------------
# 2. 安裝 Oh My Zsh 框架
# ------------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[*] 開始安裝 Oh My Zsh 框架..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[✓] Oh My Zsh 已經安裝完成。"
fi

# ------------------------------------------------------------------------------
# 3. 安裝 Powerlevel10k 佈景主題
# ------------------------------------------------------------------------------
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "[*] 開始安裝 Powerlevel10k 佈景主題..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "[✓] Powerlevel10k 主題已經安裝。"
fi

# ------------------------------------------------------------------------------
# 4. 安裝實用的 Zsh 第三方外掛套件
# ------------------------------------------------------------------------------

# 4.1 zsh-autosuggestions (歷史指令自動提示)
AUTOSUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGEST_DIR" ]; then
    echo "[*] 開始安裝 zsh-autosuggestions 外掛..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGEST_DIR"
else
    echo "[✓] zsh-autosuggestions 外掛已安裝。"
fi

# 4.2 zsh-syntax-highlighting (終端機語法高亮)
SYNTAX_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_DIR" ]; then
    echo "[*] 開始安裝 zsh-syntax-highlighting 外掛..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX_DIR"
else
    echo "[✓] zsh-syntax-highlighting 外掛已安裝。"
fi



# ------------------------------------------------------------------------------
# 5. 配置 .zshrc 設定檔
# ------------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"

# 備份原有的 .zshrc 以防萬一
if [ -f "$ZSHRC" ]; then
    BACKUP_ZSHRC="$ZSHRC.backup.$(date +%Y%m%d%H%M%S)"
    echo "[*] 正在將現有的 .zshrc 備份至 $BACKUP_ZSHRC"
    cp "$ZSHRC" "$BACKUP_ZSHRC"
else
    echo "[*] 建立新的 .zshrc 檔案..."
    touch "$ZSHRC"
fi

echo "[*] 開始配置 .zshrc 檔案內容..."

# 5.1 修改或新增 ZSH_THEME 主題設定
if grep -q "^ZSH_THEME=" "$ZSHRC"; then
    echo "[*] 正在更新 ZSH_THEME 為 powerlevel10k..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
    else
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
    fi
else
    echo "[*] 找不到 ZSH_THEME 設定，直接於結尾追加..."
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

# 5.2 更新 plugins (外掛清單) 陣列
# 僅保留 git, zsh-autosuggestions, zsh-syntax-highlighting
if grep -q "^plugins=(" "$ZSHRC"; then
    echo "[*] 正在將新外掛加入現有的 plugins 陣列中..."
    current_plugins=$(grep "^plugins=(" "$ZSHRC" | sed -E 's/plugins=\((.*)\)/\1/')
    new_plugins="$current_plugins"
    
    # 檢查並追加外掛清單
    for plugin in git zsh-autosuggestions zsh-syntax-highlighting; do
        if [[ ! " $current_plugins " =~ " $plugin " ]]; then
            new_plugins="$new_plugins $plugin"
        fi
    done
    new_plugins=$(echo "$new_plugins" | xargs)
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^plugins=(.*/plugins=($new_plugins)/" "$ZSHRC"
    else
        sed -i "s/^plugins=(.*/plugins=($new_plugins)/" "$ZSHRC"
    fi
else
    echo "[*] 找不到 plugins 設定，直接建立完整的 plugins 陣列..."
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> "$ZSHRC"
fi

# 5.3 新增 eza 別名 (Aliases) 到 .zshrc
if ! grep -q "alias ls=\"eza" "$ZSHRC"; then
    echo "[*] 正在為 eza 設定常用別名 (ls, ll, la, lt)..."
    cat << 'EOF' >> "$ZSHRC"

# eza 別名設定 (現代化的 ls 替代品)
if command -v eza &> /dev/null; then
    alias ls="eza --icons --color=always --group-directories-first"
    alias ll="eza -la --icons --color=always --group-directories-first"
    alias la="eza -a --icons --color=always --group-directories-first"
    alias lt="eza --tree --icons"
fi
EOF
fi

# ------------------------------------------------------------------------------
# 6. 將預設 Shell 切換成 Zsh
# ------------------------------------------------------------------------------
ZSH_PATH=$(which zsh)

# 偵測目前使用者的預設 Shell
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURRENT_SHELL=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')
else
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7 || echo "$SHELL")
fi

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    echo "[*] 正在將您的預設 Shell 切換為 Zsh..."
    chsh -s "$ZSH_PATH"
else
    echo "[✓] Zsh 已經是您的預設 Shell。"
fi

echo "===================================================="
echo "   安裝與配置完成！                   "
echo "===================================================="
echo "請重新啟動終端機，或是在目前視窗中執行："
echo "  source ~/.zshrc"
echo "即可套用變更並體驗全新功能。"
echo "===================================================="
