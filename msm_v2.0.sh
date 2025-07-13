#!/bin/bash

# Enhanced Minecraft Server Manager Script
# Features: Comprehensive server.properties configuration, support for Vanilla, Fabric, PaperMC, Spigot, Forge;
# MOD/plugin version mismatch error logging, EULA auto-accept, automated backups, and multilingual support
# Java Version: Uses Java 21 or higher for compatibility with Minecraft 1.21+ and modern server types
# Language: Added language selection menu (English/Chinese) at startup

# Language support (English and Chinese)
declare -A LANG_EN=(
    ["select_language"]="Select language (1: English, 2: Chinese):"
    ["invalid_language"]="Invalid language selection. Please choose 1 or 2."
    ["welcome"]="Welcome to Minecraft Server Manager"
    ["select_option"]="Select an option:"
    ["deploy_server"]="Deploy New Server"
    ["manage_servers"]="Manage Existing Servers"
    ["backup_restore"]="Backup/Restore"
    ["view_logs"]="View Server Logs"
    ["exit"]="Exit"
    ["select_version"]="Select Minecraft version:"
    ["server_type"]="Select server type (1: Vanilla, 2: Fabric, 3: PaperMC, 4: Spigot, 5: Forge):"
    ["custom_jar"]="Use custom JAR or ZIP file"
    ["enter_jar_path"]="Enter path to custom JAR/ZIP file:"
    ["invalid_path"]="Invalid file path. Please try again."
    ["install_deps"]="Missing dependencies detected. Install them? (y/n)"
    ["plugin_menu"]="Plugin/MOD Management:"
    ["install_plugin"]="Install Plugin/MOD"
    ["remove_plugin"]="Remove Plugin/MOD"
    ["list_plugins"]="List Installed Plugins/MODs"
    ["plugin_repo"]="Browse Plugin Repository"
    ["back"]="Back"
    ["enter_plugin_url"]="Enter plugin/MOD download URL:"
    ["invalid_url"]="Invalid URL. Please try again."
    ["console_cmd"]="Enter console command (or 'exit' to quit):"
    ["backup_now"]="Create backup now"
    ["restore_backup"]="Restore from backup"
    ["schedule_backup"]="Schedule Automated Backups"
    ["select_backup"]="Select backup to restore:"
    ["check_update"]="Check for server updates"
    ["no_update"]="No updates available."
    ["update_available"]="Update available: %s. Upgrade? (y/n)"
    ["invalid_input"]="Invalid input. Please try again."
    ["server_running"]="Server is running. Stop it first."
    ["select_server"]="Select server to manage:"
    ["start_server"]="Start Server"
    ["stop_server"]="Stop Server"
    ["restart_server"]="Restart Server"
    ["console"]="Server Console"
    ["op_player"]="Grant OP to Player"
    ["deop_player"]="Remove OP from Player"
    ["kick_player"]="Kick Player"
    ["ban_player"]="Ban Player"
    ["enter_player"]="Enter player name:"
    ["server_dir"]="Enter server directory name:"
    ["invalid_dir"]="Invalid directory name. Please try again."
    ["backup_success"]="Backup created successfully: %s"
    ["restore_success"]="Restore completed: %s"
    ["backup_schedule_set"]="Backup schedule set: %s"
    ["memory_config"]="Enter memory settings (e.g., 2G 4G for min/max):"
    ["invalid_memory"]="Invalid memory settings. Use format like '2G 4G'."
    ["status"]="Server Status"
    ["players_online"]="Players Online: %s"
    ["view_logs"]="View Logs"
    ["startup_error"]="Server startup failed. Check logs for details: %s"
    ["configure_properties"]="Configure server.properties"
    ["properties_menu"]="Server Properties Configuration:"
    ["set_gamemode"]="Set Gamemode (survival, creative, adventure, spectator):"
    ["set_difficulty"]="Set Difficulty (peaceful, easy, normal, hard):"
    ["set_pvp"]="Enable PvP (true/false):"
    ["set_max_players"]="Set Max Players (number):"
    ["set_motd"]="Set MOTD (server message):"
    ["set_online_mode"]="Set Online Mode (true/false):"
    ["set_spawn_protection"]="Set Spawn Protection (number, 0 to disable):"
    ["set_allow_nether"]="Allow Nether (true/false):"
    ["set_enforce_whitelist"]="Enforce Whitelist (true/false):"
    ["set_level_type"]="Set Level Type (minecraft\\:normal, minecraft\\:flat, minecraft\\:large_biomes, minecraft\\:amplified, minecraft\\:single_biome_surface):"
    ["set_generate_structures"]="Generate Structures (true/false):"
    ["set_spawn_animals"]="Spawn Animals (true/false):"
    ["set_spawn_npcs"]="Spawn NPCs (true/false):"
    ["set_spawn_monsters"]="Spawn Monsters (true/false):"
    ["set_hardcore"]="Enable Hardcore Mode (true/false):"
    ["set_allow_flight"]="Allow Flight (true/false):"
    ["set_white_list"]="Enable Whitelist (true/false):"
    ["set_server_port"]="Set Server Port (number, default 25565):"
    ["invalid_gamemode"]="Invalid gamemode. Choose: survival, creative, adventure, spectator"
    ["invalid_difficulty"]="Invalid difficulty. Choose: peaceful, easy, normal, hard"
    ["invalid_pvp"]="Invalid PvP setting. Choose: true, false"
    ["invalid_max_players"]="Invalid max players. Enter a number."
    ["invalid_online_mode"]="Invalid online mode setting. Choose: true, false"
    ["invalid_spawn_protection"]="Invalid spawn protection. Enter a number or 0."
    ["invalid_allow_nether"]="Invalid allow nether setting. Choose: true, false"
    ["invalid_enforce_whitelist"]="Invalid enforce whitelist setting. Choose: true, false"
    ["invalid_level_type"]="Invalid level type. Choose: minecraft:normal, minecraft:flat, minecraft:large_biomes, minecraft:amplified, minecraft:single_biome_surface"
    ["invalid_generate_structures"]="Invalid generate structures setting. Choose: true, false"
    ["invalid_spawn_animals"]="Invalid spawn animals setting. Choose: true, false"
    ["invalid_spawn_npcs"]="Invalid spawn NPCs setting. Choose: true, false"
    ["invalid_spawn_monsters"]="Invalid spawn monsters setting. Choose: true, false"
    ["invalid_hardcore"]="Invalid hardcore mode setting. Choose: true, false"
    ["invalid_allow_flight"]="Invalid allow flight setting. Choose: true, false"
    ["invalid_white_list"]="Invalid whitelist setting. Choose: true, false"
    ["invalid_server_port"]="Invalid server port. Enter a number between 1 and 65535."
)

