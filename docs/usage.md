# Usage Guide for eXtensibleSH

## Overview

eXtensibleSH v1.0.0+ features a beautiful, interactive menu system that makes self-hosting easy. The script automatically detects your operating system and provides both official plugins and third-party scripts for various services.

## Quick Start

### Interactive Menu (Recommended)

Run the script without any arguments to launch the interactive menu:

```bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
```

This will:
- Detect your operating system
- Set up logging
- Display a colorful, interactive menu
- Show compatible plugins and scripts
- Guide you through the installation process

### Direct Plugin Execution

Run a specific plugin directly:

```bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx
```

Or with category specification:

```bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx webservers
```

## Interactive Menu Features

### Main Menu Options

1. **🔧 Show Available Plugins**: Browse plugins organized by category
2. **⭐ Show Third-Party Scripts**: View community-contributed scripts
3. **🚀 Run Plugin**: Execute a specific plugin
4. **🚀 Run Third-Party Script**: Execute a third-party script
5. **ℹ️ System Information**: View system details and configuration
6. **✗ Exit**: Exit the application

### Plugin Categories

Plugins are organized into the following categories:

- **🌐 WEBSERVERS**: NGINX, Apache, Caddy
- **💾 DATABASES**: MySQL, PostgreSQL, MongoDB
- **🐳 CONTAINERIZATION**: Docker, Kubernetes, Podman
- **📊 MONITORING**: Prometheus, Grafana, ELK Stack
- **🔒 SECURITY**: Fail2ban, UFW, SSL certificates
- **💿 STORAGE**: NFS, Samba, MinIO

### Compatibility Indicators

- **✓ Green checkmark**: Fully compatible with your OS
- **⚠️ Yellow warning**: Generic version available
- **✗ Red cross**: Not compatible (may require force loading)

## Advanced Usage

### Force Loading Plugins

If a plugin isn't available for your OS, you can force load it:

1. Select "Run Plugin" from the menu
2. Enter the plugin name
3. When prompted, choose to force load
4. Specify the OS group (debian/rhel/arch/generic)

### Third-Party Scripts

⚠️ **Security Warning**: Third-party scripts are not maintained by the eXtensibleSH team. Always review scripts before execution.

To run a third-party script:
1. Select "Show Third-Party Scripts" to browse available scripts
2. Select "Run Third-Party Script" 
3. Enter the script name
4. Review the script source code
5. Confirm execution

### Logging

All actions are automatically logged to `./logs/exsh-log-YYYYMMDDHHMMSS.log`

You can monitor the log in real-time:
```bash
tail -f ./logs/exsh-log-*.log
```

### Command Line Arguments

The script accepts several command line arguments:

```bash
# Run specific plugin
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s PLUGIN_NAME [CATEGORY]

# Examples:
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s docker containerization
```

## Operating System Support

### Fully Supported

- **Debian-based**: Ubuntu, Debian, Linux Mint, Kali Linux, Raspbian
- **RHEL-based**: CentOS, RHEL, Fedora, Rocky Linux, AlmaLinux, Oracle Linux
- **Arch-based**: Arch Linux, Manjaro, EndeavourOS

### Experimental Support

- **openSUSE**: SUSE Linux Enterprise
- **Alpine**: Alpine Linux
- **Other**: Generic Linux distributions

### OS Detection

The script automatically detects your operating system and maps it to the appropriate plugin group:

```bash
# Examples of detection output:
OS detected: ubuntu (debian), Version: 20.04
OS detected: centos (rhel), Version: 8
OS detected: arch (arch), Version: rolling
```

## System Requirements

### Minimum Requirements

- **curl**: For downloading scripts
- **bash**: Version 4.0 or higher
- **sudo**: For non-root users (or run as root)
- **Internet connection**: For downloading plugins and scripts

### Recommended

- **jq**: For enhanced JSON parsing (optional)
- **systemd**: For service management
- **Package manager**: apt, yum, dnf, or pacman

