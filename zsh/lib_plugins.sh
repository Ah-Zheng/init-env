#!/bin/bash

# ==============================================================================
# 說明：.zshrc plugins 陣列維護函式庫（僅供 source，不可直接執行）
# 支援單行 plugins=(a b) 與 Oh My Zsh 預設的多行寫法，已存在的外掛不會重複加入。
# ==============================================================================

# 用法：ensure_plugins <zshrc 路徑> <外掛名稱...>
ensure_plugins() {
    local zshrc="$1"
    shift

    if ! grep -q "^plugins=(" "$zshrc"; then
        echo "plugins=($*)" >> "$zshrc"
        return 0
    fi

    # 擷取整個 plugins 區塊（可跨多行，到第一個「)」為止）並去除註解，取得目前外掛清單
    local current missing="" plugin
    current=$(awk '
        /^plugins=\(/ { in_block = 1 }
        in_block {
            line = $0
            sub(/#.*/, "", line)
            sub(/^plugins=\(/, "", line)
            closed = (line ~ /\)/)
            sub(/\).*/, "", line)
            print line
            if (closed) exit
        }
    ' "$zshrc")

    for plugin in "$@"; do
        if [[ ! " $(echo $current) " =~ " $plugin " ]]; then
            missing="$missing $plugin"
        fi
    done
    missing="${missing# }"
    [ -z "$missing" ] && return 0

    # 重寫檔案：只在 plugins 區塊的結尾「)」前插入缺少的外掛，其餘內容原封不動
    local tmp
    tmp=$(mktemp)
    awk -v missing="$missing" '
        /^plugins=\(/ && !done { in_block = 1 }
        in_block && !done {
            code = $0
            sub(/#.*/, "", code)
            if (code ~ /\)/) {
                if ($0 ~ /^[[:space:]]*\)[[:space:]]*$/) {
                    n = split(missing, items, " ")
                    for (i = 1; i <= n; i++) print "  " items[i]
                    print $0
                } else {
                    # 結尾「)」與外掛同一行：在「)」前面補上空白與缺少的外掛
                    idx = index($0, ")")
                    print substr($0, 1, idx - 1) " " missing substr($0, idx)
                }
                in_block = 0
                done = 1
                next
            }
        }
        { print }
    ' "$zshrc" > "$tmp"
    cat "$tmp" > "$zshrc"
    rm -f "$tmp"
}
