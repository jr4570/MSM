---

# Minecraft Server Manager

A powerful and easy-to-use, single-file Bash script designed to streamline the entire process of deploying and managing multiple Minecraft servers on a Linux machine. Whether you are a beginner or an experienced administrator, this script will help you save time and avoid tedious manual configurations.

[中文說明](./README.md) 

## ✨ Features

*   **🌐 Multi-language Interface**: Choose between English or Traditional Chinese at startup.
*   **🧩 Automatic Dependency Handling**: Auto-detects required tools like `java`, `curl`, `jq`, and `screen`, and prompts for guided installation if they are missing.
*   **⚙️ One-Click Server Deployment**:
    *   Supports major server types: **Paper**, **Fabric**, **Vanilla**.
    *   Ability to use a **custom JAR file**.
    *   Automatically fetches and downloads the latest or a specific Minecraft version from official APIs.
*   **🗂️ Multi-Instance Management**: Effortlessly create and manage multiple, completely isolated server instances on a single host.
*   **📦 Plugin & Mod Management**:
    *   Connects directly to the **Modrinth API** to search, select, and install plugins/mods.
    *   Easily list and remove installed packages.
    *   Automatically prompts to install Fabric API for Fabric servers.
*   **🕹️ Comprehensive Server Control**:
    *   Start the server in a background `screen` session.
    *   Gracefully stop the server with a countdown warning.
    *   Attach to the server console at any time to enter commands manually.
*   **🔧 Server Configuration**: Easily modify common settings in `server.properties` through a menu, such as `online-mode`, `MOTD`, `max-players`, and more.
*   **🛡️ Backup & Restore**: Create a compressed `tar.gz` backup of your entire server (world, plugins, configs) with a single command, and easily restore from a list of available backups.
*   **🧑‍🤝‍🧑 Player Management**: Conveniently view the list of online players or grant a player OP permissions.
*   **📜 Guided EULA Agreement**: The deployment process guides you to read and personally agree to the Minecraft EULA, ensuring compliance.
*   **⬆️ Server Core Upgrades**: Automatically checks for new builds of PaperMC and provides a one-click upgrade option.
*   **✅ User-Friendly**: Fully menu-driven operation to minimize typos, with clear error messages and guidance.

## ⚙️ Requirements

*   A **Linux-based OS** (e.g., Debian, Ubuntu, CentOS, Fedora).
*   **Bash Shell**.
*   **Sudo/root privileges** (only needed for the first run if dependencies need to be installed).
*   An active **internet connection** (for downloading server files, plugins, and dependencies).

This script will automatically check for the following dependencies and offer to install them if missing:
*   **Java 17 or newer** (A standard requirement for modern Minecraft servers, the script will check your version).
*   `curl`
*   `jq`
*   `screen`

## 🚀 Quick Start

1.  **Download the Script**
    Copy the script's content to your server and save it as `msm_v2.1.4.sh`.
    
    or

    Open your terminal and run the following command:
    ```bash
    wget https://github.com/jr4570/Minecraft-Server-Management-Script/releases/download/MSM_V2.0/msm_v2.1.4.sh
    ```
3.  **Grant Execution Permissions**
    Open your terminal and run the following command:
    ```bash
    chmod +x msm_v2.1.4.sh
    ```

4.  **Run the Script**
    Execute the script to begin:
    ```bash
    ./msm_v2.1.4.sh
    ```

## 📖 Usage Walkthrough

### 1. First Run
When you start the script for the first time, it will:
*   Ask you to select your preferred language.
*   Check for all required dependencies. If any are missing, it will ask for your permission to attempt an automatic installation.

### 2. The Main Menu
You will be greeted with a clear main menu:
*   `1. Deploy a New Server`: Create a brand-new server instance.
*   `2. Manage Existing Servers`: Manage all servers you have already created.
*   `3. Exit`: Close the script.

### 3. Deploying a New Server
When you choose to deploy, the script will guide you through these steps:
1.  **Name your server**: For example, `my_survival_world`.
2.  **Set RAM**: Enter the minimum (Xms) and maximum (Xmx) RAM allocation, e.g., `2G`, `4G`.
3.  **Choose Server Type**: Select from Paper, Fabric, Vanilla, or a custom JAR.
4.  **Select Version**: The script will fetch available Minecraft versions for you to choose from.
5.  **Agree to the EULA**: The script will display the official EULA link, and you must type `yes` to proceed.
Once complete, all necessary files will be downloaded and configured.

### 4. Managing an Existing Server
After selecting this option, you will see a list of your created servers. Choose one to access its dedicated management menu, where you can:
*   **Start/Stop/Attach to Console**: Perform basic server operations.
*   **Manage Plugins/Mods**: Search for and install new content from Modrinth.
*   **Backup/Restore**: Keep your server data safe.
*   **Configure server.properties**: Quickly tweak server rules.
*   **Delete Server**: **This action is irreversible** and will permanently delete all of the server's files.

## 📁 File Structure

All servers are stored under the `~/mc_servers/` directory, with each server in its own isolated subdirectory:

```
/home/user/mc_servers/
└── my_survival_world/      # Your server instance name
    ├── world/              # World files
    ├── plugins/            # Plugin directory (Paper/Spigot)
    ├── mods/               # Mod directory (Fabric)
    ├── backups/            # Backup archive location
    │   └── backup-2023-10-27_10-30-00.tar.gz
    ├── server.properties   # Server properties file
    ├── eula.txt            # EULA agreement file
    ├── paper-1.20.2-313.jar # The server JAR (example)
    ├── start.sh            # The launch script
    ├── latest.log          # The server log file
    ├── .server_type        # Metadata used by the script
    ├── .mc_version         # Metadata used by the script
    └── .jar_name           # Metadata used by the script
```

## ⚠️ Disclaimer

*   This script was generated with AI assistance and, while tested, may still contain unknown bugs.
*   Before performing high-risk operations like 'Restore' or 'Delete', please double-check your selection. It's highly recommended to have your own external backups.
*   The author is not responsible for any data loss that may occur from using this script.
