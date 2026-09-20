# Homebrew 與軟體/CLI 工具自動化安裝 (Homebrew & Apps Setup)

此資料夾包含自動化安裝 macOS 套件管理器 **Homebrew**，以及透過 Homebrew 快速安裝 **iTerm2**、**Visual Studio Code - Insiders**、**OrbStack** 與 **Antigravity CLI** 等工具與應用程式的配置。

## 包含檔案

* **安裝腳本**：[install.sh](./install.sh) - 自動安裝 Homebrew 並執行 `Brewfile` 配置。
* **軟體清單**：[Brewfile](./Brewfile) - 紀錄需要安裝的應用程式與 CLI 工具 (Casks) 列表。

---

## 腳本功能

1. **安裝 Homebrew**：
   * 自動偵測晶片架構（Apple Silicon 或 Intel）並自動配置對應的環境變數至 `~/.zprofile` 中。
2. **自動安裝軟體與 CLI 工具**：
   * 讀取同目錄下的 `Brewfile`，批次下載並安裝：
     * **iTerm2** (macOS 專用最強終端機替代品)
     * **VS Code Insiders** (VS Code 預覽/開發版)
     * **OrbStack** (極速、輕量級的 Docker Desktop 替代方案)
     * **Antigravity CLI** (Google Antigravity 終端機代理程式介面，提供 `agy` 指令)
3. **VS Code Insiders 終端機指令 (CLI) 設定**：
   * 在 `~/.local/bin` 底下建立 `code-insiders` 的軟連結 (Symlink)，使您能夠直接在終端機中透過 `code-insiders .` 或縮寫 `ci .` 來用 VS Code 開啟當前資料夾。

> [!NOTE]
> VS Code Insiders 的擴充套件 (Extensions) 已獨立至最外層的 [vscode/](../vscode/README.md) 模組進行統一管理與安裝。

---

## 使用方式

請在 `init-env` 專案根目錄下，或是本資料夾內執行：

```bash
# 賦予腳本執行權限
chmod +x ./brew/install.sh

# 執行安裝腳本
./brew/install.sh
```

---

## 後續擴充方式

如果您有其他想安裝的應用程式（例如 Slack, Google Chrome 等），您可以直接編輯 [Brewfile](./Brewfile)，並在底下新增對應的行：

```ruby
# 範例：新增 Slack 與 Chrome
cask "slack"
cask "google-chrome"
```

修改完後重新執行 `./brew/install.sh` 即可自動增量安裝。
