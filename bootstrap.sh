#!/bin/bash

# ==============================================================================
# 說明：開發環境一鍵安裝與配置中控引導腳本 (bootstrap.sh)
# 提供終端機互動式多選選單，勾選欲執行的模組後依序自動化執行。
# ==============================================================================

# 「set -e」表示當腳本中任何一個指令執行失敗時，腳本會立即中斷並退出。
set -e

# 1. 定義可選的腳本選項名稱
OPTIONS=(
    "安裝 Homebrew 與軟體/CLI 工具 (brew/)"
    "安裝 VS Code Insiders 擴充套件 (vscode/)"
    "設定 Zsh 終端機與 Powerlevel10k 主題 (zsh/)"
    "配置 Git 使用者資訊與常用別名 (git/)"
)

# 2. 定義對應選項的選取狀態：0 代表未選取，1 代表已選取
# 預設為全未選取 [0, 0, 0, 0]
STATES=(0 0 0 0)

# 3. 畫面上顯示多選選單的函式
show_menu() {
    clear
    echo "===================================================="
    echo "        開發環境一鍵安裝與配置中控選單              "
    echo "===================================================="
    echo " 1. 輸入選項編號 [1-4] 並按 Enter：可「勾選/取消勾選」項目 (此時不會執行)"
    echo " 2. 輸入 [y] 或 [Y] 並按 Enter：開始依序執行所有已勾選的項目"
    echo " 3. 輸入 [q] 或 [Q] 並按 Enter：退出此選單"
    echo "----------------------------------------------------"

    # 迴圈讀取 OPTIONS 陣列並渲染出選單外觀
    for i in "${!OPTIONS[@]}"; do
        if [ "${STATES[$i]}" -eq 1 ]; then
            echo "  [✓] $((i+1)). ${OPTIONS[$i]}"
        else
            echo "  [ ] $((i+1)). ${OPTIONS[$i]}"
        fi
    done
    echo "----------------------------------------------------"
}

# 4. 互動選單循環邏輯
while true; do
    show_menu
    read -p "請輸入編號或指令 (y/q): " CHOICE

    case "$CHOICE" in
        [1-4])
            # 計算對應的陣列索引（因為選單顯示是 1-4，陣列索引是 0-3）
            INDEX=$((CHOICE-1))
            # 切換選取狀態（0 變 1，1 變 0）
            if [ "${STATES[$INDEX]}" -eq 1 ]; then
                STATES[$INDEX]=0
            else
                STATES[$INDEX]=1
            fi
            ;;
        [Yy])
            # 使用者確認執行，跳出互動循環
            break
            ;;
        [Qq])
            echo "已取消執行並退出。"
            exit 0
            ;;
        *)
            echo "[!] 無效的輸入，請按任意鍵重新輸入..."
            # 讀取單一鍵以暫停畫面，讓使用者看清錯誤訊息
            read -n 1
            ;;
    esac
done

# ------------------------------------------------------------------------------
# 5. 依序執行已勾選的安裝項目
# ------------------------------------------------------------------------------
echo "===================================================="
echo "          開始執行已選取的環境安裝與設定項目...      "
echo "===================================================="

# 計算被勾選的項目總數
SELECTED_COUNT=0
for state in "${STATES[@]}"; do
    if [ "$state" -eq 1 ]; then
        SELECTED_COUNT=$((SELECTED_COUNT+1))
    fi
done

if [ "$SELECTED_COUNT" -eq 0 ]; then
    echo "[*] 您沒有勾選任何項目，安裝結束。"
    exit 0
fi

CURRENT_STEP=1

# 5.1 執行 Homebrew 與軟體/CLI 工具安裝
if [ "${STATES[0]}" -eq 1 ]; then
    echo ">>> [${CURRENT_STEP}/${SELECTED_COUNT}] 執行中：安裝 Homebrew 與軟體/CLI 工具..."
    # 確保子腳本具有執行權限
    chmod +x ./brew/install.sh
    ./brew/install.sh
    CURRENT_STEP=$((CURRENT_STEP+1))
    echo "----------------------------------------------------"
fi

# 5.2 執行 VS Code Insiders 擴充套件安裝
if [ "${STATES[1]}" -eq 1 ]; then
    echo ">>> [${CURRENT_STEP}/${SELECTED_COUNT}] 執行中：安裝 VS Code Insiders 擴充套件..."
    chmod +x ./vscode/install_extensions.sh
    ./vscode/install_extensions.sh
    CURRENT_STEP=$((CURRENT_STEP+1))
    echo "----------------------------------------------------"
fi

# 5.3 執行 Zsh 美化設定
if [ "${STATES[2]}" -eq 1 ]; then
    echo ">>> [${CURRENT_STEP}/${SELECTED_COUNT}] 執行中：設定 Zsh 終端機與主題..."
    chmod +x ./zsh/install_zsh_p10k.sh
    ./zsh/install_zsh_p10k.sh
    CURRENT_STEP=$((CURRENT_STEP+1))
    echo "----------------------------------------------------"
fi

# 5.4 執行 Git 使用者與別名配置
if [ "${STATES[3]}" -eq 1 ]; then
    echo ">>> [${CURRENT_STEP}/${SELECTED_COUNT}] 執行中：配置 Git 資訊與常用別名..."
    chmod +x ./git/setup_git.sh
    ./git/setup_git.sh
    CURRENT_STEP=$((CURRENT_STEP+1))
    echo "----------------------------------------------------"
fi

echo "===================================================="
echo "          [✓] 所有選定項目執行完畢！                "
echo "===================================================="
