#!/bin/bash

# eXtensibleSH Plugin Development Tool
# Description: Creates plugin structure with metadata and OS-specific scripts
# Author: moonshadowrev
# Version: 1.0.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Unicode symbols
SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"
PLUGIN="🔌"
GEAR="⚙️"
FOLDER="📁"
FILE="📄"

echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}║                    eXtensibleSH Plugin Development Tool                        ║${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to display error and exit
error_exit() {
    echo -e "${RED}${ERROR} Error: $1${NC}" >&2
    exit 1
}

# Function to display success message
success_msg() {
    echo -e "${GREEN}${SUCCESS} $1${NC}"
}

# Function to display warning message
warn_msg() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

# Function to display info message
info_msg() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

# Function to validate plugin name
validate_plugin_name() {
    local name=$1
    if [[ ! "$name" =~ ^[a-z][a-z0-9_-]*$ ]]; then
        error_exit "Plugin name must start with a letter and contain only lowercase letters, numbers, hyphens, and underscores"
    fi
    
    if [ ${#name} -lt 2 ] || [ ${#name} -gt 30 ]; then
        error_exit "Plugin name must be between 2 and 30 characters"
    fi
    
    # Check if plugin already exists
    if [ -d "plugins/$2/$name" ]; then
        error_exit "Plugin '$name' already exists in category '$2'"
    fi
}

# Function to get user input
get_user_input() {
    echo -e "${PURPLE}${GEAR} Plugin Configuration${NC}"
    echo ""
    
    # Get plugin name
    while true; do
        echo -n "Enter plugin name (lowercase, letters/numbers/hyphens/underscores): "
        read -r PLUGIN_NAME
        
        if [ -z "$PLUGIN_NAME" ]; then
            warn_msg "Plugin name cannot be empty"
            continue
        fi
        
        # Validate plugin name format first
        if [[ ! "$PLUGIN_NAME" =~ ^[a-z][a-z0-9_-]*$ ]]; then
            warn_msg "Plugin name must start with a letter and contain only lowercase letters, numbers, hyphens, and underscores"
            continue
        fi
        
        if [ ${#PLUGIN_NAME} -lt 2 ] || [ ${#PLUGIN_NAME} -gt 30 ]; then
            warn_msg "Plugin name must be between 2 and 30 characters"
            continue
        fi
        
        break
    done
    
    # Get category
    echo ""
    echo "Available categories:"
    echo "  1. webservers    - Web servers and reverse proxies"
    echo "  2. databases     - SQL and NoSQL database systems"
    echo "  3. containerization - Container platforms and orchestration"
    echo "  4. monitoring    - Monitoring and observability tools"
    echo "  5. security      - Security tools and configurations"
    echo "  6. storage       - Storage solutions and file systems"
    echo "  7. development   - Development tools and environments"
    echo "  8. networking    - Network tools and configurations"
    echo "  9. backup        - Backup and recovery solutions"
    echo "  10. custom       - Enter custom category"
    echo ""
    
    while true; do
        echo -n "Select category (1-10): "
        read -r CATEGORY_CHOICE
        
        case $CATEGORY_CHOICE in
            1) CATEGORY="webservers"; break ;;
            2) CATEGORY="databases"; break ;;
            3) CATEGORY="containerization"; break ;;
            4) CATEGORY="monitoring"; break ;;
            5) CATEGORY="security"; break ;;
            6) CATEGORY="storage"; break ;;
            7) CATEGORY="development"; break ;;
            8) CATEGORY="networking"; break ;;
            9) CATEGORY="backup"; break ;;
            10) 
                echo -n "Enter custom category name: "
                read -r CATEGORY
                if [ -z "$CATEGORY" ]; then
                    warn_msg "Category cannot be empty"
                    continue
                fi
                break
                ;;
            *) warn_msg "Invalid choice. Please select 1-10." ;;
        esac
    done
    
    # Now validate with category
    validate_plugin_name "$PLUGIN_NAME" "$CATEGORY"
    
    # Get display name
    echo ""
    echo -n "Enter display name (e.g., 'NGINX Web Server'): "
    read -r DISPLAY_NAME
    if [ -z "$DISPLAY_NAME" ]; then
        DISPLAY_NAME="$PLUGIN_NAME"
    fi
    
    # Get description
    echo ""
    echo -n "Enter plugin description: "
    read -r DESCRIPTION
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="Plugin for $PLUGIN_NAME"
    fi
    
    # Get author name
    echo ""
    echo -n "Enter author name (or press Enter for 'Anonymous'): "
    read -r AUTHOR
    if [ -z "$AUTHOR" ]; then
        AUTHOR="Anonymous"
    fi
    
    # Get supported OS
    echo ""
    echo "Supported operating systems:"
    echo "  1. debian (Ubuntu, Debian, Mint, etc.)"
    echo "  2. rhel (CentOS, RHEL, Fedora, etc.)"
    echo "  3. arch (Arch Linux, Manjaro, etc.)"
    echo "  4. generic (All Linux distributions)"
    echo "  5. multiple (Select multiple OS)"
    echo ""
    
    while true; do
        echo -n "Select OS support (1-5): "
        read -r OS_CHOICE
        
        case $OS_CHOICE in
            1) SUPPORTED_OS="debian"; break ;;
            2) SUPPORTED_OS="rhel"; break ;;
            3) SUPPORTED_OS="arch"; break ;;
            4) SUPPORTED_OS="generic"; break ;;
            5) 
                echo "Select multiple OS (separate with spaces):"
                echo "Available: debian rhel arch generic"
                echo -n "Enter OS list: "
                read -r SUPPORTED_OS
                break
                ;;
            *) warn_msg "Invalid choice. Please select 1-5." ;;
        esac
    done
    
    # Get installation time estimate
    echo ""
    echo -n "Estimated installation time (e.g., '2-5 minutes'): "
    read -r INSTALL_TIME
    if [ -z "$INSTALL_TIME" ]; then
        INSTALL_TIME="5-10 minutes"
    fi
}

