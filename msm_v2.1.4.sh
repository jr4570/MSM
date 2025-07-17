#!/bin/bash

#=================================================================================
# Minecraft Server Manager Script
# Author: AI Assistant
# Version: 2.1.4 - Critical syntax fix in attach_to_console. Reformatted all single-line functions for readability and stability.
#=================================================================================

# --- Script Configuration ---
SERVERS_BASE_DIR="$HOME/mc_servers"
PAPER_API="https://api.papermc.io/v2/projects/paper"
FABRIC_API="https://meta.fabricmc.net/v2/versions"
MODRINTH_API="https://api.modrinth.com/v2"
EULA_URL="https://aka.ms/MinecraftEULA"

# --- Colors for output ---
COLOR_RESET='\033[0m'
COLOR_INFO='\033[0;34m'
COLOR_SUCCESS='\033[0;32m'
COLOR_WARNING='\033[0;33m'
COLOR_ERROR='\033[0;31m'
COLOR_TITLE='\033[1;36m'

# --- Language Strings (Unchanged) ---
declare -A TEXTS

setup_language() {
    lang_choice=$1
    if [[ "$lang_choice" == "1" ]]; then
        # Traditional Chinese (繁體中文)
        TEXTS=(
            [ask_language]="請選擇語言 (Please select language):"
            [main_menu_title]="Minecraft 伺服器管理器"
            [select_option]="請輸入您的選擇"
            [invalid_option]="無效的選項，請重新輸入。"
            [press_enter_to_continue]="按 Enter 鍵繼續..."
            [menu_deploy]="部署新伺服器"
            [menu_manage]="管理現有伺服器"
            [menu_exit]="退出"
            [manage_menu_title]="管理伺服器"
            [manage_start]="啟動伺服器"
            [manage_stop]="停止伺服器"
            [manage_console]="進入伺服器控制台"
            [manage_players]="玩家管理"
            [manage_plugins]="插件/模組 (Mod) 管理"
            [manage_backup]="備份伺服器"
            [manage_restore]="從備份還原"
            [manage_configure]="設定 server.properties"
            [manage_update]="檢查伺服器核心更新"
            [manage_delete]="刪除伺服器"
            [menu_back]="返回主菜單"
            [no_servers]="找不到任何伺服器。請先部署一個。"
            [select_server]="請選擇要管理的伺服器:"
            [deploy_server_name]="請為您的新伺服器命名 (例如: survival_world):"
            [server_name_exists]="錯誤：名為 '%s' 的伺服器已存在。"
            [select_server_type]="請選擇伺服器類型:"
            [type_paper]="推薦, 高性能, 支援插件"
            [type_fabric]="推薦, 支援模組 (Mod)"
            [type_spigot]="老牌, 支援插件"
            [type_vanilla]="官方原版"
            [type_custom_jar]="使用自訂的 .jar 檔案"
            [custom_jar_path]="請輸入自訂 .jar 檔案的完整路徑:"
            [file_not_found]="錯誤: 找不到檔案 '%s'"
            [select_mc_version]="請選擇 Minecraft 版本:"
            [fetching_versions]="正在獲取版本列表..."
            [downloading_server]="正在下載伺服器檔案... 這可能需要一些時間。"
            [eula_prompt]="繼續之前，您必須同意 Mojang 的 Minecraft 終端使用者授權合約 (EULA)。"
            [eula_link_info]="請在此處閱讀 EULA: %s\n"
            [eula_agree_prompt]="您是否同意 EULA？ (請輸入 yes 或 no):"
            [eula_denied]="您必須同意 EULA 才能建立伺服器。部署已取消。"
            [eula_accepted]="感謝您的同意。EULA 已記錄。"
            [deploy_complete]="伺服器 '%s' 部署完成!"
            [deploy_aborted]="部署已中止。"
            [fabric_api_prompt]="Fabric 伺服器需要 Fabric API。是否為您自動下載?"
            [downloading_fabric_api]="正在下載 Fabric API..."
            [server_not_running]="伺服器 '%s' 未在運行。"
            [server_already_running]="伺服器 '%s' 已經在運行中。"
            [starting_server]="正在啟動伺服器 '%s'... 您可以稍後使用 '進入控制台' 功能查看進度。"
            [server_started]="伺服器 '%s' 已在背景 screen 會話中啟動。"
            [stopping_server]="正在發送停止命令到伺服器 '%s'... 請稍候。"
            [server_stopped]="伺服器 '%s' 已停止。"
            [attach_console_info]="您現在已連接到伺服器 '%s' 的控制台。"
            [detach_console_info]="要分離並讓伺服器在背景運行, 請按下 CTRL+A 然後按 D。"
            [player_management]="玩家管理"
            [player_list]="查看在線玩家列表"
            [player_op]="授予玩家 OP (管理員) 權限"
            [enter_player_name]="請輸入玩家名稱:"
            [op_success]="已授予 %s OP 權限。"
            [no_players_online]="目前沒有玩家在線。"
            [online_players]="在線玩家:"
            [plugin_management]="插件/模組管理"
            [plugin_list]="列出已安裝的插件/模組"
            [plugin_add]="新增插件/模組"
            [plugin_remove]="移除插件/模組"
            [no_plugins_found]="在 '%s' 目錄中找不到任何插件/模組。"
            [installed_plugins]="已安裝的插件/模組:"
            [plugin_search_prompt]="請輸入要搜尋的插件/模組名稱 (來自 Modrinth):"
            [searching]="正在搜尋..."
            [select_to_install]="請選擇要安裝的項目:"
            [select_version_to_install]="請選擇要安裝的版本 (請確保與伺服器版本 '%s' 兼容):"
            [downloading]="正在下載 '%s'..."
            [install_success]="'%s' 已成功安裝。"
            [select_to_remove]="請選擇要移除的插件/模組:"
            [remove_success]="'%s' 已被移除。"
            [backup_creating]="正在為 '%s' 創建備份..."
            [backup_success]="備份成功! 存檔位於: %s"
            [no_backups_found]="找不到 '%s' 的任何備份。"
            [select_backup_to_restore]="請選擇要還原的備份檔案:"
            [restore_warning]="警告：這將會覆蓋您目前的伺服器檔案！目前的狀態將會被備份。您確定要繼續嗎？ (yes/no):"
            [restore_aborted]="還原操作已取消。"
            [restoring]="正在從 '%s' 還原..."
            [restore_success]="伺服器已成功還原。"
            [config_title]="設定 server.properties"
            [config_motd]="設定伺服器訊息 (MOTD)"
            [config_max_players]="設定最大玩家數量"
            [config_difficulty]="設定遊戲難度 (peaceful, easy, normal, hard)"
            [config_pvp]="設定 PVP (true/false)"
            [config_online_mode]="設定 Online Mode (正版驗證, true/false)"
            [config_gamemode]="設定預設遊戲模式 (survival, creative...)"
            [config_view_distance]="設定視野距離 (e.g., 10)"
            [config_allow_flight]="設定允許飛行 (true/false)"
            [enter_new_value]="請輸入新的值:"
            [config_updated]="設定已更新。"
            [dep_check]="正在檢查必要的依賴工具..."
            [dep_missing]="警告：未找到指令 '%s'。"
            [dep_install_prompt]="'%s' 是此腳本的必要工具。是否嘗試為您自動安裝？ (yes/no):"
            [dep_install_info]="請輸入您的 sudo 密碼以安裝。"
            [dep_installed]="'%s' 已成功安裝。"
            [dep_install_failed]="自動安裝失敗。請手動安裝 '%s' 後再重新運行此腳本。"
            [ram_min_prompt]="請輸入最小記憶體 (例如: 1G, 2G):"
            [ram_max_prompt]="請輸入最大記憶體 (例如: 2G, 4G):"
            [update_check]="正在為 '%s' 檢查更新..."
            [update_is_latest]="您正在運行的版本 (%s) 是最新的。"
            [update_available]="有新版本可用: %s。您目前為 %s。"
            [update_prompt]="是否要升級？ (這將會下載新的 JAR 檔案並替換舊的)"
            [update_backing_up]="正在備份舊的伺服器 JAR..."
            [update_success]="伺服器核心已升級到 %s。"
        )
    else
        # English
        TEXTS=(
            [ask_language]="Please select language (請選擇語言):" [main_menu_title]="Minecraft Server Manager" [select_option]="Enter your choice" [invalid_option]="Invalid option, please try again." [press_enter_to_continue]="Press ENTER to continue..." [menu_deploy]="Deploy a New Server" [menu_manage]="Manage Existing Servers" [menu_exit]="Exit" [manage_menu_title]="Manage Server" [manage_start]="Start Server" [manage_stop]="Stop Server" [manage_console]="Attach to Console" [manage_players]="Player Management" [manage_plugins]="Plugin/Mod Management" [manage_backup]="Backup Server" [manage_restore]="Restore from Backup" [manage_configure]="Configure server.properties" [manage_update]="Check for Server Core Update" [manage_delete]="Delete Server" [menu_back]="Back to Main Menu" [no_servers]="No servers found. Please deploy one first." [select_server]="Select a server to manage:" [deploy_server_name]="Enter a name for your new server (e.g., survival_world):" [server_name_exists]="Error: A server named '%s' already exists." [select_server_type]="Select server type:" [type_paper]="Recommended, high performance, supports plugins" [type_fabric]="Recommended, supports mods" [type_spigot]="Classic, supports plugins" [type_vanilla]="Official Vanilla" [type_custom_jar]="Use a custom .jar file" [custom_jar_path]="Enter the full path to your custom .jar file:" [file_not_found]="Error: File '%s' not found." [select_mc_version]="Select Minecraft Version:" [fetching_versions]="Fetching version list..." [downloading_server]="Downloading server file... this may take a moment." [eula_prompt]="Before continuing, you must agree to Mojang's Minecraft End User License Agreement (EULA)." [eula_link_info]="Please read the EULA here: %s\n" [eula_agree_prompt]="Do you agree to the EULA? (please type yes or no):" [eula_denied]="You must agree to the EULA to create a server. Deployment cancelled." [eula_accepted]="Thank you for your agreement. EULA has been set." [deploy_complete]="Server '%s' deployed successfully!" [deploy_aborted]="Deployment aborted." [fabric_api_prompt]="Fabric servers require Fabric API. Would you like to download it automatically?" [downloading_fabric_api]="Downloading Fabric API..." [server_not_running]="Server '%s' is not running." [server_already_running]="Server '%s' is already running." [starting_server]="Starting server '%s'... You can attach to the console later to see progress." [server_started]="Server '%s' started in a background screen session." [stopping_server]="Sending stop command to server '%s'... Please wait." [server_stopped]="Server '%s' has been stopped." [attach_console_info]="You are now attached to the console of '%s'." [detach_console_info]="To detach and leave the server running, press CTRL+A, then D." [player_management]="Player Management" [player_list]="List Online Players" [player_op]="Grant OP (Administrator) to a player" [enter_player_name]="Enter player name:" [op_success]="Granted OP to %s." [no_players_online]="No players are currently online." [online_players]="Online Players:" [plugin_management]="Plugin/Mod Management" [plugin_list]="List Installed Plugins/Mods" [plugin_add]="Add New Plugin/Mod" [plugin_remove]="Remove Plugin/Mod" [no_plugins_found]="No plugins/mods found in '%s' directory." [installed_plugins]="Installed Plugins/Mods:" [plugin_search_prompt]="Enter plugin/mod name to search (from Modrinth):" [searching]="Searching..." [select_to_install]="Select an item to install:" [select_version_to_install]="Select a version to install (ensure compatibility with server version '%s'):" [downloading]="Downloading '%s'..." [install_success]="'%s' successfully installed." [select_to_remove]="Select a plugin/mod to remove:" [remove_success]="'%s' has been removed." [backup_creating]="Creating backup for '%s'..." [backup_success]="Backup successful! Archive located at: %s" [no_backups_found]="No backups found for '%s'." [select_backup_to_restore]="Select a backup file to restore:" [restore_warning]="WARNING: This will overwrite your current server files! The current state will be backed up. Are you sure you want to continue? (yes/no):" [restore_aborted]="Restore operation aborted." [restoring]="Restoring from '%s'..." [restore_success]="Server restored successfully." [config_title]="Configure server.properties" [config_motd]="Set Server Message (MOTD)" [config_max_players]="Set Max Players" [config_difficulty]="Set Game Difficulty (peaceful, easy, normal, hard)" [config_pvp]="Set PVP (true/false)" [config_online_mode]="Set Online Mode (premium validation, true/false)" [config_gamemode]="Set Default Gamemode (survival, creative...)" [config_view_distance]="Set View Distance (e.g., 10)" [config_allow_flight]="Set Allow Flight (true/false)" [enter_new_value]="Enter the new value:" [config_updated]="Configuration updated." [dep_check]="Checking for required dependencies..." [dep_missing]="Warning: Command '%s' not found." [dep_install_prompt]="'%s' is required for this script. Attempt to install it for you? (yes/no):" [dep_install_info]="Please enter your sudo password for installation." [dep_installed]="'%s' successfully installed." [dep_install_failed]="Automatic installation failed. Please install '%s' manually and run this script again." [ram_min_prompt]="Enter minimum RAM (e.g., 1G, 2G):" [ram_max_prompt]="Enter maximum RAM (e.g., 2G, 4G):" [update_check]="Checking for updates for '%s'..." [update_is_latest]="You are running the latest version (%s)." [update_available]="New version available: %s. You are on %s." [update_prompt]="Do you want to upgrade? (This will download the new JAR and replace the old one)" [update_backing_up]="Backing up old server JAR..." [update_success]="Server core upgraded to %s."
        )
    fi
}

