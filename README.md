# 開發環境一鍵安裝與配置專案 (init-env)

此專案用於整理與收集換新電腦時，所需要安裝的各種開發工具、設定資訊與自動化配置腳本。透過資料夾進行模組化管理，並在專案根目錄提供了一個主控選單，方便您自由勾選想要安裝與設定的項目。

---

## 如何使用 (快速起步)

專案根目錄下提供了一個中控引導腳本 `bootstrap.sh`，可啟動互動式選單讓您勾選欲執行的模組：

### 步驟 1：賦予腳本執行權限
在專案根目錄下執行：
```bash
chmod +x bootstrap.sh
```

### 步驟 2：執行引導選單
```bash
./bootstrap.sh
```

### 步驟 3：在選單中操作
* **切換勾選狀態**：輸入選項數字（例如 `1`、`2` 或 `3`）並按下 **Enter** 鍵。這只會切換該項目的「勾選/取消勾選」狀態，**此時並不會執行安裝**。
* **開始執行安裝**：當您勾選好所有想安裝的項目後，輸入 `y` 或 `Y` 並按下 **Enter** 鍵，系統便會依照順序執行所有被勾選的腳本。
* **退出選單**：輸入 `q` 或 `Q` 並按下 **Enter** 鍵即可直接退出。

---

## 模組目錄索引

如果您不想使用中控選單，也可以直接點擊下方連結，手動進入各別目錄檢視詳細說明與執行獨立的腳本：

### 1. [Homebrew 與軟體/CLI 工具安裝 (brew/)](./brew/README.md)
* **包含檔案**：[install.sh](./brew/install.sh)、[Brewfile](./brew/Brewfile)
* **功能簡介**：自動化安裝 Homebrew，並透過 `Brewfile` 批次裝好 `iTerm2`、`VS Code Insiders`、`OrbStack` 與 `Antigravity CLI`，同時建立 `code-insiders` (ci) 的終端機指令連結。

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
