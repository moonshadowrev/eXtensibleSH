# How to Create a Plugin for eXtensibleSH

## Overview

eXtensibleSH plugins are modular Bash scripts that automate the installation and configuration of various services. With the new plugin system, plugins are organized by categories and support versioning, metadata, and enhanced OS compatibility.

## 🚀 Quick Start: Plugin Development Tool

**The easiest way to create a new plugin is using our automated development tool:**

```bash
./dev.sh
```

This interactive tool will:
- ✅ Guide you through plugin configuration
- ✅ Create the complete directory structure
- ✅ Generate metadata.json with proper templates
- ✅ Create OS-specific script templates
- ✅ Generate plugin README documentation
- ✅ Update the plugin registry automatically

**Example workflow:**
```bash
# 1. Install git hooks (recommended for code quality)
./hooks/install.sh

# 2. Run the development tool
./dev.sh

# 3. Follow the interactive prompts:
#    - Enter plugin name: myapp
#    - Select category: webservers
#    - Enter description: My awesome application
#    - Select OS support: debian rhel arch
#    - Complete configuration

# 4. Your plugin structure is created:
#    plugins/webservers/myapp/
#    ├── metadata.json
#    ├── README.md
#    ├── debian/latest.sh
#    ├── rhel/latest.sh
#    └── arch/latest.sh

# 5. Edit the generated scripts with your implementation
# 6. Test and submit your plugin (git hooks will validate automatically)
```

### 🎯 Development Tool Features

The `dev.sh` tool provides comprehensive plugin scaffolding:

**📋 Interactive Configuration:**
- Plugin name validation and collision detection
- Category selection with predefined options
- Multiple OS support configuration
- Author and metadata information collection
- Installation time estimation

**🏗️ Generated Structure:**
```
plugins/category/pluginname/
├── metadata.json          # Complete plugin metadata
├── README.md             # Plugin documentation
├── debian/
│   └── latest.sh         # Debian/Ubuntu script
├── rhel/
│   └── latest.sh         # RHEL/CentOS/Fedora script
└── arch/
    └── latest.sh         # Arch Linux script
```

**🔧 Template Features:**
- Argument parsing (`-l` for log, `-s` for sudo)
- Error handling and logging integration
- Server profile selection (low-end, mid-level, high-level)
- OS-specific installation examples
- Service management templates
- Comprehensive TODO comments for guidance
- Development-only flag to exclude from user listings

**⚙️ Automatic Updates:**
- Updates `plugins/list.txt` with new plugin entry
- Maintains proper formatting and sorting
- Prevents duplicate entries

**🪝 Code Quality Assurance:**
- Pre-commit hooks validate all shell scripts
- JSON file validation before commits
- Automatic permission fixes
- Project-specific validation rules

### 🔧 Git Hooks Setup

Install git hooks for automatic code validation:

```bash
# Install the pre-commit hook
./hooks/install.sh
```

This hook will automatically validate:
- ✅ Shell script syntax (`bash -n`)
- ✅ JSON file validity
- ✅ File permissions
- ✅ Plugin metadata structure
- ✅ Project-specific requirements
- ✅ Development-only plugins are not listed in plugins/list.txt

## 🚧 Development-Only Plugins

Some plugins are meant for development purposes only and should not be visible to end users. To mark a plugin as development-only:

1. **Add the flag** to `metadata.json`:
   ```json
   {
     "name": "template",
     "development_only": true,
     ...
   }
   ```

2. **Do not add** the plugin to `plugins/list.txt`

3. **The git hook** will automatically prevent development-only plugins from being accidentally listed

**Examples of development-only plugins:**
- Plugin templates
- Development tools
- Test plugins
- Internal utilities

## 📋 Manual Plugin Creation

If you prefer to create plugins manually, follow the steps below:

## New Plugin Structure (v1.0.0+)

The new plugin structure is organized as follows:

```
plugins/
├── webservers/
│   └── nginx/
│       ├── metadata.json
│       ├── debian/
│       │   ├── latest.sh
│       │   ├── 20.04.sh
│       │   └── 18.04.sh
│       ├── rhel/
│       │   ├── latest.sh
│       │   ├── 8.sh
│       │   └── 7.sh
│       └── arch/
│           └── latest.sh
├── databases/
├── containerization/
├── monitoring/
├── security/
└── storage/
```

