# VS Code Insiders 擴充套件與偏好設定 (VS Code Setup)

此資料夾用於管理與自動化安裝 **Visual Studio Code / VS Code Insiders** 的擴充套件 (Extensions) 與偏好設定 (Settings)。

> [!NOTE]
> 本模組依賴 VS Code Insiders 應用程式與其內建的 CLI 工具 (`code-insiders`)。建議先執行 `brew/` 模組安裝好 VS Code Insiders。

## 包含檔案

* **全自動安裝腳本**：[install_extensions.sh](./install_extensions.sh) - 批次安裝擴充套件，並自動觸發偏好設定配置。
* **外掛清單**：[extensions.txt](./extensions.txt) - 紀錄所有需自動安裝的擴充套件唯一識別碼 (Extension ID)。
* **偏好設定腳本**：[setup_settings.sh](./setup_settings.sh) - 呼叫 Python 腳本獨立配置偏好設定。
* **設定核心程式**：[configure_settings.py](./configure_settings.py) - 安全讀取並合併 `settings.json`（如 `editor.fontSize: 13`、`window.zoomLevel: 1`），絕不覆蓋使用者既有設定。



---

## 包含外掛清單

預設清單已包含：
1. **語言與中文化**：
   * `ms-ceintl.vscode-language-pack-zh-hant` (繁體中文語言套件)
2. **語法支援與開發工具**：
   * `vue.volar` (Vue 官方支援套件 Volar)
   * `typescriptteam.native-preview` (TypeScript 語言支援預覽)
   * `xabikos.javascriptsnippets` (JavaScript ES6 程式碼片段)
   * `dbaeumer.vscode-eslint` (ESLint 語法檢查與修正)
3. **開發輔助與專案管理**：
   * `alefragnani.project-manager` (專案管理工具)
   * `ritwickdey.liveserver` (本地即時預覽伺服器)
4. **編輯器視覺美化與格式**：
   * `johnpapa.winteriscoming` (Winter is Coming 主題色彩)
   * `oderwat.indent-rainbow` (縮排彩虹色彩標示)
   * `shardulm94.trailing-spaces` (行末多餘空白標示)

---

## 使用方式

請在 `init-env` 專案根目錄下，或是本資料夾內執行：

### 1. 完整安裝外掛與設定
```bash
# 賦予腳本執行權限 (首次使用)
chmod +x ./vscode/install_extensions.sh ./vscode/setup_settings.sh

# 執行安裝腳本 (會依序安裝外掛並配置偏好設定)
./vscode/install_extensions.sh
```
也可以透過專案根目錄的 `./bootstrap.sh` 中控選單勾選執行。

### 2. 僅配置偏好設定 (例如字型大小與縮放比例)
若僅需配置 VS Code 設定而不重新跑外掛安裝：
```bash
# 執行預設配置 (editor.fontSize = 13, window.zoomLevel = 1)
./vscode/setup_settings.sh

# 自訂字型大小或視窗縮放比例
./vscode/setup_settings.sh --font-size 14 --zoom-level 2
```

---

## 偏好設定規則

設定腳本採用 **安全字典合併 (Merge)** 模式，寫入以下設定檔：
* `~/Library/Application Support/Code/User/settings.json` (VS Code)
* `~/Library/Application Support/Code - Insiders/User/settings.json` (VS Code Insiders)

目前預設包含：
* `"editor.fontSize": 13`：編輯器字級大小（預設為 13）。
* `"window.zoomLevel": 1`：視窗整體縮放比例（預設為 1）。
* 保持其他既有設定（如終端機字型 `MesloLGS NF`、主題等）完全不受影響。


---

## 後續擴充方式

如果您有其他想要加入的外掛：
1. 開啟 [extensions.txt](./extensions.txt)。
2. 在新行中填入擴充套件 ID（支援使用 `#` 撰寫註解）：
   ```text
   # 範例：新增 GitLens
   eamodio.gitlens
   ```
3. 重新執行 `./vscode/install_extensions.sh`，腳本會自動進行增量安裝（已安裝的外掛會被快速略過）。

