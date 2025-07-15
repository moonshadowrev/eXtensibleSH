#!/bin/bash

# eXtensibleSH - Extensible Bash script for easy self-hosting
# Author: moonshadowrev
# Repository: https://github.com/moonshadowrev/eXtensibleSH
# License: GPLv3

# This script provides a menu-driven interface for loading plugins and third-party scripts
# from GitHub without permanently downloading them to the local system. All scripts are
# OS-aware and executed remotely via curl.

set -e  # Exit on error
set -u  # Exit on undefined variable
trap 'echo -e "\n${RED}Error occurred at line $LINENO${NC}"; exit 1' ERR

# Global variables (UPPER_CASE as per guidelines)
GITHUB_USER="moonshadowrev"
GITHUB_REPO="eXtensibleSH"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main"
SCRIPT_VERSION="1.0.0"

# Color codes for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Unicode symbols for better visualization
CHECKMARK="✓"
CROSS="✗"
WARNING="⚠"
INFO="ℹ"
ARROW="→"
BULLET="•"
STAR="★"
GEAR="⚙"
ROCKET="🚀"

# Function to print colored output
print_color() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Function to print header with styling
print_header() {
    local title="$1"
    local width=80
    local title_len=${#title}
    local padding=$(((width - title_len - 2) / 2))
    
    echo
    print_color "$CYAN" "$(printf '═%.0s' {1..80})"
    print_color "$CYAN" "║$(printf '%*s' $padding '')${WHITE}${title}${CYAN}$(printf '%*s' $padding '')║"
    print_color "$CYAN" "$(printf '═%.0s' {1..80})"
    echo
}

# Function to print section separator
print_section() {
    local title="$1"
    echo
    print_color "$BLUE" "┌─ ${title} ─────────────────────────────────────────────────────────────────"
    echo
}

# Function to print footer
print_footer() {
    echo
    print_color "$GRAY" "$(printf '─%.0s' {1..80})"
    print_color "$GRAY" "eXtensibleSH v${SCRIPT_VERSION} | https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
    print_color "$GRAY" "$(printf '─%.0s' {1..80})"
    echo
}

# Function to detect OS and set OS_GROUP
detect_os() {
    print_color "$YELLOW" "${INFO} Detecting operating system..."
    
    OS="unknown"
    VER=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS="${ID,,}"
        VER="$VERSION_ID"
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si | tr 'A-Z' 'a-z')
        VER=$(lsb_release -sr)
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/redhat-release ]; then
        OS=$(sed 's/.*release \([a-zA-Z]*\).*/\1/' /etc/redhat-release | tr 'A-Z' 'a-z')
        VER=$(sed 's/.*release \([0-9.]*\).*/\1/' /etc/redhat-release)
    elif [ -f /etc/arch-release ]; then
        OS="arch"
    else
        OS=$(uname -s | tr 'A-Z' 'a-z')
        VER=$(uname -r)
    fi

    # Normalize to OS_GROUP
    case "$OS" in
        ubuntu|debian|kali|mint|raspbian) OS_GROUP="debian" ;;
        centos|fedora|rhel|rocky|almalinux|oracle|amazonlinux) OS_GROUP="rhel" ;;
        arch|manjaro|endeavouros) OS_GROUP="arch" ;;
        opensuse|suse) OS_GROUP="suse" ;;
        alpine) OS_GROUP="alpine" ;;
        *) OS_GROUP="unknown" ;;
    esac

    # Enhanced OS detection for custom distros
    if [[ "$OS" == *"cloudlinux"* ]]; then
        OS_GROUP="rhel"
    fi

    print_color "$GREEN" "${CHECKMARK} OS detected: ${WHITE}${OS}${NC} (${OS_GROUP}), Version: ${VER}"
}