declare -A LANG_ZH=(
    ["select_language"]="選擇語言（1：英文，2：中文）："
    ["invalid_language"]="無效的語言選擇，請選擇1或2。"
    ["welcome"]="歡迎使用Minecraft伺服器管理器"
    ["select_option"]="選擇一個選項："
    ["deploy_server"]="部署新伺服器"
    ["manage_servers"]="管理現有伺服器"
    ["backup_restore"]="備份/還原"
    ["view_logs"]="查看伺服器日誌"
    ["exit"]="退出"
    ["select_version"]="選擇Minecraft版本："
    ["server_type"]="選擇伺服器類型（1：原版，2：Fabric，3：PaperMC，4：Spigot，5：Forge）："
    ["custom_jar"]="使用自訂JAR或ZIP檔案"
    ["enter_jar_path"]="輸入自訂JAR/ZIP檔案路徑："
    ["invalid_path"]="無效的檔案路徑，請重試。"
    ["install_deps"]="檢測到缺少依賴項，是否安裝？(y/n)"
    ["plugin_menu"]="插件/MOD管理："
    ["install_plugin"]="安裝插件/MOD"
    ["remove_plugin"]="移除插件/MOD"
    ["list_plugins"]="列出已安裝插件/MOD"
    ["plugin_repo"]="瀏覽插件倉庫"
    ["back"]="返回"
    ["enter_plugin_url"]="輸入插件/MOD下載URL："
    ["invalid_url"]="無效的URL，請重試。"
    ["console_cmd"]="輸入控制台指令（輸入'exit'退出）："
    ["backup_now"]="立即創建備份"
    ["restore_backup"]="從備份還原"
    ["schedule_backup"]="設定自動備份"
    ["select_backup"]="選擇要還原的備份："
    ["check_update"]="檢查伺服器更新"
    ["no_update"]="無可用更新。"
    ["update_available"]="有可用更新：%s，是否升級？(y/n)"
    ["invalid_input"]="無效輸入，請重試。"
    ["server_running"]="伺服器正在運行，請先停止。"
    ["select_server"]="選擇要管理的伺服器："
    ["start_server"]="啟動伺服器"
    ["stop_server"]="停止伺服器"
    ["restart_server"]="重啟伺服器"
    ["console"]="伺服器控制台"
    ["op_player"]="授予玩家OP權限"
    ["deop_player"]="移除玩家OP權限"
    ["kick_player"]="踢出玩家"
    ["ban_player"]="封禁玩家"
    ["enter_player"]="輸入玩家名稱："
    ["server_dir"]="輸入伺服器目錄名稱："
    ["invalid_dir"]="無效的目錄名稱，請重試。"
    ["backup_success"]="備份成功創建：%s"
    ["restore_success"]="還原完成：%s"
    ["backup_schedule_set"]="備份計劃已設定：%s"
    ["memory_config"]="輸入記憶體設定（例如，2G 4G 表示最小/最大）："
    ["invalid_memory"]="無效的記憶體設定，請使用類似 '2G 4G' 的格式。"
    ["status"]="伺服器狀態"
    ["players_online"]="在線玩家：%s"
    ["view_logs"]="查看日誌"
    ["startup_error"]="伺服器啟動失敗，請檢查日誌：%s"
    ["configure_properties"]="配置server.properties"
    ["properties_menu"]="伺服器屬性配置："
    ["set_gamemode"]="設定遊戲模式（survival, creative, adventure, spectator）："
    ["set_difficulty"]="設定難度（peaceful, easy, normal, hard）："
    ["set_pvp"]="啟用PVP（true/false）："
    ["set_max_players"]="設定最大玩家數（數字）："
    ["set_motd"]="設定MOTD（伺服器訊息）："
    ["set_online_mode"]="設定線上模式（true/false）："
    ["set_spawn_protection"]="設定出生點保護（數字，0表示禁用）："
    ["set_allow_nether"]="允許下界（true/false）："
    ["set_enforce_whitelist"]="強制白名單（true/false）："
    ["set_level_type"]="設定世界類型（minecraft\\:normal, minecraft\\:flat, minecraft\\:large_biomes, minecraft\\:amplified, minecraft\\:single_biome_surface）："
    ["set_generate_structures"]="生成結構（true/false）："
    ["set_spawn_animals"]="生成動物（true/false）："
    ["set_spawn_npcs"]="生成NPC（true/false）："
    ["set_spawn_monsters"]="生成怪物（true/false）："
    ["set_hardcore"]="啟用極限模式（true/false）："
    ["set_allow_flight"]="允許飛行（true/false）："
    ["set_white_list"]="啟用白名單（true/false）："
    ["set_server_port"]="設定伺服器端口（數字，預設25565）："
    ["invalid_gamemode"]="無效遊戲模式，選擇：survival, creative, adventure, spectator"
    ["invalid_difficulty"]="無效難度，選擇：peaceful, easy, normal, hard"
    ["invalid_pvp"]="無效PVP設定，選擇：true, false"
    ["invalid_max_players"]="無效最大玩家數，請輸入數字。"
    ["invalid_online_mode"]="無效線上模式設定，選擇：true, false"
    ["invalid_spawn_protection"]="無效出生點保護設定，請輸入數字或0。"
    ["invalid_allow_nether"]="無效下界設定，選擇：true, false"
    ["invalid_enforce_whitelist"]="無效白名單設定，選擇：true, false"
    ["invalid_level_type"]="無效世界類型，選擇：minecraft:normal, minecraft:flat, minecraft:large_biomes, minecraft:amplified, minecraft:single_biome_surface"
    ["invalid_generate_structures"]="無效生成結構設定，選擇：true, false"
    ["invalid_spawn_animals"]="無效生成動物設定，選擇：true, false"
    ["invalid_spawn_npcs"]="無效生成NPC設定，選擇：true, false"
    ["invalid_spawn_monsters"]="無效生成怪物設定，選擇：true, false"
    ["invalid_hardcore"]="無效極限模式設定，選擇：true, false"
    ["invalid_allow_flight"]="無效允許飛行設定，選擇：true, false"
    ["invalid_white_list"]="無效白名單設定，選擇：true, false"
    ["invalid_server_port"]="無效伺服器端口，請輸入1到65535之間的數字。"
)

