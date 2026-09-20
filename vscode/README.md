# VS Code Insiders 擴充套件自動化安裝 (VS Code Insiders Extensions Setup)

此資料夾用於管理與自動化安裝 **Visual Studio Code - Insiders** 的擴充套件 (Extensions)。

> [!NOTE]
> 本模組依賴 VS Code Insiders 應用程式與其內建的 CLI 工具 (`code-insiders`)。建議先執行 `brew/` 模組安裝好 VS Code Insiders。

## 包含檔案

* **安裝腳本**：[install_extensions.sh](./install_extensions.sh) - 透過 `code-insiders` CLI 批次安裝擴充套件。
* **外掛清單**：[extensions.txt](./extensions.txt) - 紀錄所有需自動安裝的擴充套件唯一識別碼 (Extension ID)。

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

```bash
# 賦予腳本執行權限 (首次使用)
chmod +x ./vscode/install_extensions.sh

# 執行安裝腳本
./vscode/install_extensions.sh
```

也可以透過專案根目錄的 `./bootstrap.sh` 中控選單勾選執行。

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