# Function to set up logging
setup_logging() {
    LOG_DIR="./logs"
    
    # Create logs directory if it doesn't exist
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR" 2>/dev/null || {
            print_color "$YELLOW" "${WARNING} Cannot create logs directory. Trying with sudo..."
            sudo mkdir -p "$LOG_DIR"
            sudo chown "$USER" "$LOG_DIR" 2>/dev/null || true
        }
    fi
    
    # Check if directory is writable
    if [ ! -w "$LOG_DIR" ]; then
        print_color "$YELLOW" "${WARNING} Logs directory not writable. Trying to fix permissions..."
        sudo chown "$USER" "$LOG_DIR" 2>/dev/null || true
    fi
    
    LOG_FILE="${LOG_DIR}/exsh-log-$(date +%Y%m%d%H%M%S).log"
    
    # Set up logging
    exec > >(tee -a "$LOG_FILE") 2>&1
    
    print_color "$GREEN" "${CHECKMARK} Logging initialized: ${WHITE}${LOG_FILE}${NC}"
}

# Function to check if a plugin file exists on GitHub
plugin_exists() {
    local plugin="$1"
    local category="$2"
    local os_group="$3"
    local version="${4:-latest}"
    
    # New plugin structure: plugins/category/plugin/os_group/version.sh
    local url="${BASE_URL}/plugins/${category}/${plugin}/${os_group}/${version}.sh"
    
    curl -s -f --head "$url" >/dev/null 2>&1
}

# Function to check if old plugin structure exists (backward compatibility)
plugin_exists_legacy() {
    local plugin="$1"
    local os_group="$2"
    local url="${BASE_URL}/plugins/${plugin}/${os_group}.sh"
    
    curl -s -f --head "$url" >/dev/null 2>&1
}

# Function to get plugin metadata
get_plugin_metadata() {
    local plugin="$1"
    local category="$2"
    local metadata_url="${BASE_URL}/plugins/${category}/${plugin}/metadata.json"
    
    curl -s -f "$metadata_url" 2>/dev/null || echo "{}"
}

# Function to load and parse plugin list
load_plugins() {
    print_color "$YELLOW" "${INFO} Loading plugin registry..."
    
    # Try new structured approach first
    PLUGIN_REGISTRY=$(curl -s "${BASE_URL}/plugins/registry.json" 2>/dev/null || echo "{}")
    
    # Fallback to legacy list if registry doesn't exist
    if [ "$PLUGIN_REGISTRY" = "{}" ]; then
        PLUGIN_LIST=$(curl -s "${BASE_URL}/plugins/list.txt" 2>/dev/null || echo "")
        if [ -z "$PLUGIN_LIST" ]; then
            print_color "$RED" "${CROSS} Failed to fetch plugin list. Check internet connection or repository."
            return 1
        fi
    fi
    
    print_color "$GREEN" "${CHECKMARK} Plugin registry loaded successfully"
    return 0
}

# Function to load third-party scripts
load_thirdparty() {
    print_color "$YELLOW" "${INFO} Loading third-party scripts..."
    
    THIRDPARTY_REGISTRY=$(curl -s "${BASE_URL}/thirdparty/registry.json" 2>/dev/null || echo "{}")
    THIRDPARTY_LIST=$(curl -s "${BASE_URL}/thirdparty/list.txt" 2>/dev/null || echo "")
    
    if [ -z "$THIRDPARTY_LIST" ]; then
        print_color "$YELLOW" "${WARNING} No third-party scripts available"
        return 0
    fi
    
    print_color "$GREEN" "${CHECKMARK} Third-party scripts loaded successfully"
    return 0
}