# Language selection
select_language() {
    echo "${LANG_EN[select_language]}" # Use English as default for language prompt
    echo "1. English"
    echo "2. 中文 (Chinese)"
    read -r lang_choice
    case $lang_choice in
        1)
            declare -A TEXT=("${LANG_EN[@]}")
            ;;
        2)
            declare -A TEXT=("${LANG_ZH[@]}")
            ;;
        *)
            echo "${LANG_EN[invalid_language]}" # Use English for error message
            select_language
            return
            ;;
    esac
}

# Configuration file
CONFIG_FILE="/etc/minecraft_manager.conf"
DEFAULT_CONFIG="
BASE_DIR=/opt/minecraft
BACKUP_DIR=/opt/minecraft_backups
JAVA_VERSION=openjdk-21-jre-headless
VERSIONS_URL=https://launchermeta.mojang.com/mc/game/version_manifest.json
PAPER_API_URL=https://api.papermc.io/v2/projects/paper
SPIGOT_BUILD_TOOLS_URL=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
FORGE_INSTALLER_URL=https://files.minecraftforge.net/net/minecraftforge/forge
PLUGINS_DIR=mods
LOG_FILE=/var/log/minecraft_manager.log
BACKUP_SCHEDULE=0 2 * * * # Daily at 2 AM
PLUGIN_REPO=https://api.spiget.org/v2/resources
FABRIC_API_URL=https://api.github.com/repos/FabricMC/fabric/releases/latest
"

# Load or create configuration
if [ ! -f "$CONFIG_FILE" ]; then
    echo "$DEFAULT_CONFIG" | sudo tee "$CONFIG_FILE" >/dev/null
fi
source "$CONFIG_FILE"