## Plugin Categories

Plugins are organized into the following categories:

- **webservers**: NGINX, Apache, Caddy, etc.
- **databases**: MySQL, PostgreSQL, MongoDB, etc.
- **containerization**: Docker, Kubernetes, Podman, etc.
- **monitoring**: Prometheus, Grafana, ELK stack, etc.
- **security**: Fail2ban, UFW, SSL certificates, etc.
- **storage**: NFS, Samba, MinIO, etc.
- **development**: Development tools and templates
- **networking**: Network tools and configurations
- **backup**: Backup and recovery solutions

**📁 Directory Structure:**
Each plugin category directory contains a `.gitkeep` file to ensure empty directories are preserved in git. This maintains the project structure even when categories don't have plugins yet.

## Creating a New Plugin

### Step 1: Choose Category and Create Structure

1. Choose the appropriate category for your plugin
2. Create the directory structure:
   ```bash
   mkdir -p plugins/category/plugin-name/{debian,rhel,arch}
   ```

### Step 2: Create metadata.json

Create a comprehensive metadata file that describes your plugin:

```json
{
  "name": "your-plugin",
  "display_name": "Your Plugin Display Name",
  "description": "Brief description of what your plugin does",
  "category": "webservers",
  "version": "1.0.0",
  "author": "your-github-username",
  "license": "GPLv3",
  "tags": ["web", "server", "performance"],
  "features": [
    "Feature 1",
    "Feature 2",
    "Feature 3"
  ],
  "supported_os": {
    "debian": {
      "versions": ["latest", "20.04", "18.04"],
      "package_manager": "apt",
      "service_manager": "systemd"
    },
    "rhel": {
      "versions": ["latest", "8", "7"],
      "package_manager": "yum",
      "service_manager": "systemd"
    },
    "arch": {
      "versions": ["latest"],
      "package_manager": "pacman",
      "service_manager": "systemd"
    }
  },
  "server_profiles": [
    {
      "name": "low-end",
      "description": "Low end server configuration"
    },
    {
      "name": "high-end",
      "description": "High end server configuration"
    }
  ],
  "dependencies": [],
  "conflicts": ["conflicting-service"],
  "installation_time": "2-5 minutes",
  "documentation": "https://your-service-docs.com",
  "support_url": "https://github.com/moonshadowrev/eXtensibleSH/issues",
  "changelog": [
    {
      "version": "1.0.0",
      "date": "2025-01-01",
      "changes": [
        "Initial release",
        "Added OS-specific support"
      ]
    }
  ]
}
```

### Step 3: Create Script Files

Create OS-specific script files in the appropriate directories:

#### Template Structure (latest.sh)

```bash
#!/bin/bash

# Plugin Name for eXtensibleSH
# OS: debian/rhel/arch
# Version: latest
# Description: Brief description of what this script does

# Error handling
set -e
trap 'echo "Error occurred at line $LINENO"; exit 1' ERR

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --log=*)
            LOG_FILE="${1#*=}"
            shift
            ;;
        --use-sudo=*)
            USE_SUDO="${1#*=}"
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# Set command prefix based on use-sudo
if [ "$USE_SUDO" = "true" ]; then
    PREFIX="sudo "
else
    PREFIX=""
fi

# Set up logging
exec >> "$LOG_FILE" 2>&1
echo "$(date): Starting plugin execution"

# Check if service is already installed
if command -v your-service >/dev/null 2>&1; then
    echo "Service already installed. Checking configuration..."
fi

# Install service based on OS
install_service() {
    echo "Installing service..."
    
    # Debian/Ubuntu
    if [[ -f /etc/debian_version ]]; then
        ${PREFIX}apt update
        ${PREFIX}apt install -y your-service
    # RHEL/CentOS/Fedora
    elif [[ -f /etc/redhat-release ]]; then
        ${PREFIX}yum install -y your-service || ${PREFIX}dnf install -y your-service
    # Arch Linux
    elif [[ -f /etc/arch-release ]]; then
        ${PREFIX}pacman -S --noconfirm your-service
    fi
}

# Configure service
configure_service() {
    echo "Configuring service..."
    
    # Interactive profile selection
    echo "Choose your server profile:"
    select profile in "Low-end (1 CPU, 2GB RAM)" "High-end (4+ CPU, 8GB+ RAM)" "Custom"; do
        case $profile in
            "Low-end (1 CPU, 2GB RAM)")
                echo "Configuring for low-end server..."
                # Add low-end configuration
                break
                ;;
            "High-end (4+ CPU, 8GB+ RAM)")
                echo "Configuring for high-end server..."
                # Add high-end configuration
                break
                ;;
            "Custom")
                echo "Custom configuration selected..."
                # Add custom configuration prompts
                break
                ;;
            *)
                echo "Invalid selection"
                ;;
        esac
    done
}

# Main execution
main() {
    echo "Starting plugin: Your Plugin Name"
    
    # Check prerequisites
    if ! command -v curl >/dev/null 2>&1; then
        echo "Error: curl is required but not installed"
        exit 1
    fi
    
    # Install and configure
    install_service
    configure_service
    
    # Start and enable service
    ${PREFIX}systemctl start your-service
    ${PREFIX}systemctl enable your-service
    
    # Verify installation
    if systemctl is-active --quiet your-service; then
        echo "✓ Service installed and running successfully"
    else
        echo "✗ Service installation failed"
        exit 1
    fi
    
    echo "$(date): Plugin execution completed"
}

# Run main function
main "$@"
```