# Function to display available plugins by category
display_plugins() {
    print_section "Available Plugins"
    
    # Categories to display
    local categories=("webservers" "databases" "containerization" "monitoring" "security" "storage")
    local category_icons=("🌐" "💾" "🐳" "📊" "🔒" "💿")
    
    for i in "${!categories[@]}"; do
        local category="${categories[$i]}"
        local icon="${category_icons[$i]}"
        
        print_color "$MAGENTA" "${icon} ${category^^}:"
        
        # List plugins in this category
        local found_plugins=false
        local plugin_count=0
        
        # Check if we have plugins for this category
        for plugin_dir in plugins/${category}/*/; do
            if [ -d "$plugin_dir" ]; then
                local plugin_name=$(basename "$plugin_dir")
                local metadata=$(get_plugin_metadata "$plugin_name" "$category")
                local display_name=$(echo "$metadata" | jq -r '.display_name // .name // "Unknown"' 2>/dev/null || echo "$plugin_name")
                local description=$(echo "$metadata" | jq -r '.description // "No description available"' 2>/dev/null || echo "No description available")
                
                # Check OS compatibility
                local compatibility_icon=""
                if plugin_exists "$plugin_name" "$category" "$OS_GROUP"; then
                    compatibility_icon="${GREEN}${CHECKMARK}${NC}"
                elif plugin_exists "$plugin_name" "$category" "generic"; then
                    compatibility_icon="${YELLOW}${WARNING}${NC}"
                else
                    compatibility_icon="${RED}${CROSS}${NC}"
                fi
                
                print_color "$WHITE" "  ${compatibility_icon} ${display_name}"
                print_color "$GRAY" "    ${description}"
                
                found_plugins=true
                ((plugin_count++))
            fi
        done
        
        if [ "$found_plugins" = false ]; then
            print_color "$GRAY" "  No plugins available in this category"
        fi
        
        echo
    done
    
    # Legacy plugins (backward compatibility)
    print_color "$MAGENTA" "📦 LEGACY PLUGINS:"
    if [ -n "$PLUGIN_LIST" ]; then
        while IFS= read -r line; do
            if [[ "$line" == *":"* ]]; then
                local plugin=$(echo "$line" | cut -d':' -f1)
                local supported=$(echo "$line" | cut -d':' -f2)
                local compatibility_icon=""
                
                if [[ "$supported" == *"$OS_GROUP"* ]]; then
                    compatibility_icon="${GREEN}${CHECKMARK}${NC}"
                elif plugin_exists_legacy "$plugin" "generic"; then
                    compatibility_icon="${YELLOW}${WARNING}${NC}"
                else
                    compatibility_icon="${RED}${CROSS}${NC}"
                fi
                
                print_color "$WHITE" "  ${compatibility_icon} ${plugin} (${supported})"
            elif [[ ! "$line" =~ ^#.*$ ]] && [[ -n "$line" ]]; then
                print_color "$WHITE" "  ${YELLOW}${WARNING}${NC} $line (generic or unknown support)"
            fi
        done <<< "$PLUGIN_LIST"
    else
        print_color "$GRAY" "  No legacy plugins available"
    fi
}

# Function to display third-party scripts
display_thirdparty() {
    print_section "Third-Party Scripts"
    
    print_color "$RED" "${WARNING} Third-party scripts are not officially maintained by eXtensibleSH."
    print_color "$RED" "    Always review the source code before execution!"
    echo
    
    if [ -n "$THIRDPARTY_LIST" ]; then
        local categories=("webservers" "databases" "containerization" "monitoring" "security" "storage" "misc")
        local category_icons=("🌐" "💾" "🐳" "📊" "🔒" "💿" "🛠")
        
        for i in "${!categories[@]}"; do
            local category="${categories[$i]}"
            local icon="${category_icons[$i]}"
            local found_scripts=false
            
            print_color "$MAGENTA" "${icon} ${category^^}:"
            
            while IFS=':' read -r name cat_name url description; do
                if [[ "$name" =~ ^#.*$ ]] || [[ -z "$name" ]]; then
                    continue
                fi
                
                if [[ "$cat_name" == "$category" ]]; then
                    print_color "$WHITE" "  ${STAR} ${name}"
                    print_color "$GRAY" "    ${description}"
                    print_color "$GRAY" "    ${url}"
                    found_scripts=true
                fi
            done <<< "$THIRDPARTY_LIST"
            
            if [ "$found_scripts" = false ]; then
                print_color "$GRAY" "  No scripts available in this category"
            fi
            
            echo
        done
    else
        print_color "$GRAY" "No third-party scripts available"
    fi
}

# Function to run a plugin
run_plugin() {
    local plugin=$(echo "$1" | tr 'A-Z' 'a-z' | sed 's/^#//')
    local category="$2"
    local version="${3:-latest}"
    
    print_color "$YELLOW" "${ROCKET} Loading plugin: ${WHITE}${plugin}${NC}"
    
    if [ "$OS_GROUP" = "unknown" ]; then
        print_color "$RED" "${WARNING} Unknown OS detected. Plugin may not work correctly."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    # Try new plugin structure first
    if [ -n "$category" ] && plugin_exists "$plugin" "$category" "$OS_GROUP" "$version"; then
        print_color "$GREEN" "${CHECKMARK} Loading OS-specific plugin for ${OS_GROUP}"
        curl -s "${BASE_URL}/plugins/${category}/${plugin}/${OS_GROUP}/${version}.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
    elif [ -n "$category" ] && plugin_exists "$plugin" "$category" "generic" "$version"; then
        print_color "$YELLOW" "${WARNING} No OS-specific plugin found. Loading generic version."
        curl -s "${BASE_URL}/plugins/${category}/${plugin}/generic/${version}.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
    # Fallback to legacy structure
    elif plugin_exists_legacy "$plugin" "$OS_GROUP"; then
        print_color "$GREEN" "${CHECKMARK} Loading legacy plugin for ${OS_GROUP}"
        curl -s "${BASE_URL}/plugins/${plugin}/${OS_GROUP}.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
    elif plugin_exists_legacy "$plugin" "generic"; then
        print_color "$YELLOW" "${WARNING} Loading legacy generic plugin"
        curl -s "${BASE_URL}/plugins/${plugin}/generic.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
    else
        print_color "$RED" "${CROSS} No plugin found for ${plugin}"
        print_color "$YELLOW" "${WARNING} Available options:"
        print_color "$WHITE" "  1. Check plugin name spelling"
        print_color "$WHITE" "  2. Force load from different OS"
        print_color "$WHITE" "  3. Try third-party scripts"
        
        read -p "Force load from different OS? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter OS group to force (debian/rhel/arch/generic): " forced_os
            if [ -n "$category" ] && plugin_exists "$plugin" "$category" "$forced_os" "$version"; then
                print_color "$YELLOW" "${WARNING} Force loading from ${forced_os}"
                curl -s "${BASE_URL}/plugins/${category}/${plugin}/${forced_os}/${version}.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
            elif plugin_exists_legacy "$plugin" "$forced_os"; then
                print_color "$YELLOW" "${WARNING} Force loading legacy plugin from ${forced_os}"
                curl -s "${BASE_URL}/plugins/${plugin}/${forced_os}.sh" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
            else
                print_color "$RED" "${CROSS} Plugin not found for ${forced_os} either"
                return 1
            fi
        else
            return 1
        fi
    fi
}

# Function to run third-party script
run_thirdparty() {
    local script_name="$1"
    local script_url=""
    
    # Find the script URL
    while IFS=':' read -r name category url description; do
        if [[ "$name" =~ ^#.*$ ]] || [[ -z "$name" ]]; then
            continue
        fi
        
        if [[ "$name" == "$script_name" ]]; then
            script_url="$url"
            break
        fi
    done <<< "$THIRDPARTY_LIST"
    
    if [ -z "$script_url" ]; then
        print_color "$RED" "${CROSS} Third-party script not found: ${script_name}"
        return 1
    fi
    
    print_color "$RED" "${WARNING} You are about to run a third-party script!"
    print_color "$WHITE" "Script: ${script_name}"
    print_color "$WHITE" "URL: ${script_url}"
    print_color "$RED" "This script is not maintained by eXtensibleSH team."
    
    read -p "Review the script first? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        print_color "$YELLOW" "${INFO} Opening script for review..."
        curl -s "$script_url" | less
    fi
    
    read -p "Continue with execution? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_color "$YELLOW" "${ROCKET} Executing third-party script..."
        curl -s "$script_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"
    else
        print_color "$YELLOW" "${INFO} Execution cancelled"
        return 1
    fi
}

# Function to display interactive menu
show_menu() {
    while true; do
        clear
        print_header "eXtensibleSH - Plugin-Based Self-Hosting Made Easy"
        
        print_color "$GREEN" "${CHECKMARK} OS: ${WHITE}${OS}${NC} (${OS_GROUP})"
        print_color "$GREEN" "${CHECKMARK} User: ${WHITE}${USER}${NC} ($([ "$USE_SUDO" = "true" ] && echo "sudo enabled" || echo "root"))"
        print_color "$GREEN" "${CHECKMARK} Log: ${WHITE}${LOG_FILE}${NC}"
        
        print_section "Main Menu"
        print_color "$WHITE" "1. ${GEAR} Show Available Plugins"
        print_color "$WHITE" "2. ${STAR} Show Third-Party Scripts"
        print_color "$WHITE" "3. ${ROCKET} Run Plugin"
        print_color "$WHITE" "4. ${ROCKET} Run Third-Party Script"
        print_color "$WHITE" "5. ${INFO} System Information"
        print_color "$WHITE" "6. ${CROSS} Exit"
        
        print_footer
        
        read -p "Select an option (1-6): " -n 1 -r
        echo
        
        case $REPLY in
            1)
                clear
                print_header "Available Plugins"
                display_plugins
                read -p "Press Enter to continue..." -r
                ;;
            2)
                clear
                print_header "Third-Party Scripts"
                display_thirdparty
                read -p "Press Enter to continue..." -r
                ;;
            3)
                clear
                print_header "Run Plugin"
                read -p "Enter plugin name: " plugin_name
                read -p "Enter category (or leave empty for auto-detect): " category
                if [ -n "$plugin_name" ]; then
                    run_plugin "$plugin_name" "$category"
                    read -p "Press Enter to continue..." -r
                fi
                ;;
            4)
                clear
                print_header "Run Third-Party Script"
                read -p "Enter script name: " script_name
                if [ -n "$script_name" ]; then
                    run_thirdparty "$script_name"
                    read -p "Press Enter to continue..." -r
                fi
                ;;
            5)
                clear
                print_header "System Information"
                print_color "$WHITE" "OS: ${OS} (${OS_GROUP})"
                print_color "$WHITE" "Version: ${VER}"
                print_color "$WHITE" "User: ${USER}"
                print_color "$WHITE" "Sudo: $([ "$USE_SUDO" = "true" ] && echo "Available" || echo "Not needed (root)")"
                print_color "$WHITE" "Log File: ${LOG_FILE}"
                print_color "$WHITE" "Script Version: ${SCRIPT_VERSION}"
                print_color "$WHITE" "Repository: https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
                read -p "Press Enter to continue..." -r
                ;;
            6)
                print_color "$GREEN" "${CHECKMARK} Thank you for using eXtensibleSH!"
                exit 0
                ;;
            *)
                print_color "$RED" "${CROSS} Invalid option. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Main function
main() {
    # Initialize
    print_header "eXtensibleSH v${SCRIPT_VERSION} - Initializing"
    
    # Set up logging
    setup_logging
    
    # Detect OS
    detect_os
    
    # Detect if running as root
    if [ "$EUID" -eq 0 ]; then
        USE_SUDO="false"
        print_color "$GREEN" "${CHECKMARK} Running as root; no sudo needed"
    else
        USE_SUDO="true"
        print_color "$GREEN" "${CHECKMARK} Running as user; will use sudo for privileged commands"
        # Check if sudo is available
        if ! command -v sudo >/dev/null 2>&1; then
            print_color "$RED" "${CROSS} sudo is required for non-root execution but not found"
            exit 1
        fi
    fi
    
    # Load plugins and third-party scripts
    if ! load_plugins; then
        exit 1
    fi
    load_thirdparty
    
    # Handle command line arguments
    if [ $# -eq 0 ]; then
        # Interactive mode
        show_menu
    else
        # Direct execution mode
        plugin_name="$1"
        category="${2:-}"
        
        # Check if it's a third-party script
        if grep -q "^${plugin_name}:" <<< "$THIRDPARTY_LIST" 2>/dev/null; then
            print_color "$YELLOW" "${INFO} Found third-party script: ${plugin_name}"
            run_thirdparty "$plugin_name"
        else
            # Try to run as plugin
            run_plugin "$plugin_name" "$category"
        fi
    fi
    
    print_color "$GREEN" "${CHECKMARK} eXtensibleSH completed at $(date)"
    print_footer
}

# Script entry point
main "$@"