# Ensure base directories exist
mkdir -p "$BASE_DIR" "$BACKUP_DIR"
touch "$LOG_FILE"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check dependencies
check_dependencies() {
    local deps=("java" "curl" "jq" "unzip" "screen" "cron" "git")
    local missing=()
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    # Check Java version specifically
    if ! java -version 2>&1 | grep -q "21\."; then
        missing+=("$JAVA_VERSION")
    fi
    if [ ${#missing[@]} -gt 0 ]; then
        echo "${TEXT[install_deps]}"
        read -r install
        if [[ "$install" =~ ^[Yy]$ ]]; then
            sudo apt update
            for dep in "${missing[@]}"; do
                sudo apt install -y "$dep"
                log "Installed dependency: $dep"
            done
        else
            exit 1
        fi
    fi
}

# Get available Minecraft versions
get_versions() {
    curl -s "$VERSIONS_URL" | jq -r '.versions[].id' | head -n 10 # Limit to recent versions
}

# Download Vanilla server JAR
download_vanilla() {
    local version=$1
    local dir=$2
    local manifest=$(curl -s "$VERSIONS_URL")
    local version_url=$(echo "$manifest" | jq -r ".versions[] | select(.id==\"$version\") | .url")
    local download_url=$(curl -s "$version_url" | jq -r '.downloads.server.url')
    curl -s -o "$dir/server.jar" "$download_url"
    echo "$version" > "$dir/version.txt"
    echo "vanilla" > "$dir/server_type.txt"
    log "Downloaded Vanilla version $version to $dir"
}

# Download Fabric server
download_fabric() {
    local version=$1
    local dir=$2
    local fabric_version=$(curl -s https://meta.fabricmc.net/v2/versions/loader/$version | jq -r '.[0].loader.version')
    local fabric_url="https://meta.fabricmc.net/v2/versions/loader/$version/$fabric_version/server/jar"
    curl -s -o "$dir/server.jar" "$fabric_url"
    # Install Fabric API
    local fabric_api_url=$(curl -s "$FABRIC_API_URL" | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')
    curl -s -o "$dir/$PLUGINS_DIR/fabric-api.jar" "$fabric_api_url"
    echo "$version" > "$dir/version.txt"
    echo "fabric" > "$dir/server_type.txt"
    log "Downloaded Fabric $version and Fabric API to $dir"
}

# Download PaperMC server JAR
download_papermc() {
    local version=$1
    local dir=$2
    local build=$(curl -s "$PAPER_API_URL/versions/$version" | jq -r '.builds[-1]')
    local paper_url="$PAPER_API_URL/versions/$version/builds/$build/downloads/paper-$version-$build.jar"
    curl -s -o "$dir/server.jar" "$paper_url"
    echo "$version" > "$dir/version.txt"
    echo "papermc" > "$dir/server_type.txt"
    log "Downloaded PaperMC $version (build $build) to $dir"
}

# Download Spigot server JAR
download_spigot() {
    local version=$1
    local dir=$2
    mkdir -p "$dir/buildtools"
    curl -s -o "$dir/buildtools/BuildTools.jar" "$SPIGOT_BUILD_TOOLS_URL"
    cd "$dir/buildtools" || exit 1
    java -jar BuildTools.jar --rev "$version" --output-dir "../"
    mv "$dir/spigot-$version.jar" "$dir/server.jar"
    rm -rf "$dir/buildtools"
    echo "$version" > "$dir/version.txt"
    echo "spigot" > "$dir/server_type.txt"
    log "Downloaded Spigot $version to $dir"
}

# Download Forge server JAR
download_forge() {
    local version=$1
    local dir=$2
    local forge_version=$(curl -s "$FORGE_INSTALLER_URL/index_$version.html" | grep -oP 'forge-\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    local forge_url="$FORGE_INSTALLER_URL/$version-$forge_version/forge-$version-$forge_version-installer.jar"
    curl -s -o "$dir/forge-installer.jar" "$forge_url"
    cd "$dir" || exit 1
    java -jar forge-installer.jar --installServer
    rm forge-installer.jar
    mv "forge-$version-$forge_version.jar" server.jar
    echo "$version" > "$dir/version.txt"
    echo "forge" > "$dir/server_type.txt"
    log "Downloaded Forge $version-$forge_version to $dir"
}

# Configure server.properties
configure_properties() {
    local server_dir=$1
    local properties_file="$server_dir/server.properties"
    if [ ! -f "$properties_file" ]; then
        echo "#Minecraft server properties" > "$properties_file"
    fi
    while true; do
        echo "${TEXT[properties_menu]}"
        echo "1. ${TEXT[set_gamemode]}"
        echo "2. ${TEXT[set_difficulty]}"
        echo "3. ${TEXT[set_pvp]}"
        echo "4. ${TEXT[set_max_players]}"
        echo "5. ${TEXT[set_motd]}"
        echo "6. ${TEXT[set_online_mode]}"
        echo "7. ${TEXT[set_spawn_protection]}"
        echo "8. ${TEXT[set_allow_nether]}"
        echo "9. ${TEXT[set_enforce_whitelist]}"
        echo "10. ${TEXT[set_level_type]}"
        echo "11. ${TEXT[set_generate_structures]}"
        echo "12. ${TEXT[set_spawn_animals]}"
        echo "13. ${TEXT[set_spawn_npcs]}"
        echo "14. ${TEXT[set_spawn_monsters]}"
        echo "15. ${TEXT[set_hardcore]}"
        echo "16. ${TEXT[set_allow_flight]}"
        echo "17. ${TEXT[set_white_list]}"
        echo "18. ${TEXT[set_server_port]}"
        echo "19. ${TEXT[back]}"
        read -r choice
        case $choice in
            1)
                echo "${TEXT[set_gamemode]}"
                read -r gamemode
                if [[ ! "$gamemode" =~ ^(survival|creative|adventure|spectator)$ ]]; then
                    echo "${TEXT[invalid_gamemode]}"
                    continue
                fi
                sed -i "s/gamemode=.*/gamemode=$gamemode/" "$properties_file" || echo "gamemode=$gamemode" >> "$properties_file"
                log "Set gamemode to $gamemode in $properties_file"
                ;;
            2)
                echo "${TEXT[set_difficulty]}"
                read -r difficulty
                if [[ ! "$difficulty" =~ ^(peaceful|easy|normal|hard)$ ]]; then
                    echo "${TEXT[invalid_difficulty]}"
                    continue
                fi
                sed -i "s/difficulty=.*/difficulty=$difficulty/" "$properties_file" || echo "difficulty=$difficulty" >> "$properties_file"
                log "Set difficulty to $difficulty in $properties_file"
                ;;
            3)
                echo "${TEXT[set_pvp]}"
                read -r pvp
                if [[ ! "$pvp" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_pvp]}"
                    continue
                fi
                sed -i "s/pvp=.*/pvp=$pvp/" "$properties_file" || echo "pvp=$pvp" >> "$properties_file"
                log "Set PvP to $pvp in $properties_file"
                ;;
            4)
                echo "${TEXT[set_max_players]}"
                read -r max_players
                if [[ ! "$max_players" =~ ^[0-9]+$ ]]; then
                    echo "${TEXT[invalid_max_players]}"
                    continue
                fi
                sed -i "s/max-players=.*/max-players=$max_players/" "$properties_file" || echo "max-players=$max_players" >> "$properties_file"
                log "Set max players to $max_players in $properties_file"
                ;;
            5)
                echo "${TEXT[set_motd]}"
                read -r motd
                sed -i "s/motd=.*/motd=$motd/" "$properties_file" || echo "motd=$motd" >> "$properties_file"
                log "Set MOTD to $motd in $properties_file"
                ;;
            6)
                echo "${TEXT[set_online_mode]}"
                read -r online_mode
                if [[ ! "$online_mode" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_online_mode]}"
                    continue
                fi
                sed -i "s/online-mode=.*/online-mode=$online_mode/" "$properties_file" || echo "online-mode=$online_mode" >> "$properties_file"
                log "Set online mode to $online_mode in $properties_file"
                ;;
            7)
                echo "${TEXT[set_spawn_protection]}"
                read -r spawn_protection
                if [[ ! "$spawn_protection" =~ ^[0-9]+$ ]]; then
                    echo "${TEXT[invalid_spawn_protection]}"
                    continue
                fi
                sed -i "s/spawn-protection=.*/spawn-protection=$spawn_protection/" "$properties_file" || echo "spawn-protection=$spawn_protection" >> "$properties_file"
                log "Set spawn protection to $spawn_protection in $properties_file"
                ;;
            8)
                echo "${TEXT[set_allow_nether]}"
                read -r allow_nether
                if [[ ! "$allow_nether" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_allow_nether]}"
                    continue
                fi
                sed -i "s/allow-nether=.*/allow-nether=$allow_nether/" "$properties_file" || echo "allow-nether=$allow_nether" >> "$properties_file"
                log "Set allow nether to $allow_nether in $properties_file"
                ;;
            9)
                echo "${TEXT[set_enforce_whitelist]}"
                read -r enforce_whitelist
                if [[ ! "$enforce_whitelist" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_enforce_whitelist]}"
                    continue
                fi
                sed -i "s/enforce-whitelist=.*/enforce-whitelist=$enforce_whitelist/" "$properties_file" || echo "enforce-whitelist=$enforce_whitelist" >> "$properties_file"
                log "Set enforce whitelist to $enforce_whitelist in $properties_file"
                ;;
            10)
                echo "${TEXT[set_level_type]}"
                read -r level_type
                if [[ ! "$level_type" =~ ^(minecraft\\:normal|minecraft\\:flat|minecraft\\:large_biomes|minecraft\\:amplified|minecraft\\:single_biome_surface)$ ]]; then
                    echo "${TEXT[invalid_level_type]}"
                    continue
                fi
                sed -i "s/level-type=.*/level-type=$level_type/" "$properties_file" || echo "level-type=$level_type" >> "$properties_file"
                log "Set level type to $level_type in $properties_file"
                ;;
            11)
                echo "${TEXT[set_generate_structures]}"
                read -r generate_structures
                if [[ ! "$generate_structures" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_generate_structures]}"
                    continue
                fi
                sed -i "s/generate-structures=.*/generate-structures=$generate_structures/" "$properties_file" || echo "generate-structures=$generate_structures" >> "$properties_file"
                log "Set generate structures to $generate_structures in $properties_file"
                ;;
            12)
                echo "${TEXT[set_spawn_animals]}"
                read -r spawn_animals
                if [[ ! "$spawn_animals" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_spawn_animals]}"
                    continue
                fi
                sed -i "s/spawn-animals=.*/spawn-animals=$spawn_animals/" "$properties_file" || echo "spawn-animals=$spawn_animals" >> "$properties_file"
                log "Set spawn animals to $spawn_animals in $properties_file"
                ;;
            13)
                echo "${TEXT[set_spawn_npcs]}"
                read -r spawn_npcs
                if [[ ! "$spawn_npcs" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_spawn_npcs]}"
                    continue
                fi
                sed -i "s/spawn-npcs=.*/spawn-npcs=$spawn_npcs/" "$properties_file" || echo "spawn-npcs=$spawn_npcs" >> "$properties_file"
                log "Set spawn NPCs to $spawn_npcs in $properties_file"
                ;;
            14)
                echo "${TEXT[set_spawn_monsters]}"
                read -r spawn_monsters
                if [[ ! "$spawn_monsters" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_spawn_monsters]}"
                    continue
                fi
                sed -i "s/spawn-monsters=.*/spawn-monsters=$spawn_monsters/" "$properties_file" || echo "spawn-monsters=$spawn_monsters" >> "$properties_file"
                log "Set spawn monsters to $spawn_monsters in $properties_file"
                ;;
            15)
                echo "${TEXT[set_hardcore]}"
                read -r hardcore
                if [[ ! "$hardcore" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_hardcore]}"
                    continue
                fi
                sed -i "s/hardcore=.*/hardcore=$hardcore/" "$properties_file" || echo "hardcore=$hardcore" >> "$properties_file"
                log "Set hardcore mode to $hardcore in $properties_file"
                ;;
            16)
                echo "${TEXT[set_allow_flight]}"
                read -r allow_flight
                if [[ ! "$allow_flight" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_allow_flight]}"
                    continue
                fi
                sed -i "s/allow-flight=.*/allow-flight=$allow_flight/" "$properties_file" || echo "allow-flight=$allow_flight" >> "$properties_file"
                log "Set allow flight to $allow_flight in $properties_file"
                ;;
            17)
                echo "${TEXT[set_white_list]}"
                read -r white_list
                if [[ ! "$white_list" =~ ^(true|false)$ ]]; then
                    echo "${TEXT[invalid_white_list]}"
                    continue
                fi
                sed -i "s/white-list=.*/white-list=$white_list/" "$properties_file" || echo "white-list=$white_list" >> "$properties_file"
                log "Set whitelist to $white_list in $properties_file"
                ;;
            18)
                echo "${TEXT[set_server_port]}"
                read -r server_port
                if [[ ! "$server_port" =~ ^[0-9]+$ ]] || [ "$server_port" -lt 1 ] || [ "$server_port" -gt 65535 ]; then
                    echo "${TEXT[invalid_server_port]}"
                    continue
                fi
                sed -i "s/server-port=.*/server-port=$server_port/" "$properties_file" || echo "server-port=$server_port" >> "$properties_file"
                log "Set server port to $server_port in $properties_file"
                ;;
            19)
                break
                ;;
            *)
                echo "${TEXT[invalid_input]}"
                ;;
        esac
    done
}