# --- Helper Functions ---
_t() { printf "${TEXTS[$1]}" "$2" "$3"; }
_print_msg() { color=$1; shift; echo -e "${color}$*${COLOR_RESET}"; }
info() { _print_msg "$COLOR_INFO" "=> $1"; }
success() { _print_msg "$COLOR_SUCCESS" "✓ $1"; }
warning() { _print_msg "$COLOR_WARNING" "! $1"; }
error() { _print_msg "$COLOR_ERROR" "✗ $1"; }
title() { _print_msg "$COLOR_TITLE" "\n=== $1 ==="; }
press_enter() { echo ""; read -p "$(_t press_enter_to_continue)"; }
ask_yes_no() { while true; do read -p "$1 " yn; case $yn in [Yy][Ee][Ss]|[Yy]) return 0;; [Nn][Oo]|[Nn]) return 1;; *) error "$(_t invalid_option)";; esac; done; }

# --- Core Logic ---
check_dependencies() {
    title "$(_t dep_check)"; local deps=("java" "curl" "jq" "screen"); local missing_deps=()
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then warning "$(_t dep_missing "$dep")"; missing_deps+=("$dep"); else
            if [[ "$dep" == "java" ]]; then local j_ver; j_ver=$(java -version 2>&1|awk -F'"' '/version/{print $2}'|cut -d'.' -f1); if ((j_ver < 17)); then warning "Java $j_ver is old. Minecraft needs 17+."; fi; fi
            success "$dep is installed."
        fi
    done
    if [ ${#missing_deps[@]} -ne 0 ]; then
        if ask_yes_no "$(_t dep_install_prompt "${missing_deps[*]}")"; then
            if command -v apt-get &>/dev/null; then info "$(_t dep_install_info)"; sudo apt-get -y update && sudo apt-get install -y "${missing_deps[@]}";
            elif command -v dnf &>/dev/null; then info "$(_t dep_install_info)"; sudo dnf install -y "${missing_deps[@]}";
            elif command -v yum &>/dev/null; then info "$(_t dep_install_info)"; sudo yum install -y "${missing_deps[@]}";
            else error "Unsupported package manager. Please install manually."; exit 1; fi
            for dep in "${missing_deps[@]}"; do if ! command -v "$dep" &>/dev/null; then error "$(_t dep_install_failed "$dep")"; exit 1; fi; success "$(_t dep_installed "$dep")"; done
        else error "Dependencies are required. Aborting."; exit 1; fi
    fi
    local j_ver; j_ver=$(java -version 2>&1|awk -F'"' '/version/{print $2}'|cut -d'.' -f1); if ((j_ver<21)); then warning "Java $j_ver found. MC 1.20.5+ recommends Java 21."; else success "Java $j_ver is sufficient."; fi
}

select_server() {
    local -n _server_name_ref=$1; mapfile -t servers < <(find "$SERVERS_BASE_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" 2>/dev/null)
    if [ ${#servers[@]} -eq 0 ]; then warning "$(_t no_servers)"; return 1; fi
    title "$(_t select_server)"; select server_name in "${servers[@]}"; do
        if [[ -n "$server_name" ]]; then _server_name_ref="$server_name"; return 0; else error "$(_t invalid_option)"; fi
    done
    return 1
}

deploy_new_server() {
    title "$(_t menu_deploy)"; local server_name
    while true; do read -p "$(_t deploy_server_name) " server_name; if [[ -z "$server_name" ]]; then error "$(_t invalid_option)"; continue; fi
        if [[ -d "$SERVERS_BASE_DIR/$server_name" ]]; then error "$(_t server_name_exists "$server_name")"; else break; fi
    done
    local server_dir="$SERVERS_BASE_DIR/$server_name"; mkdir -p "$server_dir"; cd "$server_dir" || return 1
    local min_ram; while true; do read -p "$(_t ram_min_prompt) " min_ram; if [[ -n "$min_ram" ]]; then break; else error "$(_t invalid_option)"; fi; done
    local max_ram; while true; do read -p "$(_t ram_max_prompt) " max_ram; if [[ -n "$max_ram" ]]; then break; else error "$(_t invalid_option)"; fi; done
    title "$(_t select_server_type)"
    local options=("Paper ($(_t type_paper))" "Fabric ($(_t type_fabric))" "Spigot (emulated)" "Vanilla ($(_t type_vanilla))" "Custom JAR")
    select opt in "${options[@]}"; do
        case $REPLY in 1) deploy_type="paper"; break;; 2) deploy_type="fabric"; break;; 3) deploy_type="paper"; warning "Using Paper for Spigot."; break;; 4) deploy_type="vanilla"; break;; 5) deploy_type="custom"; break;; *) error "$(_t invalid_option)";; esac
    done
    local jar_name=""; local mc_version=""
    case $deploy_type in "paper") info "$(_t fetching_versions)"; versions=$(curl -sL "$PAPER_API"|jq -r '.versions|reverse|.[]'); title "$(_t select_mc_version)"; select ver in $versions; do if [ -n "$ver" ]; then mc_version=$ver; break; fi; done; build=$(curl -sL "$PAPER_API/versions/$mc_version"|jq -r '.builds|.[-1]'); jar_name="paper-$mc_version-$build.jar"; dl_url="$PAPER_API/versions/$mc_version/builds/$build/downloads/$jar_name"; info "$(_t downloading_server)"; curl -o "$jar_name" -# -L "$dl_url";; "fabric") info "$(_t fetching_versions)"; versions=$(curl -sL "$FABRIC_API/game"|jq -r '.[]|select(.stable==true)|.version'); title "$(_t select_mc_version)"; select ver in $versions; do if [ -n "$ver" ]; then mc_version=$ver; break; fi; done; loader_v=$(curl -sL "$FABRIC_API/loader"|jq -r '.[0].version'); installer_v=$(curl -sL "$FABRIC_API/installer"|jq -r '.[0].version'); installer_jar="fabric-installer-$installer_v.jar"; installer_url="https://maven.fabricmc.net/net/fabricmc/fabric-installer/$installer_v/$installer_jar"; info "$(_t downloading_server)"; curl -o "$installer_jar" -# -L "$installer_url"; java -jar "$installer_jar" server -mcversion "$mc_version" -loader "$loader_v" -downloadMinecraft; jar_name="fabric-server-launch.jar"; rm "$installer_jar"; if ask_yes_no "$(_t fabric_api_prompt)"; then info "$(_t downloading_fabric_api)"; mkdir -p mods; fa_api_url="$MODRINTH_API/project/fabric-api/version?loaders=[\"fabric\"]&game_versions=[\"$mc_version\"]"; fa_file_info=$(curl -sL "$fa_api_url"|jq -r '.[0].files[]|select(.primary==true)'); fa_filename=$(echo "$fa_file_info"|jq -r '.filename'); fa_dl_url=$(echo "$fa_file_info"|jq -r '.url'); curl -o "mods/$fa_filename" -# -L "$fa_dl_url"; success "$(_t install_success "$fa_filename")"; fi;; "vanilla") v_json=$(curl -sL https://launchermeta.mojang.com/mc/game/version_manifest.json); latest_r=$(echo "$v_json"|jq -r '.latest.release'); read -p "Enter version (or Enter for $latest_r): " mc_version; [[ -z "$mc_version" ]]&&mc_version=$latest_r; v_url=$(echo "$v_json"|jq -r --arg V "$mc_version" '.versions[]|select(.id==$V)|.url'); srv_dl_url=$(curl -s "$v_url"|jq -r '.downloads.server.url'); jar_name="vanilla-$mc_version.jar"; info "$(_t downloading_server)"; curl -o "$jar_name" -# -L "$srv_dl_url";; "custom") while true; do read -p "$(_t custom_jar_path) " c_path; if [[ -f "$c_path" ]]; then cp "$c_path" .; jar_name=$(basename "$c_path"); mc_version=$(echo "$jar_name"|grep -oE '1\.[0-9]+\.?[0-9]*'|head -n 1); info "Guessed MC version: $mc_version"; break; else error "$(_t file_not_found "$c_path")"; fi; done;; esac
    title "EULA Agreement"; warning "$(_t eula_prompt)"; info "$(_t eula_link_info "$EULA_URL")"
    if ask_yes_no "$(_t eula_agree_prompt)"; then echo "eula=true" > eula.txt; success "$(_t eula_accepted)"; else error "$(_t eula_denied)"; cd "$HOME"&&rm -rf "$server_dir"; error "$(_t deploy_aborted)"; press_enter; return 1; fi
    echo -e "#!/bin/bash\ncd \"\$(dirname \"\$0\")\"\nexec &> >(tee -a latest.log)\njava -Xms${min_ram} -Xmx${max_ram} -XX:+UseG1GC -jar \"${jar_name}\" nogui" > start.sh
    chmod +x start.sh; echo "$deploy_type" > .server_type; echo "$mc_version" > .mc_version; echo "$jar_name" > .jar_name
    success "$(_t deploy_complete "$server_name")"; press_enter; cd "$HOME"
}