## Troubleshooting

### Common Issues

#### "Failed to fetch plugin list"
- **Cause**: Network connectivity issues
- **Solution**: Check internet connection and GitHub accessibility
- **Command**: `curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/plugins/list.txt`

#### "sudo required but not found"
- **Cause**: Running as non-root user without sudo
- **Solution**: Install sudo or run as root
- **Command**: `su -c "curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash"`

#### "Plugin not found"
- **Cause**: Plugin name misspelled or not available
- **Solution**: Use the interactive menu to browse available plugins
- **Alternative**: Try third-party scripts

#### "Permission denied on log directory"
- **Cause**: Cannot create logs directory
- **Solution**: Run with sudo or create directory manually
- **Command**: `mkdir -p ./logs && chmod 755 ./logs`

### Debug Mode

For troubleshooting, you can enable debug mode:

```bash
# Enable bash debugging
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -x
```

### Log Analysis

Check the log file for detailed information:

```bash
# View the latest log
ls -la ./logs/
cat ./logs/exsh-log-*.log

# Search for errors
grep -i error ./logs/exsh-log-*.log
```

## Security Considerations

### Running as Root

- **Not recommended**: Running as root increases security risks
- **Better approach**: Use sudo for privileged operations
- **Detection**: Script automatically detects and adapts

### Third-Party Scripts

- **Security warning**: Not maintained by eXtensibleSH team
- **Review required**: Always review source code before execution
- **Sandboxing**: Consider running in containers or VMs

### Network Security

- **HTTPS only**: All downloads use HTTPS
- **No local storage**: Scripts are not permanently stored
- **Execution**: Scripts run directly from memory

## Plugin Development

### Creating Plugins

See the [Plugin Development Guide](how-to-create-plugin.md) for detailed information on creating plugins.

### Contributing Scripts

To contribute third-party scripts:

1. Fork the repository
2. Add your script entry to `thirdparty/list.txt`
3. Format: `script-name:category:url:description`
4. Create a pull request

## Examples

### Installing NGINX

```bash
# Interactive way
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
# Select option 3 (Run Plugin)
# Enter: nginx

# Direct way
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx
```

### Installing Docker

```bash
# Interactive way
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
# Select option 3 (Run Plugin)
# Enter: docker
# Enter category: containerization

# Direct way
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s docker containerization
```

### Browsing Available Options

```bash
# Launch interactive menu
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
# Select option 1 (Show Available Plugins)
# Browse by category

# Or view third-party scripts
# Select option 2 (Show Third-Party Scripts)
```

## Getting Help

### Documentation

- **Plugin Development**: [how-to-create-plugin.md](how-to-create-plugin.md)
- **Project Homepage**: [GitHub Pages](https://moonshadowrev.github.io/eXtensibleSH/)
- **Repository**: [GitHub Repository](https://github.com/moonshadowrev/eXtensibleSH)

### Support

- **Issues**: Report bugs on [GitHub Issues](https://github.com/moonshadowrev/eXtensibleSH/issues)
- **Discussions**: Join [GitHub Discussions](https://github.com/moonshadowrev/eXtensibleSH/discussions)
- **Security**: Report security issues via [Security Policy](https://github.com/moonshadowrev/eXtensibleSH/security/policy)

### Community

- **Contributing**: See [CONTRIBUTING.md](https://github.com/moonshadowrev/eXtensibleSH/blob/main/CONTRIBUTING.md)
- **Code of Conduct**: See [CODE_OF_CONDUCT.md](https://github.com/moonshadowrev/eXtensibleSH/blob/main/CODE_OF_CONDUCT.md)
- **License**: [GPLv3](https://github.com/moonshadowrev/eXtensibleSH/blob/main/LICENSE)

## Version Information

- **Current Version**: 1.0.0
- **Release Date**: January 2025
- **Compatibility**: Backward compatible with v1.x plugins
- **New Features**: Interactive menu, third-party scripts, categories, metadata 