# Deploy new server
deploy_server() {
    echo "${TEXT[server_type]}"
    read -r server_type
    if [[ ! "$server_type" =~ ^[1-5]$ ]]; then
        echo "${TEXT[invalid_input]}"
        deploy_server
        return
    fi

    echo "${TEXT[select_version]}"
    versions=($(get_versions))
    for i in "${!versions[@]}"; do
        echo "$((i+1)). ${versions[i]}"
    done
    echo "$(( ${#versions[@]} + 1 )). ${TEXT[custom_jar]}"
    read -r choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt $(( ${#versions[@]} + 1 )) ]; then
        echo "${TEXT[invalid_input]}"
        deploy_server
        return
    fi

    echo "${TEXT[server_dir]}"
    read -r dir_name
    if [[ ! "$dir_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "${TEXT[invalid_dir]}"
        deploy_server
        return
    fi

    echo "${TEXT[memory_config]}"
    read -r min_mem max_mem
    if [[ ! "$min_mem" =~ ^[0-9]+[MG]$ || ! "$max_mem" =~ ^[0-9]+[MG]$ ]]; then
        echo "${TEXT[invalid_memory]}"
        deploy_server
        return
    fi

    server_dir="$BASE_DIR/$dir_name"
    mkdir -p "$server_dir/$PLUGINS_DIR"
    cd "$server_dir" || exit 1

    if [ "$choice" -eq $(( ${#versions[@]} + 1 )) ]; then
        echo "${TEXT[enter_jar_path]}"
        read -r jar_path
        if [ ! -f "$jar_path" ]; then
            echo "${TEXT[invalid_path]}"
            deploy_server
            return
        fi
        if [[ "$jar_path" == *.zip ]]; then
            unzip "$jar_path" -d "$server_dir"
        else
            cp "$jar_path" "$server_dir/server.jar"
        fi
        echo "custom" > "$server_dir/server_type.txt"
    else
        version=${versions[$((choice-1))]}
        case $server_type in
            1)
                download_vanilla "$version" "$server_dir"
                ;;
            2)
                download_fabric "$version" "$server_dir"
                ;;
            3)
                download_papermc "$version" "$server_dir"
                ;;
            4)
                download_spigot "$version" "$server_dir"
                ;;
            5)
                download_forge "$version" "$server_dir"
                ;;
        esac
    fi

    # Auto-accept EULA
    echo "eula=true" > eula.txt
    log "EULA auto-accepted for $server_dir"

    # Initialize server.properties with defaults
    cat > server.properties <<EOF
gamemode=survival
difficulty=easy
pvp=true
max-players=20
motd=A Minecraft Server
online-mode=true
spawn-protection=16
allow-nether=true
enforce-whitelist=false
level-type=minecraft\\:normal
generate-structures=true
spawn-animals=true
spawn-npcs=true
spawn-monsters=true
hardcore=false
allow-flight=false
white-list=false
server-port=25565
EOF
    log "Initialized server.properties for $server_dir"

    # Create start script with memory settings
    cat > start.sh <<EOF
#!/bin/bash
java -Xms$min_mem -Xmx$max_mem -jar server.jar nogui 2>&1 | tee -a logs/startup.log
EOF
    chmod +x start.sh
    log "Deployed new server in $server_dir with memory $min_mem/$max_mem"
}

# Plugin/MOD repository browser
browse_plugins() {
    local server_dir=$1
    echo "${TEXT[plugin_repo]}..."
    plugins=$(curl -s "$PLUGIN_REPO?size=10" | jq -r '.[] | "\(.id) - \(.name)"')
    select plugin in $plugins "${TEXT[back]}"; do
        if [ "$plugin" == "${TEXT[back]}" ]; then
            break
        fi
        plugin_id=$(echo "$plugin" | cut -d' ' -f1)
        plugin_url=$(curl -s "$PLUGIN_REPO/$plugin_id/download" -w "%{redirect_url}")
        if [ -n "$plugin_url" ]; then
            curl -s -o "$server_dir/$PLUGINS_DIR/$(basename "$plugin_url")" "$plugin_url"
            log "Installed plugin/MOD $plugin to $server_dir/$PLUGINS_DIR"
        else
            echo "${TEXT[invalid_url]}"
        fi
    done
}

# Plugin/MOD management
manage_plugins() {
    local server_dir=$1
    while true; do
        echo "${TEXT[plugin_menu]}"
        echo "1. ${TEXT[install_plugin]}"
        echo "2. ${TEXT[remove_plugin]}"
        echo "3. ${TEXT[list_plugins]}"
        echo "4. ${TEXT[plugin_repo]}"
        echo "5. ${TEXT[back]}"
        read -r choice
        case $choice in
            1)
                echo "${TEXT[enter_plugin_url]}"
                read -r url
                if ! curl -s -I "$url" | grep -q "200"; then
                    echo "${TEXT[invalid_url]}"
                    continue
                fi
                curl -s -o "$server_dir/$PLUGINS_DIR/$(basename "$url")" "$url"
                log "Installed plugin/MOD $(basename "$url") to $server_dir/$PLUGINS_DIR"
                ;;
            2)
                select plugin in "$server_dir/$PLUGINS_DIR"/*.jar; do
                    if [ -f "$plugin" ]; then
                        rm "$plugin"
                        log "Removed plugin/MOD $plugin"
                        break
                    fi
                    echo "${TEXT[invalid_input]}"
                done
                ;;
            3)
                ls -1 "$server_dir/$PLUGINS_DIR"/*.jar
                ;;
            4)
                browse_plugins "$server_dir"
                ;;
            5)
                break
                ;;
            *)
                echo "${TEXT[invalid_input]}"
                ;;
        esac
    done
}

# Server console
server_console() {
    local server_dir=$1
    screen -S "mc_$(basename "$server_dir")" -X stuff "$2\n"
    log "Sent command to $server_dir: $2"
}

# Get server status and online players
server_status() {
    local server_dir=$1
    if screen -list | grep -q "mc_$(basename "$server_dir")"; then
        echo "${TEXT[status]}: Running"
        local players=$(grep -oP "There are \K[0-9]+/[0-9]+" "$server_dir/logs/latest.log" | tail -n 1)
        printf "${TEXT[players_online]}" "${players:-0}"
    else
        echo "${TEXT[status]}: Stopped"
    fi
}

# Check for startup errors
check_startup_errors() {
    local server_dir=$1
    local log_file="$server_dir/logs/startup.log"
    if [ -f "$log_file" ] && grep -qE "Exception|Error|Failed to load|Ambiguous plugin name|Unknown/missing dependency" "$log_file"; then
        printf "${TEXT[startup_error]}" "$log_file"
        log "Startup error detected in $server_dir: $(grep -E 'Exception|Error|Failed to load|Ambiguous plugin name|Unknown/missing dependency' "$log_file" | tail -n 1)"
        return 1
    fi
    return 0
}

# View server logs
view_logs() {
    local server_dir=$1
    select log in "$server_dir/logs"/*.log; do
        if [ -f "$log" ]; then
            less "$log"
            break
        fi
        echo "${TEXT[invalid_input]}"
        ;;
    done
}

# Backup function
create_backup() {
    local server_dir=$1
    local backup_name="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    tar -czf "$BACKUP_DIR/$backup_name" -C "$server_dir" .
    echo "${TEXT[backup_success]}" "$backup_name"
    log "Created backup for $server_dir: $backup_name"
}

# Restore function
restore_backup() {
    local server_dir=$1
    echo "${TEXT[select_backup]}"
    select backup in "$BACKUP_DIR"/*.tar.gz; do
        if [ -f "$backup" ]; then
            if screen -list | grep -q "mc_$(basename "$server_dir")"; then
                echo "${TEXT[server_running]}"
                break
            fi
            rm -rf "$server_dir"/*
            tar -xzf "$backup" -C "$server_dir"
            echo "${TEXT[restore_success]}" "$(basename "$backup")"
            log "Restored backup for $server_dir: $(basename "$backup")"
            break
        fi
        echo "${TEXT[invalid_input]}"
    done
}

# Schedule automated backups
schedule_backup() {
    local server_dir=$1
    echo "${TEXT[schedule_backup]} (cron format, e.g., '0 2 * * *' for daily at 2 AM):"
    read -r schedule
    if ! echo "$schedule" | grep -qE "^[0-9* /,-]+ [0-9* /,-]+ [0-9* /,-]+ [0-9* /,-]+ [0-9* /,-]+$"; then
        echo "${TEXT[invalid_input]}"
        schedule_backup "$server_dir"
        return
    fi
    (crontab -l 2>/dev/null; echo "$schedule $0 backup \"$server_dir\"") | crontab -
    echo "${TEXT[backup_schedule_set]}" "$schedule"
    log "Scheduled backup for $server_dir: $schedule"
}

# Check for updates
check_update() {
    local server_dir=$1
    local current_version=$(cat "$server_dir/version.txt" 2>/dev/null || echo "unknown")
    local server_type=$(cat "$server_dir/server_type.txt" 2>/dev/null || echo "vanilla")
    local latest_version
    case $server_type in
        fabric)
            latest_version=$(curl -s https://meta.fabricmc.net/v2/versions/game | jq -r '.[0].version')
            ;;
        papermc)
            latest_version=$(curl -s "$PAPER_API_URL" | jq -r '.versions[-1]')
            ;;
        spigot)
            latest_version=$(curl -s "$VERSIONS_URL" | jq -r '.latest.release')
            ;;
        forge)
            latest_version=$(curl -s "$VERSIONS_URL" | jq -r '.latest.release')
            ;;
        *)
            latest_version=$(curl -s "$VERSIONS_URL" | jq -r '.latest.release')
            ;;
    esac
    if [ "$current_version" != "$latest_version" ]; then
        printf "${TEXT[update_available]}" "$latest_version"
        read -r upgrade
        if [[ "$upgrade" =~ ^[Yy]$ ]]; then
            mv "$server_dir/server.jar" "$server_dir/server.jar.bak"
            case $server_type in
                fabric)
                    download_fabric "$latest_version" "$server_dir"
                    ;;
                papermc)
                    download_papermc "$latest_version" "$server_dir"
                    ;;
                spigot)
                    download_spigot "$latest_version" "$server_dir"
                    ;;
                forge)
                    download_forge "$latest_version" "$server_dir"
                    ;;
                *)
                    download_vanilla "$latest_version" "$server_dir"
                    ;;
            esac
            log "Upgraded $server_dir to version $latest_version"
        fi
    else
        echo "${TEXT[no_update]}"
    fi
}

# Manage existing server
manage_server() {
    local server_dir=$1
    if screen -list | grep -q "mc_$(basename "$server_dir")"; then
        running=true
    else
        running=false
    fi
    while true; do
        server_status "$server_dir"
        echo "${TEXT[select_option]}"
        echo "1. ${TEXT[start_server]}"
        echo "2. ${TEXT[stop_server]}"
        echo "3. ${TEXT[restart_server]}"
        echo "4. ${TEXT[console]}"
        echo "5. ${TEXT[op_player]}"
        echo "6. ${TEXT[deop_player]}"
        echo "7. ${TEXT[kick_player]}"
        echo "8. ${TEXT[ban_player]}"
        echo "9. ${TEXT[plugin_menu]}"
        echo "10. ${TEXT[check_update]}"
        echo "11. ${TEXT[view_logs]}"
        echo "12. ${TEXT[configure_properties]}"
        echo "13. ${TEXT[back]}"
        read -r choice
        case $choice in
            1)
                if $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                cd "$server_dir" || exit 1
                screen -dmS "mc_$(basename "$server_dir")" ./start.sh
                sleep 10 # Wait for potential errors
                if ! check_startup_errors "$server_dir"; then
                    running=true
                    log "Started server in $server_dir"
                else
                    screen -S "mc_$(basename "$server_dir")" -X quit
                fi
                ;;
            2)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                server_console "$server_dir" "stop"
                running=false
                log "Stopped server in $server_dir"
                ;;
            3)
                if $running; then
                    server_console "$server_dir" "stop"
                    sleep 5
                fi
                cd "$server_dir" || exit 1
                screen -dmS "mc_$(basename "$server_dir")" ./start.sh
                sleep 10
                if ! check_startup_errors "$server_dir"; then
                    running=true
                    log "Restarted server in $server_dir"
                else
                    screen -S "mc_$(basename "$server_dir")" -X quit
                fi
                ;;
            4)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                echo "${TEXT[console_cmd]}"
                while read -r cmd; do
                    if [ "$cmd" == "exit" ]; then
                        break
                    fi
                    server_console "$server_dir" "$cmd"
                done
                ;;
            5)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                echo "${TEXT[enter_player]}"
                read -r player
                server_console "$server_dir" "op $player"
                log "Granted OP to $player in $server_dir"
                ;;
            6)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                echo "${TEXT[enter_player]}"
                read -r player
                server_console "$server_dir" "deop $player"
                log "Removed OP from $player in $server_dir"
                ;;
            7)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                echo "${TEXT[enter_player]}"
                read -r player
                server_console "$server_dir" "kick $player"
                log "Kicked $player from $server_dir"
                ;;
            8)
                if ! $running; then
                    echo "${TEXT[server_running]}"
                    continue
                fi
                echo "${TEXT[enter_player]}"
                read -r player
                server_console "$server_dir" "ban $player"
                log "Banned $player from $server_dir"
                ;;
            9)
                manage_plugins "$server_dir"
                ;;
            10)
                check_update "$server_dir"
                ;;
            11)
                view_logs "$server_dir"
                ;;
            12)
                configure_properties "$server_dir"
                ;;
            13)
                break
                ;;
            *)
                echo "${TEXT[invalid_input]}"
                ;;
        esac
    done
}

# Main menu
main_menu() {
    check_dependencies
    while true; do
        echo "${TEXT[welcome]}"
        echo "${TEXT[select_option]}"
        echo "1. ${TEXT[deploy_server]}"
        echo "2. ${TEXT[manage_servers]}"
        echo "3. ${TEXT[backup_restore]}"
        echo "4. ${TEXT[view_logs]}"
        echo "5. ${TEXT[exit]}"
        read -r choice
        case $choice in
            1)
                deploy_server
                ;;
            2)
                echo "${TEXT[select_server]}"
                select server in "$BASE_DIR"/*/ ; do
                    if [ -d "$server" ]; then
                        manage_server "$server"
                        break
                    fi
                    echo "${TEXT[invalid_input]}"
                done
                ;;
            3)
                echo "${TEXT[select_option]}"
                echo "1. ${TEXT[backup_now]}"
                echo "2. ${TEXT[restore_backup]}"
                echo "3. ${TEXT[schedule_backup]}"
                echo "4. ${TEXT[back]}"
                read -r subchoice
                case $subchoice in
                    1)
                        echo "${TEXT[select_server]}"
                        select server in "$BASE_DIR"/*/ ; do
                            if [ -d "$server" ]; then
                                create_backup "$server"
                                break
                            fi
                            echo "${TEXT[invalid_input]}"
                        done
                        ;;
                    2)
                        echo "${TEXT[select_server]}"
                        select server in "$BASE_DIR"/*/ ; do
                            if [ -d "$server" ]; then
                                restore_backup "$server"
                                break
                            fi
                            echo "${TEXT[invalid_input]}"
                        done
                        ;;
                    3)
                        echo "${TEXT[select_server]}"
                        select server in "$BASE_DIR"/*/ ; do
                            if [ -d "$server" ]; then
                                schedule_backup "$server"
                                break
                            fi
                            echo "${TEXT[invalid_input]}"
                        done
                        ;;
                    4)
                        ;;
                    *)
                        echo "${TEXT[invalid_input]}"
                        ;;
                esac
                ;;
            4)
                echo "${TEXT[select_server]}"
                select server in "$BASE_DIR"/*/ ; do
                    if [ -d "$server" ]; then
                        view_logs "$server"
                        break
                    fi
                    echo "${TEXT[invalid_input]}"
                done
                ;;
            5)
                exit 0
                ;;
            *)
                echo "${TEXT[invalid_input]}"
                ;;
        esac
    done
}

# Handle direct backup command (for cron)
if [ "$1" == "backup" ] && [ -n "$2" ]; then
    select_language # Ensure language is set for cron jobs
    create_backup "$2"
    exit 0
fi

# Start the script with language selection
select_language
main_menu