# Function to create directory structure
create_directory_structure() {
    local base_dir="plugins/$CATEGORY/$PLUGIN_NAME"
    
    info_msg "Creating directory structure..."
    
    # Create base directory
    mkdir -p "$base_dir"
    success_msg "Created: $base_dir"
    
    # Create OS-specific directories
    for os in $SUPPORTED_OS; do
        mkdir -p "$base_dir/$os"
        success_msg "Created: $base_dir/$os"
    done
}

# Function to create metadata.json
create_metadata() {
    local base_dir="plugins/$CATEGORY/$PLUGIN_NAME"
    local metadata_file="$base_dir/metadata.json"
    
    info_msg "Creating metadata.json..."
    
    # Convert supported OS to JSON format
    local os_json=""
    for os in $SUPPORTED_OS; do
        if [ "$os" = "generic" ]; then
            os_json+='"generic": {
      "versions": ["latest"],
      "package_manager": "auto-detect",,
      "service_manager": "auto-detect"
    },'
        elif [ "$os" = "debian" ]; then
            os_json+='"debian": {
      "versions": ["latest", "20.04", "18.04", "11", "10"],,
      "package_manager": "apt",,
      "service_manager": "systemd"
    },'
        elif [ "$os" = "rhel" ]; then
            os_json+='"rhel": {
      "versions": ["latest", "8", "7"],,
      "package_manager": "yum",,
      "service_manager": "systemd"
    },'
        elif [ "$os" = "arch" ]; then
            os_json+='"arch": {
      "versions": ["latest"],
      "package_manager": "pacman",,
      "service_manager": "systemd"
    },'
        fi
    done
    
    # Remove trailing comma
    os_json=$(echo "$os_json" | sed 's/,$//')
    
    # Create metadata.json
    cat > "$metadata_file" << EOF
{
  "name": "$PLUGIN_NAME",
  "display_name": "$DISPLAY_NAME",
  "description": "$DESCRIPTION",
  "category": "$CATEGORY",
  "version": "1.0.0",
  "author": "$AUTHOR",
  "license": "GPLv3",
  "tags": ["$PLUGIN_NAME", "$CATEGORY"],
  "features": [
    "Replace with actual features",
    "Add more features as needed"
  ],
  "supported_os": {
    $os_json
  },
  "server_profiles": [
    {
      "name": "low-end",
      "description": "Low end server configuration (1 vCPU + 4GB RAM)"
    },
    {
      "name": "mid-level",
      "description": "Mid level server configuration (4 vCPU + 16GB RAM)"
    },
    {
      "name": "high-level",
      "description": "High level server configuration (8+ vCPU + 32GB+ RAM)"
    }
  ],
  "dependencies": [],
  "conflicts": [],
  "installation_time": "$INSTALL_TIME",
  "documentation": "https://github.com/moonshadowrev/eXtensibleSH/blob/main/docs/how-to-create-plugin.md",
  "support_url": "https://github.com/moonshadowrev/eXtensibleSH/issues",
  "changelog": [
    {
      "version": "1.0.0",
      "date": "$(date +%Y-%m-%d)",
      "changes": [
        "Initial release",
        "Basic functionality implemented"
      ]
    }
  ]
}
EOF
    
    success_msg "Created: $metadata_file"
}