get_server_dir() { echo "$SERVERS_BASE_DIR/$1"; }
get_screen_name() { echo "mc-$1"; }
is_server_running() { screen -list | grep -q "$(get_screen_name "$1")"; }
urlencode() { jq -s -R -r @uri <<< "$1"; }

# --- REFORMATTED & FIXED FUNCTIONS ---

start_server() {
    local server_name=$1
    if is_server_running "$server_name"; then
        error "$(_t server_already_running "$server_name")"
        return
    fi
    local server_dir
    server_dir=$(get_server_dir "$server_name")
    cd "$server_dir" || return
    info "$(_t starting_server "$server_name")"
    screen -dmS "$(get_screen_name "$server_name")" ./start.sh
    success "$(_t server_started "$server_name")"
}

stop_server() {
    local server_name=$1
    if ! is_server_running "$server_name"; then
        error "$(_t server_not_running "$server_name")"
        return
    fi
    local screen_name
    screen_name=$(get_screen_name "$server_name")
    info "$(_t stopping_server "$server_name")"
    screen -p 0 -S "$screen_name" -X eval "stuff \"say SERVER SHUTTING DOWN IN 10 SECONDS...\"\015"
    sleep 5
    screen -p 0 -S "$screen_name" -X eval "stuff \"say SERVER SHUTTING DOWN IN 5 SECONDS...\"\015"
    sleep 5
    screen -p 0 -S "$screen_name" -X eval "stuff \"stop\"\015"
    local count=0
    while is_server_running "$server_name" && [ $count -lt 30 ]; do
        sleep 1
        ((count++))
    done
    if is_server_running "$server_name"; then
        warning "Server did not stop gracefully. Killing session."
        screen -X -S "$screen_name" quit
    fi
    success "$(_t server_stopped "$server_name")"
}