## Best Practices

### 1. Error Handling
- Always use `set -e` to exit on errors
- Use `trap` for cleanup on errors
- Validate all user inputs
- Check for required dependencies

### 2. OS Compatibility
- Use OS-agnostic commands when possible
- Provide fallbacks for different package managers
- Test on multiple distributions
- Use appropriate service managers (systemd, init, etc.)

### 3. Security
- Never run as root unless absolutely necessary
- Use sudo for privileged operations
- Validate all file paths and user inputs
- Avoid hardcoded credentials

### 4. Logging and Debugging
- Log all significant actions
- Include timestamps in log messages
- Use descriptive error messages
- Provide progress indicators

### 5. User Experience
- Provide clear prompts and instructions
- Offer server profile selections
- Show progress indicators
- Provide helpful error messages

### 6. Idempotency
- Make scripts safe to run multiple times
- Check if services are already installed
- Preserve existing configurations when possible

## Testing Your Plugin

### 1. Local Testing
```bash
# Test on different OS distributions
# Test with different user privileges
# Test idempotency (run multiple times)
# Test error conditions
```

### 2. Linting
```bash
# Use shellcheck to validate your script
shellcheck plugins/category/plugin-name/debian/latest.sh
```

### 3. Integration Testing
```bash
# Test through the main ex.sh script
curl -s https://raw.githubusercontent.com/your-fork/eXtensibleSH/main/ex.sh | bash -s your-plugin
```

## Legacy Plugin Support

The system maintains backward compatibility with the old plugin structure:

```
plugins/
├── plugin-name/
│   ├── debian.sh
│   ├── rhel.sh
│   ├── arch.sh
│   └── generic.sh
└── list.txt
```

Legacy plugins will continue to work but won't have the enhanced features of the new system.

## Submitting Your Plugin

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/eXtensibleSH.git
   cd eXtensibleSH
   ```

2. **Create Your Plugin**
   - Follow the structure above
   - Create metadata.json
   - Create OS-specific scripts
   - Test thoroughly

3. **Update Registry**
   - The GitHub Actions workflow will automatically update the plugin registry
   - No manual updates to list.txt needed for new structure

4. **Create Pull Request**
   - Include detailed description
   - Mention supported OS versions
   - Provide testing information
   - Include screenshots if applicable

## Getting Help

- **Documentation**: Check the [usage guide](usage.md)
- **Examples**: Look at existing plugins in the repository
- **Issues**: Report problems on [GitHub Issues](https://github.com/moonshadowrev/eXtensibleSH/issues)
- **Discussions**: Join [GitHub Discussions](https://github.com/moonshadowrev/eXtensibleSH/discussions)

## Advanced Topics

### Version Management
- Create version-specific scripts (e.g., `20.04.sh`, `8.sh`)
- Use semantic versioning for plugin versions
- Maintain changelog in metadata.json

### Plugin Dependencies
- Specify dependencies in metadata.json
- Check for conflicting services
- Handle dependency installation

### Custom Configurations
- Support environment variables
- Provide configuration templates
- Allow custom configuration files

For more advanced topics and examples, check the existing plugins in the repository. 