# Function to create OS-specific scripts
create_os_scripts() {
    local base_dir="plugins/$CATEGORY/$PLUGIN_NAME"
    
    info_msg "Creating OS-specific scripts..."
    
    for os in $SUPPORTED_OS; do
        local script_file="$base_dir/$os/latest.sh"
        
        # Create script based on OS
        cat > "$script_file" << EOF
#!/bin/bash

# $DISPLAY_NAME Plugin for eXtensibleSH
# OS: $os
# Description: $DESCRIPTION

# Parse arguments
while getopts ":l:s:" opt; do
  case \$opt in
    l) LOG_FILE="\$OPTARG" ;;
    s) USE_SUDO="\$OPTARG" ;;
    \\?) echo "Invalid option: -\$OPTARG" >&2; exit 1 ;;
  esac
done

# Set command prefix
if [ "\$USE_SUDO" = "true" ]; then
    PREFIX="sudo "
else
    PREFIX=""
fi

# Redirect output to log file
exec >> "\$LOG_FILE" 2>&1
echo "$DISPLAY_NAME plugin for $os started at \$(date)"

# Error handling
set -euo pipefail
trap 'echo "Error in $PLUGIN_NAME plugin at line \$LINENO"; exit 1' ERR

# TODO: Add your plugin logic here
echo "TODO: Implement $PLUGIN_NAME installation and configuration"

# Example: Check if software is already installed
# if ! command -v your_software >/dev/null 2>&1; then
#   echo "Installing $PLUGIN_NAME..."
#   # Add installation commands based on OS
EOF

        # Add OS-specific installation examples
        if [ "$os" = "debian" ]; then
            cat >> "$script_file" << 'EOF'
#   ${PREFIX}apt update -y
#   ${PREFIX}apt install -y your_software
EOF
        elif [ "$os" = "rhel" ]; then
            cat >> "$script_file" << 'EOF'
#   ${PREFIX}yum install -y your_software || ${PREFIX}dnf install -y your_software
EOF
        elif [ "$os" = "arch" ]; then
            cat >> "$script_file" << 'EOF'
#   ${PREFIX}pacman -Syu --noconfirm your_software
EOF
        else
            cat >> "$script_file" << 'EOF'
#   # Add generic installation commands
#   # or detect package manager and install accordingly
EOF
        fi
        
        cat >> "$script_file" << 'EOF'
# fi

# Interactive server profile selection
echo "Choose your server profile:"
select profile in "Low end server (1 vCPU + 4GB RAM)" "Mid level (4 vCPU + 16GB RAM)" "High level (8+ vCPU + 32GB+ RAM)"; do
  case $profile in
    "Low end server (1 vCPU + 4GB RAM)")
      echo "Configuring for low-end server..."
      # TODO: Add low-end server configuration
      break
      ;;
    "Mid level (4 vCPU + 16GB RAM)")
      echo "Configuring for mid-level server..."
      # TODO: Add mid-level server configuration
      break
      ;;
    "High level (8+ vCPU + 32GB+ RAM)")
      echo "Configuring for high-level server..."
      # TODO: Add high-level server configuration
      break
      ;;
    *) echo "Invalid selection" ;;
  esac
done

# TODO: Add service configuration, firewall rules, etc.

# Start and enable service (if applicable)
# ${PREFIX}systemctl enable your_service
# ${PREFIX}systemctl start your_service

echo "Configuration completed successfully!"
echo "$DISPLAY_NAME plugin completed at $(date)"
EOF
        
        chmod +x "$script_file"
        success_msg "Created: $script_file"
    done
}