attach_to_console() {
    local server_name=$1
    if ! is_server_running "$server_name"; then
        error "$(_t server_not_running "$server_name")"
        return
    fi
    info "$(_t attach_console_info "$server_name")"
    # *** THIS IS THE FIX ***
    info "$(_t detach_console_info)"
    screen -r "$(get_screen_name "$server_name")"
}

send_command() {
    local server_name=$1
    local command=$2
    if ! is_server_running "$server_name"; then
        error "$(_t server_not_running "$server_name")"
        return 1
    fi
    screen -p 0 -S "$(get_screen_name "$server_name")" -X eval "stuff \"$command\"\015"
    return 0
}

player_management() {
    local server_name=$1; local server_dir; server_dir=$(get_server_dir "$server_name"); title "$(_t player_management) - $server_name"
    local opts=("$(_t player_list)" "$(_t player_op)" "$(_t menu_back)"); select opt in "${opts[@]}"; do
        case $REPLY in
            1) send_command "$server_name" "list"; sleep 2; info "$(_t online_players)"; local p_list; p_list=$(grep 'players online:' -A1 "$server_dir/logs/latest.log" 2>/dev/null | tail -n1 | sed -E 's/.*INFO\]: //'); if [[ -n "$p_list" && "$p_list" != "" ]]; then echo "$p_list"; else info "$(_t no_players_online)"; fi; press_enter; break;;
            2) read -p "$(_t enter_player_name) " p_name; if [[ -n "$p_name" ]]; then send_command "$server_name" "op $p_name"; success "$(_t op_success "$p_name")"; fi; press_enter; break;;
            3) return;; *) error "$(_t invalid_option)"; press_enter; break;;
        esac
    done
}
plugin_management() {
    local s_name=$1; local s_dir=$(get_server_dir "$s_name"); local s_type=$(cat "$s_dir/.server_type" 2>/dev/null); local p_dir="plugins"; if [ "$s_type" == "fabric" ]; then p_dir="mods"; fi
    while true; do
        title "$(_t plugin_management) - ($p_dir)"; local opts=("$(_t plugin_list)" "$(_t plugin_add)" "$(_t plugin_remove)" "$(_t menu_back)")
        select opt in "${opts[@]}"; do case $REPLY in
            1) title "$(_t installed_plugins)"; if [ -d "$s_dir/$p_dir" ] && ls -A "$s_dir/$p_dir"/*.jar &>/dev/null; then ls -1 "$s_dir/$p_dir"/*.jar|xargs -n 1 basename; else warning "$(_t no_plugins_found "$p_dir")"; fi; press_enter; break;;
            2) read -p "$(_t plugin_search_prompt) " query; if [ -z "$query" ]; then break; fi; info "$(_t searching)"; local mc_ver=$(cat "$s_dir/.mc_version"); local p_type="plugin"; if [[ "$s_type" == "fabric" ]]; then p_type="mod"; fi; local search_url="$MODRINTH_API/search?query=$(urlencode "$query")&facets=[[\"project_type:$p_type\"]]"; local s_results; s_results=$(curl -sL "$search_url"); mapfile -t P_TITLES < <(echo "$s_results"|jq -r '.hits[]|.title'); mapfile -t P_IDS < <(echo "$s_results"|jq -r '.hits[]|.project_id'); if [ ${#P_TITLES[@]} -eq 0 ]; then warning "No results found."; press_enter; break; fi; title "$(_t select_to_install)"; select p_title in "${P_TITLES[@]}"; do if [[ -n "$p_title" ]]; then local sel_id=${P_IDS[$REPLY-1]}; info "$(_t fetching_versions)"; local loader="paper"; if [[ "$s_type" == "fabric" ]]; then loader="fabric"; fi; local v_url="$MODRINTH_API/project/$sel_id/version?game_versions=[\"$mc_ver\"]&loaders=[\"$loader\"]"; local v_results; v_results=$(curl -sL "$v_url"); mapfile -t V_NAMES < <(echo "$v_results"|jq -r '.[].name'); mapfile -t V_URLS < <(echo "$v_results"|jq -r '.[].files[]|select(.primary==true)|.url'); mapfile -t V_FILES < <(echo "$v_results"|jq -r '.[].files[]|select(.primary==true)|.filename'); if [ ${#V_NAMES[@]} -eq 0 ]; then warning "No compatible versions for MC $mc_ver."; press_enter; break 2; fi; title "$(_t select_version_to_install "$mc_ver")"; select v_name in "${V_NAMES[@]}"; do if [[ -n "$v_name" ]]; then local dl_url=${V_URLS[$REPLY-1]}; local dl_file=${V_FILES[$REPLY-1]}; info "$(_t downloading "$dl_file")"; mkdir -p "$s_dir/$p_dir"; curl -o "$s_dir/$p_dir/$dl_file" -# -L "$dl_url"; success "$(_t install_success "$dl_file")"; warning "Restart server for changes to take effect."; press_enter; break 2; fi; done; fi; done; break;;
            3) if [ ! -d "$s_dir/$p_dir" ] || ! ls -A "$s_dir/$p_dir"/*.jar &>/dev/null; then warning "$(_t no_plugins_found "$p_dir")"; press_enter; break; fi; mapfile -t files < <(ls -1 "$s_dir/$p_dir"/*.jar); mapfile -t basenames < <(for f in "${files[@]}"; do basename "$f"; done); title "$(_t select_to_remove)"; select f_to_remove in "${basenames[@]}"; do if [[ -n "$f_to_remove" ]]; then rm "$s_dir/$p_dir/$f_to_remove"; success "$(_t remove_success "$f_to_remove")"; warning "Restart server for changes to take effect."; press_enter; break; fi; done; break;;
            4) return 0;; *) error "$(_t invalid_option)"; press_enter; break;; esac; done; done
}

backup_server() {
    local server_name=$1
    local server_dir; server_dir=$(get_server_dir "$server_name")
    local backup_dir="$server_dir/backups"
    mkdir -p "$backup_dir"
    local backup_file="$backup_dir/backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
    info "$(_t backup_creating "$server_name")"
    tar --exclude='./backups' -czvf "$backup_file" -C "$server_dir" .
    success "$(_t backup_success "$backup_file")"
}

restore_server() {
    local server_name=$1
    local server_dir=$(get_server_dir "$server_name")
    local backup_dir="$server_dir/backups"
    if [ ! -d "$backup_dir" ] || [ -z "$(ls -A "$backup_dir"/*.tar.gz 2>/dev/null)" ]; then
        warning "$(_t no_backups_found "$server_name")"; return;
    fi
    mapfile -t backups < <(ls -1t "$backup_dir"/*.tar.gz)
    mapfile -t b_names < <(for b in "${backups[@]}"; do basename "$b"; done)
    title "$(_t select_backup_to_restore)"; select b_choice in "${b_names[@]}"; do
        if [[ -n "$b_choice" ]]; then
            if ! ask_yes_no "$(_t restore_warning)"; then info "$(_t restore_aborted)"; return; fi
            if is_server_running "$server_name"; then info "Stopping server for restore."; stop_server "$server_name"; fi
            info "Backing up current state as safety measure..."; backup_server "$server_name"
            info "$(_t restoring "$b_choice")"
            tar -tf "$b_dir/$b_choice" | xargs -I {} rm -rf "$server_dir/{}" 2>/dev/null
            tar -xzvf "$b_dir/$b_choice" -C "$server_dir"
            success "$(_t restore_success)"; break
        fi
    done
}

configure_server() {
    local server_name=$1; local server_dir=$(get_server_dir "$server_name"); local prop_file="$server_dir/server.properties"
    if [[ ! -f "$prop_file" ]]; then warning "server.properties not found. Start server once to generate."; press_enter; return; fi
    set_prop() {
        if grep -q "^$1=" "$prop_file"; then sed -i "s|^$1=.*|$1=$2|" "$prop_file"; else echo "$1=$2" >> "$prop_file"; fi
        success "$(_t config_updated)"; warning "Restart server for changes to take effect."
    }
    while true; do
        title "$(_t config_title)"
        local opts=("$(_t config_motd)" "$(_t config_max_players)" "$(_t config_difficulty)" "$(_t config_pvp)" "$(_t config_online_mode)" "$(_t config_gamemode)" "$(_t config_view_distance)" "$(_t config_allow_flight)" "$(_t menu_back)")
        select opt in "${opts[@]}"; do
            case $REPLY in
                1) read -p "$(_t enter_new_value): " val; set_prop "motd" "$val";;
                2) read -p "$(_t enter_new_value): " val; set_prop "max-players" "$val";;
                3) read -p "$(_t enter_new_value): " val; set_prop "difficulty" "$val";;
                4) read -p "$(_t enter_new_value): " val; set_prop "pvp" "$val";;
                5) read -p "$(_t enter_new_value) (true/false): " val; set_prop "online-mode" "$val";;
                6) read -p "$(_t enter_new_value) (e.g. survival): " val; set_prop "gamemode" "$val";;
                7) read -p "$(_t enter_new_value) (e.g. 10): " val; set_prop "view-distance" "$val";;
                8) read -p "$(_t enter_new_value) (true/false): " val; set_prop "allow-flight" "$val";;
                9) return;;
                *) error "$(_t invalid_option)";;
            esac
            press_enter; break
        done
    done
}

update_server_core() {
    local server_name=$1; local server_dir=$(get_server_dir "$server_name"); cd "$server_dir" || return
    local server_type; server_type=$(cat .server_type); local current_jar; current_jar=$(cat .jar_name); local mc_version; mc_version=$(cat .mc_version)
    info "$(_t update_check "$server_name")"
    if [[ "$server_type" != "paper" ]]; then warning "Auto-update is only supported for PaperMC."; return; fi
    local latest_build; latest_build=$(curl -sL "$PAPER_API/versions/$mc_version" | jq -r '.builds|.[-1]')
    local latest_jar="paper-$mc_version-$latest_build.jar"
    if [[ "$current_jar" == "$latest_jar" ]]; then success "$(_t update_is_latest "$current_jar")"; return; fi
    info "$(_t update_available "$latest_jar" "$current_jar")"
    if ! ask_yes_no "$(_t update_prompt)"; then return; fi
    if is_server_running "$server_name"; then info "Stopping server for update."; stop_server "$server_name"; fi
    info "$(_t update_backing_up)"; mv "$current_jar" "${current_jar}.bak"
    info "$(_t downloading_server)"; curl -o "$latest_jar" -# -L "$PAPER_API/versions/$mc_version/builds/$latest_build/downloads/$latest_jar"
    echo "$latest_jar" > .jar_name; sed -i "s/$current_jar/$latest_jar/" "start.sh"
    success "$(_t update_success "$latest_jar")"
}

delete_server() {
    local server_name=$1
    warning "!!! DELETION WARNING !!!"; warning "This will permanently delete '$server_name' and all of its data (worlds, plugins, backups)."
    if ! ask_yes_no "Are you absolutely sure you want to delete '$server_name'? (yes/no):"; then
        info "Deletion cancelled."; return
    fi
    if is_server_running "$server_name"; then stop_server "$server_name"; fi
    info "Deleting server directory: $(get_server_dir "$server_name")"
    rm -rf "$(get_server_dir "$server_name")"
    success "Server '$server_name' has been deleted."
}

manage_servers_menu() {
    local server_name; if ! select_server server_name; then return; fi
    while true; do
        clear; title "$(_t manage_menu_title): $server_name"
        local status_text
        if is_server_running "$server_name"; then status_text="${COLOR_SUCCESS}Running${COLOR_RESET}"; else status_text="${COLOR_ERROR}Stopped${COLOR_RESET}"; fi
        echo -e "Status: $status_text\n"
        local options=("$(_t manage_start)" "$(_t manage_stop)" "$(_t manage_console)" "$(_t manage_players)" "$(_t manage_plugins)" "$(_t manage_backup)" "$(_t manage_restore)" "$(_t manage_configure)" "$(_t manage_update)" "$(_t manage_delete)" "$(_t menu_back)")
        select opt in "${options[@]}"; do
            case $REPLY in
                1) start_server "$server_name";; 2) stop_server "$server_name";; 3) attach_to_console "$server_name";;
                4) player_management "$server_name";; 5) plugin_management "$server_name";; 6) backup_server "$server_name";;
                7) restore_server "$server_name";; 8) configure_server "$server_name";; 9) update_server_core "$server_name";;
                10) delete_server "$server_name"; return;; 11) return;; *) error "$(_t invalid_option)";;
            esac
            if [[ $REPLY -ne 3 && $REPLY -lt 10 ]]; then press_enter; fi; break
        done
    done
}

main_menu() {
    while true; do
        clear; title "$(_t main_menu_title)"; echo "Server Directory: $SERVERS_BASE_DIR"
        local options=("$(_t menu_deploy)" "$(_t menu_manage)" "$(_t menu_exit)"); select opt in "${options[@]}"; do
            case $REPLY in 1) deploy_new_server;; 2) manage_servers_menu;; 3) exit 0;; *) error "$(_t invalid_option)";; esac
            break
        done
    done
}

main() {
    clear; echo -e "1. 繁體中文\n2. English"; local lang
    while true; do read -p "Please select a language (請選擇語言) [1/2]: " lang; if [[ "$lang" == "1" || "$lang" == "2" ]]; then break; else error "Invalid input."; fi; done
    setup_language "$lang"
    check_dependencies
    mkdir -p "$SERVERS_BASE_DIR"
    main_menu
}

# --- Script Entry Point ---
main
