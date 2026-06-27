# 開發環境一鍵安裝與配置專案 (init-env)

此專案用於整理與收集換新電腦時，所需要安裝的各種開發工具、設定資訊與自動化配置腳本。透過資料夾進行模組化管理，方便日後擴充與維護。

---

## 模組目錄索引

請點擊下方連結檢視各個開發環境模組的詳細說明與安裝指令：

### 1. [Homebrew 與 GUI 軟體安裝 (brew/)](./brew/README.md)
* **包含檔案**：[install.sh](./brew/install.sh)、[Brewfile](./brew/Brewfile)
* **功能簡介**：自動化安裝 Homebrew，並透過 `Brewfile` 批次裝好 `iTerm2` 與 `VS Code Insiders`，同時建立 `code-insiders` (ci) 的終端機指令連結。

### 2. [Zsh 終端機設定與美化 (zsh/)](./zsh/README.md)
* **包含檔案**：[install_zsh_p10k.sh](./zsh/install_zsh_p10k.sh)
* **功能簡介**：自動化安裝 Zsh、Oh My Zsh、Powerlevel10k 主題，並啟用常用外掛（自動提示、語法高亮）與現代化工具 `eza`。

### 3. [Git 基礎配置與別名 (git/)](./git/README.md)
* **包含檔案**：[setup_git.sh](./git/setup_git.sh)
* **功能簡介**：配置全域 `user.name`、`user.email`，並設定常用快捷指令別名（如 `git cm` 替代 `git commit -m`），內附撤銷第一個 commit 的常見錯誤排除方式。

---

## 專案後續規劃

此專案預計陸續新增以下內容，以利建立更完整的電腦起步環境：
* **`configs/`**：儲存個人習慣的設定檔複本（如 VS Code 的 `settings.json`、編輯器快捷鍵設定等）。
* **`docs/`**：整理無法被程式自動化完成的「手動檢查清單」（如各通訊軟體登入移轉、SSH Key 產生與配置等）。