# Function to update plugins list
update_plugins_list() {
    local plugins_list="plugins/list.txt"
    local os_list=$(echo "$SUPPORTED_OS" | tr ' ' ',')
    
    info_msg "Updating plugins list..."
    
    # Add entry to plugins list
    echo "$PLUGIN_NAME:$CATEGORY:$os_list" >> "$plugins_list"
    
    # Sort the list (excluding header)
    (head -n 3 "$plugins_list"; tail -n +4 "$plugins_list" | sort) > "$plugins_list.tmp"
    mv "$plugins_list.tmp" "$plugins_list"
    
    success_msg "Updated: $plugins_list"
}

# Function to create README for the plugin
create_plugin_readme() {
    local base_dir="plugins/$CATEGORY/$PLUGIN_NAME"
    local readme_file="$base_dir/README.md"
    
    info_msg "Creating plugin README..."
    
    cat > "$readme_file" << EOF
# $DISPLAY_NAME

$DESCRIPTION

## Features

- Replace with actual features
- Add more features as needed

## Supported Operating Systems

EOF
    
    for os in $SUPPORTED_OS; do
        echo "- $os" >> "$readme_file"
    done
    
    cat >> "$readme_file" << EOF

## Installation

### Interactive Installation
\`\`\`bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
\`\`\`

### Direct Installation
\`\`\`bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s $PLUGIN_NAME $CATEGORY
\`\`\`

## Configuration

This plugin provides three server profiles:

1. **Low-end**: Optimized for servers with 1 vCPU + 4GB RAM
2. **Mid-level**: Optimized for servers with 4 vCPU + 16GB RAM  
3. **High-level**: Optimized for servers with 8+ vCPU + 32GB+ RAM

## Development

To modify this plugin:

1. Update the OS-specific scripts in the respective directories
2. Update \`metadata.json\` with any changes
3. Test on all supported operating systems
4. Update this README with new features or changes

## Support

For issues and feature requests, please visit:
https://github.com/moonshadowrev/eXtensibleSH/issues

## License

This plugin is licensed under the GNU General Public License v3.0.
EOF
    
    success_msg "Created: $readme_file"
}

# Function to display next steps
display_next_steps() {
    echo ""
    echo -e "${GREEN}${ROCKET} Plugin '$PLUGIN_NAME' created successfully!${NC}"
    echo ""
    echo -e "${YELLOW}${GEAR} Next Steps:${NC}"
    echo ""
    echo "1. ${FILE} Edit the OS-specific scripts in:"
    for os in $SUPPORTED_OS; do
        echo "   - plugins/$CATEGORY/$PLUGIN_NAME/$os/latest.sh"
    done
    echo ""
    echo "2. ${FILE} Update metadata.json with:"
    echo "   - Actual features list"
    echo "   - Dependencies and conflicts"
    echo "   - Proper tags"
    echo ""
    echo "3. ${GEAR} Test your plugin:"
    echo "   - Test on all supported OS distributions"
    echo "   - Test all server profiles"
    echo "   - Test error handling"
    echo ""
    echo "4. ${FILE} Update documentation:"
    echo "   - plugins/$CATEGORY/$PLUGIN_NAME/README.md"
    echo "   - Add usage examples"
    echo ""
    echo "5. ${ROCKET} Submit your plugin:"
    echo "   - Create a pull request"
    echo "   - Include test results"
    echo "   - Follow contribution guidelines"
    echo ""
    echo -e "${CYAN}${INFO} Plugin location: plugins/$CATEGORY/$PLUGIN_NAME${NC}"
    echo -e "${CYAN}${INFO} Plugin entry added to: plugins/list.txt${NC}"
    echo ""
    echo -e "${PURPLE}Happy coding! 🚀${NC}"
}

# Main execution
main() {
    # Check if we're in the correct directory
    if [ ! -f "ex.sh" ] || [ ! -d "plugins" ]; then
        error_exit "Please run this script from the eXtensibleSH root directory"
    fi
    
    # Get user input
    get_user_input
    
    # Create plugin structure
    create_directory_structure
    create_metadata
    create_os_scripts
    create_plugin_readme
    update_plugins_list
    
    # Display next steps
    display_next_steps
}

# Run main function
main "$@" 