---

# Minecraft 伺服器管理器腳本 (Minecraft Server Manager Script)

一個功能強大且全面的 Bash 腳本，用於在 Linux 伺服器上輕鬆部署、管理和維護多個 Minecraft 伺服器。

A powerful and comprehensive Bash script for easily deploying, managing, and maintaining multiple Minecraft servers on a Linux server.

---

## ✨ 功能特色 (Features)

*   **🌐 多語言介面 (Multi-Language Interface)**: 支援繁體中文和英文，啟動時可自由切換。
*   **✅ 依賴自動檢查 (Dependency Checker)**: 自動檢測 `Java`, `curl`, `jq` 等必要工具，並提示使用 sudo 自動安裝。
*   **🗂️ 多伺服器管理 (Multi-Server Management)**: 在單一腳本內建立和管理多個獨立的伺服器實例。
*   **⚙️ 多版本支援 (Multiple Server Types)**:
    *   **PaperMC**: 自動獲取版本列表並下載，為插件提供最佳效能。
    *   **Fabric**: 自動安裝 Fabric Loader，輕鬆管理模組。
    *   **自訂檔案**: 支援使用您自己的 `server.jar` 或伺服器 `.zip` 包。
*   **🎮 直覺的控制台 (Intuitive Control Panel)**:
    *   使用 `screen` 進行安全的背景運作。
    *   輕鬆啟動、停止、進入伺服器後台。
    *   直接從選單發送指令（如 `op` 玩家）。
*   **🧩 插件/模組管理 (Plugin/Mod Management)**:
    *   整合 [Modrinth API](https://modrinth.com/)，可直接搜尋並安裝與伺服器版本相容的插件和模組。
    *   **智慧提示**: 建立 Fabric 伺服器時，會檢查並提示安裝必備的 Fabric API。
*   **🔒 合規與安全 (Compliance & Security)**:
    *   **EULA 合規**: 在建立伺服器時，會引導使用者閱讀並親自同意 Minecraft EULA。
    *   **安全停止**: 使用 `stop` 指令正常關閉伺服器，確保世界資料被完整保存。
*   **💾 備份與還原 (Backup & Restore)**:
    *   一鍵備份伺服器世界檔案。
    *   可從現有備份列表中選擇並還原。
*   **📝 伺服器設定 (Server Configuration)**: 提供互動式介面，方便修改 `server.properties` 中的常用設定。

---

## 📋 事前準備 (Prerequisites)

在執行此腳本之前，請確保您的系統滿足以下條件：

1.  **作業系統 (Operating System)**:
    *   一個基於 Debian 的發行版 (如 Ubuntu, Debian)。
    *   或一個基於 Red Hat 的發行版 (如 CentOS, Fedora, RHEL)。
2.  **使用者權限 (User Permissions)**:
    *   需要 `sudo` 權限，以便腳本可以為您自動安裝缺少的依賴工具。
3.  **核心依賴 (Core Dependencies)**:
    *   腳本會嘗試自動安裝以下工具，但若能預先安裝會更順利：
        *   `java` (需要 **Java 21** 或更高版本)
        *   `curl`
        *   `jq` (用於處理 API 回應)
        *   `screen` (用於背景執行伺服器)
        *   `wget`
        *   `tar`
        *   `unzip`

---

## 🚀 使用說明 (Usage)

下載或複製腳本後，在您的終端機中執行以下指令：

#### 1. 儲存檔案
將腳本程式碼儲存為 `mc_manager.sh` 檔案。

```bash
# 例如，使用 wget 從網路上下載
# wget [腳本的URL] -O mc_manager.sh

# 或者，使用文字編輯器 (如 nano) 貼上程式碼
# nano mc_manager.sh
```

#### 2. 賦予執行權限
此指令讓腳本檔案可以被執行。

```bash
chmod +x mc_manager.sh
```

#### 3. 執行腳本
開始使用 Minecraft 伺服器管理器！

```bash
./mc_manager.sh
```

腳本啟動後，您將看到語言選擇畫面，之後便可進入主選單開始操作。

---

## 📁 檔案結構 (File Structure)

所有由本腳本建立的伺服器都將存放於您的家目錄下的 `mc_servers` 資料夾中，結構如下：

```
~/
└── mc_servers/
    ├── my_paper_server/      # 您的第一個伺服器
    │   ├── server.jar
    │   ├── eula.txt
    │   ├── server.properties
    │   ├── plugins/          # Paper 伺服器的插件目錄
    │   ├── logs/
    │   ├── backups/          # 備份檔案存放處
    │   ├── .mc_version       # 記錄 MC 版本
    │   └── .server_type      # 記錄伺服器類型 (paper, fabric, etc.)
    │
    └── my_fabric_server/     # 您的第二個伺服器
        ├── server.jar        # (這是 fabric-server-launch.jar)
        ├── mods/             # Fabric 伺服器的模組目錄
        └── ...
```

---

## ⚠️ 免責聲明 (Disclaimer)

*   本腳本旨在簡化伺服器管理流程，請自行承擔使用風險。
*   **使用者有最終責任閱讀並遵守 Minecraft 的終端使用者授權協議 (EULA)**。腳本會在建立伺服器時提示您同意 EULA，請務必了解其內容。
*   在執行還原或刪除等破壞性操作前，請務必確認您的選擇，並建議手動保留一份額外備份。
