# Zsh 終端機美化與增強 (Zsh & Powerlevel10k)

此資料夾包含用於自動化建立高效、美觀的 Zsh 開發環境的腳本與說明。

## 包含檔案

* **安裝腳本**：[install_zsh_p10k.sh](./install_zsh_p10k.sh) - 一鍵自動化安裝與配置腳本。

---

## 安裝內容

本腳本將自動執行以下任務：
1. **檢查並安裝 Zsh**：自動偵測作業系統並安裝 Zsh。
2. **安裝 eza**：自動在 macOS 上安裝熱門的 `ls` 替代工具 `eza`，並於 `.zshrc` 設定美化別名。
3. **安裝 Oh My Zsh**：若尚未安裝，會自動從官方源安裝 Oh My Zsh。
4. **安裝 Powerlevel10k 主題**：自動複製最新版 `powerlevel10k` 佈景主題。
5. **安裝與啟用實用外掛套件**：
   * **內建外掛**：
     * `git`：提供豐富的 Git 快捷指令（如 `gst`, `gco`, `gp`）。
   * **第三方外掛**：
     * `zsh-autosuggestions`：自動提示指令（依據歷史紀錄）。
     * `zsh-syntax-highlighting`：終端機指令語法即時高亮。
6. **自動修改 `.zshrc`**：
   * 將主題設為 `powerlevel10k/powerlevel10k`。
   * 將外掛清單寫入 `plugins=(...)`。
   * 為 `eza` 註冊快捷指令別名（將 `ls`、`ll`、`la`、`lt` 對應到帶有 Icon 且按資料夾置前排列的 eza 輸出）。
   * 自動備份原有的 `.zshrc` 檔案（備份檔檔名為 `.zshrc.backup.時間戳記`）。
7. **配置 VS Code / VS Code Insiders 終端機字型**：自動在編輯器設定檔中套用 `MesloLGS NF`，防止終端機圖示破圖。
8. **切換預設 Shell**：如果預設 Shell 不是 Zsh，將自動為您切換。

---

## 使用方式

請在 `init-env` 專案根目錄下，或是本資料夾內執行：

```bash
# 執行安裝腳本
./zsh/install_zsh_p10k.sh
```

### 安裝後設定：
1. 套用變更：
   ```bash
   source ~/.zshrc
   ```
2. 當您首次載入時，系統會自動啟動 **Powerlevel10k 設定精靈**。請跟著精靈的提示選擇您喜愛的樣式。

---

## 功能體驗

### 1. 現代化 `ls` 替代：`eza`
您可以輸入以下別名體驗：
* `ls`：帶有色彩與圖示的檔案清單。
* `ll`：詳細的檔案清單列表。
* `la`：顯示包含隱藏檔案的所有檔案。
* `lt`：以樹狀圖 (Tree) 形式列出檔案目錄。

### 2. 如何重新設定主題樣式？
若您之後想改變終端機風格，隨時在終端機輸入：
```bash
p10k configure
```
