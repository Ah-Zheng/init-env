#!/bin/bash

# ==============================================================================
# 說明：Git 基本資訊與快捷指令 (Aliases) 配置腳本
# ==============================================================================

# 「set -e」表示當腳本中任何一個指令執行失敗時，腳本會立即中斷並退出。
set -e

echo "===================================================="
echo "          Git 基本資訊與快捷指令配置腳本            "
echo "===================================================="

# ------------------------------------------------------------------------------
# 1. 讀取並顯示目前的 Git 使用者設定
# ------------------------------------------------------------------------------
# 「git config --global user.name || echo ""」
# 如果有設定就顯示名字；如果沒有設定，前面的指令會失敗，此時藉由「||」執行「echo ""」輸出空字串，以避免觸發 set -e 中斷。
CURRENT_NAME=$(git config --global user.name || echo "")
CURRENT_EMAIL=$(git config --global user.email || echo "")

echo "目前系統中的 Git 設定："
if [ -n "$CURRENT_NAME" ]; then
    echo "  - 使用者名稱 (user.name): $CURRENT_NAME"
else
    echo "  - 使用者名稱 (user.name): [尚未設定]"
fi

if [ -n "$CURRENT_EMAIL" ]; then
    echo "  - 電子信箱 (user.email): $CURRENT_EMAIL"
else
    echo "  - 電子信箱 (user.email): [尚未設定]"
fi
echo "===================================================="

# ------------------------------------------------------------------------------
# 2. 互動式設定使用者資訊
# ------------------------------------------------------------------------------
# 判斷是否已經有配置過使用者名稱與信箱
if [ -n "$CURRENT_NAME" ] && [ -n "$CURRENT_EMAIL" ]; then
    # 如果兩者都有配置過，預設為不更改 (n)
    read -p "偵測到您已設定過 Git 使用者名稱與信箱。是否需要更改？(y/n, 預設為 n): " UPDATE_CONF
    UPDATE_CONF=${UPDATE_CONF:-n}
else
    # 如果有任何一個尚未設定，預設為進行設定 (y)
    read -p "偵測到您的 Git 使用者資訊尚未設定完整。是否現在設定？(y/n, 預設為 y): " UPDATE_CONF
    UPDATE_CONF=${UPDATE_CONF:-y}
fi

if [[ "$UPDATE_CONF" =~ ^[Yy]$ ]]; then
    # 詢問姓名，若已有設定，在提示中顯示目前設定值
    if [ -n "$CURRENT_NAME" ]; then
        read -p "請輸入您的 Git 使用者名稱 (user.name) [目前: $CURRENT_NAME]: " GIT_NAME
    else
        read -p "請輸入您的 Git 使用者名稱 (user.name): " GIT_NAME
    fi

    if [ -n "$GIT_NAME" ]; then
        git config --global user.name "$GIT_NAME"
        echo "[✓] 已將 user.name 設定為: $GIT_NAME"
    else
        echo "[*] 未輸入內容，保留原本設定 ($CURRENT_NAME)。"
    fi

    # 詢問 Email，若已有設定，在提示中顯示目前設定值
    if [ -n "$CURRENT_EMAIL" ]; then
        read -p "請輸入您的 Git 電子信箱 (user.email) [目前: $CURRENT_EMAIL]: " GIT_EMAIL
    else
        read -p "請輸入您的 Git 電子信箱 (user.email): " GIT_EMAIL
    fi

    if [ -n "$GIT_EMAIL" ]; then
        git config --global user.email "$GIT_EMAIL"
        echo "[✓] 已將 user.email 設定為: $GIT_EMAIL"
    else
        echo "[*] 未輸入內容，保留原本設定 ($CURRENT_EMAIL)。"
    fi
fi

# ------------------------------------------------------------------------------
# 3. 配置 Git 快捷指令 (Aliases)
# ------------------------------------------------------------------------------
echo "===================================================="
echo "[*] 正在設定 Git 快捷指令 (Aliases)..."

# 「git config --global alias.<縮寫> <完整指令內容>」
# 設定完後即可使用 `git cm` 代替 `git commit -m`
git config --global alias.cm "commit -m"
git config --global alias.cmb "commit -m '暫存變更'"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.bc "branch"
git config --global alias.df "diff"
git config --global alias.lg "log --oneline --graph --all --decorate"
git config --global alias.pp "pull -p"
git config --global alias.r1 "reset HEAD~1"
git config --global alias.rh "reset --hard"
git config --global alias.cp "cherry-pick"
echo "[✓] 已設定 alias:
cm = commit -m,
st = status,
co = checkout,
bc = branch,
df = diff,
lg = log --oneline --graph --all --decorate,
pp = pull -p,
r1 = reset HEAD~1,
rh = reset --hard,
cp = cherry-pick
"

# ------------------------------------------------------------------------------
# 提示區：如果您想新增更多 Git 別名，請直接仿照下方寫法在此處追加指令：
# ------------------------------------------------------------------------------
# 例如：
# git config --global alias.st "status"        # 輸入 git st 即等於 git status
# git config --global alias.co "checkout"      # 輸入 git co 即等於 git checkout
# git config --global alias.br "branch"        # 輸入 git br 即等於 git branch
# git config --global alias.df "diff"          # 輸入 git df 即等於 git diff
# ------------------------------------------------------------------------------

echo "===================================================="
echo "[✓] Git 基本配置設定完成！"
echo "===================================================="
