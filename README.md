# Minecraft-Server-Management-Script

用法：
儲存為 minecraft_server_manager.sh。
使可執行檔：chmod +x minecraft_server_manager.sh。
運行：./minecraft_server_manager.sh。
啟動時，選擇語言（1為英語，2為中文）。所有後續提示和選單都將使用所選語言。
透過選擇伺服器類型（Vanilla、Fabric、PaperMC、Spigot 或 Forge）、版本和記憶體設定來部署伺服器。透過選單配置server.properties（例如，設定等級類型、生成怪物等）。
透過外掛程式選單安裝 PaperMC/Spigot 外掛程式或 Fabric/Forge 模組。 Fabric 伺服器自動包含 Fabric API。
檢查 logs/startup.log 中是否存在啟動錯誤（例如，MOD/插件版本不符）。
根據需要使用備份/還原和更新功能。對於基於 cron 的備份，腳本會提示語言以確保正確傳遞訊息。

筆記：
Java 21：此腳本使用 openjdk-21-jre-headless 以相容於 Minecraft 1.21+ 和現代伺服器類型。確保插件/模組與 Java 21 相容。
系統相容性：假設基於 Debian 的系統（使用 apt）。對於其他發行版，請修改 check_dependencies 以使用適當的套件管理器（例如，基於 RHEL 的系統的 yum）或手動安裝 openjdk-21-jre-headless。
語言選擇：語言選單僅在啟動時出現一次（或 cron 作業）。若要變更語言，請重新啟動腳本。
連接埠配置：如果更改伺服器端口，請確保該端口在防火牆中處於開啟狀態且未被使用。
備份：升級版本或修改等級類型等設定之前務必備份，因為它們可能會影響現有世界。
