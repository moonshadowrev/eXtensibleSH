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

# Global arrays for plugin selection
declare -a AVAILABLE_PLUGINS=()
declare -a AVAILABLE_THIRDPARTY=()

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
    
    # Build available plugins array for interactive selection
    build_plugin_arrays
    
    print_color "$GREEN" "${CHECKMARK} Plugin registry loaded successfully"
    return 0
}

# Function to build plugin arrays for interactive selection
build_plugin_arrays() {
    AVAILABLE_PLUGINS=()
    
    # Categories to scan
    local categories=("webservers" "databases" "containerization" "monitoring" "security" "storage")
    
    # Scan new plugin structure
    for category in "${categories[@]}"; do
        if [ -d "plugins/${category}" ]; then
            for plugin_dir in plugins/${category}/*/; do
                if [ -d "$plugin_dir" ]; then
                    local plugin_name=$(basename "$plugin_dir")
                    local metadata=$(get_plugin_metadata "$plugin_name" "$category")
                    local display_name=$(echo "$metadata" | jq -r '.display_name // .name // "Unknown"' 2>/dev/null || echo "$plugin_name")
                    local description=$(echo "$metadata" | jq -r '.description // "No description available"' 2>/dev/null || echo "No description available")
                    
                    # Check compatibility
                    local compatible="false"
                    local status_icon=""
                    if plugin_exists "$plugin_name" "$category" "$OS_GROUP"; then
                        compatible="true"
                        status_icon="${GREEN}${CHECKMARK}${NC}"
                    elif plugin_exists "$plugin_name" "$category" "generic"; then
                        compatible="generic"
                        status_icon="${YELLOW}${WARNING}${NC}"
                    else
                        status_icon="${RED}${CROSS}${NC}"
                    fi
                    
                    AVAILABLE_PLUGINS+=("${plugin_name}|${category}|${display_name}|${description}|${compatible}|${status_icon}")
                fi
            done
        fi
    done
    
    # Add legacy plugins if available
    if [ -n "${PLUGIN_LIST:-}" ]; then
        while IFS= read -r line; do
            if [[ "$line" == *":"* ]]; then
                local plugin=$(echo "$line" | cut -d':' -f1)
                local supported=$(echo "$line" | cut -d':' -f2)
                local compatible="false"
                local status_icon=""
                
                if [[ "$supported" == *"$OS_GROUP"* ]]; then
                    compatible="true"
                    status_icon="${GREEN}${CHECKMARK}${NC}"
                elif plugin_exists_legacy "$plugin" "generic"; then
                    compatible="generic"
                    status_icon="${YELLOW}${WARNING}${NC}"
                else
                    status_icon="${RED}${CROSS}${NC}"
                fi
                
                AVAILABLE_PLUGINS+=("${plugin}|legacy|${plugin}|Legacy plugin (${supported})|${compatible}|${status_icon}")
            fi
        done <<< "$PLUGIN_LIST"
    fi
}

# Function to build third-party arrays
build_thirdparty_arrays() {
    AVAILABLE_THIRDPARTY=()
    
    if [ -n "${THIRDPARTY_LIST:-}" ]; then
                while read -r line; do
            if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
                continue
            fi
            
            # Parse name:category:url:description more carefully
            # Extract name (everything before first colon)
            local name="${line%%:*}"
            local rest="${line#*:}"
            
            # Extract category (everything before second colon)
            local category="${rest%%:*}"
            local url_part="${rest#*:}"
            
            # Extract URL (everything before last colon that contains description)
            local url=""
            local description=""
            
            if [[ "$url_part" =~ ^(https?://[^:]+):(.*)$ ]]; then
                # URL doesn't have additional colons
                url="${BASH_REMATCH[1]}"
                description="${BASH_REMATCH[2]}"
            elif [[ "$url_part" =~ ^(https?://.*):([^/:]*)$ ]]; then
                # URL might have path with colons, description is the last part after final colon
                url="${BASH_REMATCH[1]}"
                description="${BASH_REMATCH[2]}"
            else
                # Fallback: assume no description
                url="$url_part"
                description=""
            fi
            
            AVAILABLE_THIRDPARTY+=("${name}|${category}|${url}|${description}")
        done <<< "$THIRDPARTY_LIST"
    fi
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
    
    # Build third-party array for interactive selection
    build_thirdparty_arrays
    
    print_color "$GREEN" "${CHECKMARK} Third-party scripts loaded successfully"
    return 0
}

# Function for interactive plugin selection
interactive_plugin_selection() {
    local allow_multiple="${1:-false}"
    
    if [ ${#AVAILABLE_PLUGINS[@]} -eq 0 ]; then
        print_color "$RED" "${CROSS} No plugins available"
        return 1
    fi
    
    print_section "Select Plugin$([ "$allow_multiple" = "true" ] && echo "s" || echo "")"
    
    # Display available plugins with numbers
    local index=1
    for plugin_entry in "${AVAILABLE_PLUGINS[@]}"; do
        IFS='|' read -r plugin_name category display_name description compatible status_icon <<< "$plugin_entry"
        print_color "$WHITE" "${index}. ${status_icon} ${display_name}"
        print_color "$GRAY" "   ${description}"
        print_color "$GRAY" "   Category: ${category} | Compatibility: ${compatible}"
        echo
        ((index++))
    done
    
    echo
    if [ "$allow_multiple" = "true" ]; then
        print_color "$YELLOW" "${INFO} Enter plugin numbers separated by spaces (e.g., 1 3 5) or 'all' for all compatible:"
    else
        print_color "$YELLOW" "${INFO} Enter plugin number (1-$((index-1))):"
    fi
    
    read -p "Selection: " -r selection
    
    # Handle empty selection
    if [ -z "$selection" ]; then
        print_color "$YELLOW" "${INFO} No selection made"
        return 0
    fi
    
    # Handle selection
    local selected_plugins=()
    
    if [ "$allow_multiple" = "true" ] && [ "$selection" = "all" ]; then
        # Select all compatible plugins
        for plugin_entry in "${AVAILABLE_PLUGINS[@]}"; do
            IFS='|' read -r plugin_name category display_name description compatible status_icon <<< "$plugin_entry"
            if [ "$compatible" = "true" ] || [ "$compatible" = "generic" ]; then
                selected_plugins+=("$plugin_entry")
            fi
        done
    else
        # Parse individual selections
        for num in $selection; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#AVAILABLE_PLUGINS[@]} ]; then
                selected_plugins+=("${AVAILABLE_PLUGINS[$((num-1))]}")
            else
                print_color "$RED" "${CROSS} Invalid selection: $num"
                return 1
            fi
        done
    fi
    
    # Check if any plugins were selected
    if [ ${#selected_plugins[@]} -eq 0 ]; then
        print_color "$YELLOW" "${INFO} No valid plugins selected"
        return 0
    fi
    
    # Execute selected plugins
    for plugin_entry in "${selected_plugins[@]}"; do
        IFS='|' read -r plugin_name category display_name description compatible status_icon <<< "$plugin_entry"
        echo
        print_color "$CYAN" "$(printf '─%.0s' {1..80})"
        print_color "$CYAN" "Installing: ${display_name}"
        print_color "$CYAN" "$(printf '─%.0s' {1..80})"
        
        if [ "$compatible" = "false" ]; then
            print_color "$RED" "${WARNING} Plugin not compatible with ${OS_GROUP}. Skipping..."
            continue
        fi
        
        run_plugin "$plugin_name" "$category"
        
        print_color "$GREEN" "${CHECKMARK} Completed: ${display_name}"
    done
    
    return 0
}

# Function for interactive third-party selection
interactive_thirdparty_selection() {
    local allow_multiple="${1:-false}"
    
    if [ ${#AVAILABLE_THIRDPARTY[@]} -eq 0 ]; then
        print_color "$RED" "${CROSS} No third-party scripts available"
        return 1
    fi
    
    print_section "Select Third-Party Script$([ "$allow_multiple" = "true" ] && echo "s" || echo "")"
    
    print_color "$RED" "${WARNING} Third-party scripts are not officially maintained!"
    print_color "$RED" "    Always review scripts before execution!"
    echo
    
    # Display available scripts with numbers
    local index=1
    for script_entry in "${AVAILABLE_THIRDPARTY[@]}"; do
        IFS='|' read -r name category url description <<< "$script_entry"
        print_color "$WHITE" "${index}. ${STAR} ${name}"
        print_color "$GRAY" "   ${description}"
        print_color "$GRAY" "   Category: ${category} | URL: ${url}"
        echo
        ((index++))
    done
    
    echo
    if [ "$allow_multiple" = "true" ]; then
        print_color "$YELLOW" "${INFO} Enter script numbers separated by spaces (e.g., 1 3 5):"
    else
        print_color "$YELLOW" "${INFO} Enter script number (1-$((index-1))):"
    fi
    
    read -p "Selection: " -r selection
    
    # Handle empty selection
    if [ -z "$selection" ]; then
        print_color "$YELLOW" "${INFO} No selection made"
        return 0
    fi
    
    # Handle selection
    local selected_scripts=()
    
    # Parse individual selections
    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#AVAILABLE_THIRDPARTY[@]} ]; then
            selected_scripts+=("${AVAILABLE_THIRDPARTY[$((num-1))]}")
        else
            print_color "$RED" "${CROSS} Invalid selection: $num"
            return 1
        fi
    done
    
    # Check if any scripts were selected
    if [ ${#selected_scripts[@]} -eq 0 ]; then
        print_color "$YELLOW" "${INFO} No valid scripts selected"
        return 0
    fi
    
    # Execute selected scripts
    for script_entry in "${selected_scripts[@]}"; do
        IFS='|' read -r name category url description <<< "$script_entry"
        echo
        print_color "$CYAN" "$(printf '─%.0s' {1..80})"
        print_color "$CYAN" "Installing: ${name}"
        print_color "$CYAN" "$(printf '─%.0s' {1..80})"
        
        run_thirdparty "$name"
        
        print_color "$GREEN" "${CHECKMARK} Completed: ${name}"
    done
    
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
        
        print_color "$MAGENTA" "${icon} $(echo "$category" | tr '[:lower:]' '[:upper:]'):"
        
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
    if [ -n "${PLUGIN_LIST:-}" ]; then
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
            
            print_color "$MAGENTA" "${icon} $(echo "$category" | tr '[:lower:]' '[:upper:]'):"
            
                        while read -r line; do
                if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
                    continue
                fi
                
                # Parse name:category:url:description more carefully
                # Extract name (everything before first colon)
                local name="${line%%:*}"
                local rest="${line#*:}"
                
                # Extract category (everything before second colon)
                local cat_name="${rest%%:*}"
                local url_part="${rest#*:}"
                
                # Extract URL (everything before last colon that contains description)
                local url=""
                local description=""
                
                if [[ "$url_part" =~ ^(https?://[^:]+):(.*)$ ]]; then
                    # URL doesn't have additional colons
                    url="${BASH_REMATCH[1]}"
                    description="${BASH_REMATCH[2]}"
                elif [[ "$url_part" =~ ^(https?://.*):([^/:]*)$ ]]; then
                    # URL might have path with colons, description is the last part after final colon
                    url="${BASH_REMATCH[1]}"
                    description="${BASH_REMATCH[2]}"
                else
                    # Fallback: assume no description
                    url="$url_part"
                    description=""
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
        local plugin_url="${BASE_URL}/plugins/${category}/${plugin}/${OS_GROUP}/${version}.sh"
        print_color "$GRAY" "Downloading from: ${plugin_url}"
        if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
            print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
        else
            local exit_code=$?
            print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
            print_color "$YELLOW" "${WARNING} This could be due to:"
            print_color "$WHITE" "  1. Network connectivity issues"
            print_color "$WHITE" "  2. Plugin server unavailable"
            print_color "$WHITE" "  3. Plugin execution errors"
            print_color "$WHITE" "  4. Permission issues"
            print_color "$WHITE" "  5. Missing dependencies"
            return 1
        fi
    elif [ -n "$category" ] && plugin_exists "$plugin" "$category" "generic" "$version"; then
        print_color "$YELLOW" "${WARNING} No OS-specific plugin found. Loading generic version."
        local plugin_url="${BASE_URL}/plugins/${category}/${plugin}/generic/${version}.sh"
        print_color "$GRAY" "Downloading from: ${plugin_url}"
        if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
            print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
        else
            local exit_code=$?
            print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
            print_color "$YELLOW" "${WARNING} This could be due to:"
            print_color "$WHITE" "  1. Network connectivity issues"
            print_color "$WHITE" "  2. Plugin server unavailable"
            print_color "$WHITE" "  3. Plugin execution errors"
            print_color "$WHITE" "  4. Permission issues"
            print_color "$WHITE" "  5. Missing dependencies"
            return 1
        fi
    # Fallback to legacy structure
    elif plugin_exists_legacy "$plugin" "$OS_GROUP"; then
        print_color "$GREEN" "${CHECKMARK} Loading legacy plugin for ${OS_GROUP}"
        local plugin_url="${BASE_URL}/plugins/${plugin}/${OS_GROUP}.sh"
        print_color "$GRAY" "Downloading from: ${plugin_url}"
        if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
            print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
        else
            local exit_code=$?
            print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
            print_color "$YELLOW" "${WARNING} This could be due to:"
            print_color "$WHITE" "  1. Network connectivity issues"
            print_color "$WHITE" "  2. Plugin server unavailable"
            print_color "$WHITE" "  3. Plugin execution errors"
            print_color "$WHITE" "  4. Permission issues"
            print_color "$WHITE" "  5. Missing dependencies"
            return 1
        fi
    elif plugin_exists_legacy "$plugin" "generic"; then
        print_color "$YELLOW" "${WARNING} Loading legacy generic plugin"
        local plugin_url="${BASE_URL}/plugins/${plugin}/generic.sh"
        print_color "$GRAY" "Downloading from: ${plugin_url}"
        if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
            print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
        else
            local exit_code=$?
            print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
            print_color "$YELLOW" "${WARNING} This could be due to:"
            print_color "$WHITE" "  1. Network connectivity issues"
            print_color "$WHITE" "  2. Plugin server unavailable"
            print_color "$WHITE" "  3. Plugin execution errors"
            print_color "$WHITE" "  4. Permission issues"
            print_color "$WHITE" "  5. Missing dependencies"
            return 1
        fi
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
                local plugin_url="${BASE_URL}/plugins/${category}/${plugin}/${forced_os}/${version}.sh"
                print_color "$GRAY" "Downloading from: ${plugin_url}"
                if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
                    print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
                else
                    local exit_code=$?
                    print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
                    return 1
                fi
            elif plugin_exists_legacy "$plugin" "$forced_os"; then
                print_color "$YELLOW" "${WARNING} Force loading legacy plugin from ${forced_os}"
                local plugin_url="${BASE_URL}/plugins/${plugin}/${forced_os}.sh"
                print_color "$GRAY" "Downloading from: ${plugin_url}"
                if curl -fsSL "$plugin_url" | bash -s -- --log="$LOG_FILE" --use-sudo="$USE_SUDO"; then
                    print_color "$GREEN" "${CHECKMARK} Plugin executed successfully"
                else
                    local exit_code=$?
                    print_color "$RED" "${CROSS} Plugin execution failed (exit code: $exit_code)"
                    return 1
                fi
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
    local script_description=""
    
        # Find the script URL with proper parsing
    while read -r line; do
        if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
            continue
        fi
        
        # Parse name:category:url:description more carefully
        # Extract name (everything before first colon)
        local name="${line%%:*}"
        local rest="${line#*:}"
        
        # Extract category (everything before second colon)
        local category="${rest%%:*}"
        local url_part="${rest#*:}"
        
        # Extract URL (everything before last colon that contains description)
        # For lines like: name:category:https://example.com:description
        # We need to find where URL ends and description starts
        local url=""
        local description=""
        
        if [[ "$url_part" =~ ^(https?://[^:]+):(.*)$ ]]; then
            # URL doesn't have additional colons
            url="${BASH_REMATCH[1]}"
            description="${BASH_REMATCH[2]}"
        elif [[ "$url_part" =~ ^(https?://.*):([^/:]*)$ ]]; then
            # URL might have path with colons, description is the last part after final colon
            url="${BASH_REMATCH[1]}"
            description="${BASH_REMATCH[2]}"
        else
            # Fallback: assume no description
            url="$url_part"
            description=""
        fi
        
        if [[ "$name" == "$script_name" ]]; then
            script_url="$url"
            script_description="$description"
            break
        fi
    done <<< "$THIRDPARTY_LIST"
    
    if [ -z "$script_url" ]; then
        print_color "$RED" "${CROSS} Third-party script not found: ${script_name}"
        return 1
    fi
    
    # Validate URL format
    if [[ ! "$script_url" =~ ^https?:// ]]; then
        print_color "$RED" "${CROSS} Invalid URL format: ${script_url}"
        print_color "$YELLOW" "${WARNING} URL parsing may have failed. Please check the third-party list format."
        return 1
    fi
    
    print_color "$YELLOW" "${ROCKET} Executing third-party script: ${script_name}"
    print_color "$WHITE" "Description: ${script_description:-No description}"
    print_color "$RED" "${WARNING} This script is not maintained by eXtensibleSH team."
    print_color "$GRAY" "Downloading from: ${script_url}"
    
    # Execute the script with proper error handling
    if curl -fsSL "$script_url" | bash; then
        print_color "$GREEN" "${CHECKMARK} Script executed successfully"
    else
        local exit_code=$?
        print_color "$RED" "${CROSS} Script execution failed (exit code: $exit_code)"
        print_color "$YELLOW" "${WARNING} This could be due to:"
        print_color "$WHITE" "  1. Network connectivity issues"
        print_color "$WHITE" "  2. Script server unavailable"
        print_color "$WHITE" "  3. Script execution errors"
        print_color "$WHITE" "  4. Permission issues"
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
        print_color "$WHITE" "3. ${ROCKET} Install Single Plugin"
        print_color "$WHITE" "4. ${ROCKET} Install Multiple Plugins"
        print_color "$WHITE" "5. ${STAR} Install Single Third-Party Script"
        print_color "$WHITE" "6. ${STAR} Install Multiple Third-Party Scripts"
        print_color "$WHITE" "7. ${INFO} System Information"
        print_color "$WHITE" "8. ${CROSS} Exit"
        
        print_footer
        
        read -p "Select an option (1-8): " -n 1 -r
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
                print_header "Install Single Plugin"
                interactive_plugin_selection false
                read -p "Press Enter to continue..." -r
                ;;
            4)
                clear
                print_header "Install Multiple Plugins"
                interactive_plugin_selection true
                read -p "Press Enter to continue..." -r
                ;;
            5)
                clear
                print_header "Install Single Third-Party Script"
                interactive_thirdparty_selection false
                read -p "Press Enter to continue..." -r
                ;;
            6)
                clear
                print_header "Install Multiple Third-Party Scripts"
                interactive_thirdparty_selection true
                read -p "Press Enter to continue..." -r
                ;;
            7)
                clear
                print_header "System Information"
                print_color "$WHITE" "OS: ${OS} (${OS_GROUP})"
                print_color "$WHITE" "Version: ${VER}"
                print_color "$WHITE" "User: ${USER}"
                print_color "$WHITE" "Sudo: $([ "$USE_SUDO" = "true" ] && echo "Available" || echo "Not needed (root)")"
                print_color "$WHITE" "Log File: ${LOG_FILE}"
                print_color "$WHITE" "Script Version: ${SCRIPT_VERSION}"
                print_color "$WHITE" "Repository: https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
                print_color "$WHITE" "Available Plugins: ${#AVAILABLE_PLUGINS[@]}"
                print_color "$WHITE" "Available Third-Party Scripts: ${#AVAILABLE_THIRDPARTY[@]}"
                read -p "Press Enter to continue..." -r
                ;;
            8)
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
