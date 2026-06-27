# Git 基本配置與最佳實踐 (Git Setup & Best Practices)

此資料夾包含用於快速配置 Git 帳號資訊與常用別名 (Aliases) 的腳本與相關文件。

## 包含檔案

* **配置腳本**：[setup_git.sh](./setup_git.sh) - 用於設定 Git 使用者資訊與快捷指令。

---

## 腳本功能

* **自動讀取目前設定**：啟動時自動檢查並顯示您目前已設定的 `user.name` 與 `user.email`。
* **智慧互動詢問**：
  * 若兩者皆已設定，預設為不更改 (`n`)，避免誤蓋。
  * 若有欄位尚未設定，預設為啟動更新 (`y`)。
  * 輸入時會提示目前的值，若直接按 Enter 則會保留原設定而不變更。
* **自動設定快捷指令 (Aliases)**：
  * 設定 `cm` 對應到 `commit -m`。您未來可以使用：
    ```bash
    git cm "您的 commit 訊息"
    ```
* **高度擴充性**：腳本內已附上範本說明，您可以隨時編輯該腳本加入您個人習慣的 Git 快捷指令。

---

## 使用方式

請在 `init-env` 專案根目錄下，或是本資料夾內執行：

```bash
# 執行配置腳本
./git/setup_git.sh
```

依照畫面的互動指示填寫即可！

---

## 常見問題與排除 (Troubleshooting)

### 撤銷第一個 Commit 時出現錯誤？
如果您在剛建立專案且只有**唯一一個 Commit** 時執行 `git reset HEAD~1`，會出現以下錯誤：
`fatal: ambiguous argument 'HEAD~1': unknown revision or path not in the working tree`

* **原因**：因為第一個 Commit 沒有「前一個 Commit (HEAD~1)」，因此該路徑無效。
* **解決方法**：請改用以下指令來撤銷第一個 Commit，此指令會安全地刪除 HEAD 引用並保留檔案內容：
  ```bash
  git update-ref -d HEAD
  ```
