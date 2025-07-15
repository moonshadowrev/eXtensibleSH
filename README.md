<div align="center">

# eXtensibleSH

<img src="https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/docs/image.webp" alt="eXtensibleSH Logo" width="200" height="200" />

### *Plugin-based self-hosting made easy*

<br>

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub Issues](https://img.shields.io/github/issues/moonshadowrev/eXtensibleSH?style=for-the-badge&logo=github)](https://github.com/moonshadowrev/eXtensibleSH/issues)
[![GitHub Stars](https://img.shields.io/github/stars/moonshadowrev/eXtensibleSH?style=for-the-badge&logo=github)](https://github.com/moonshadowrev/eXtensibleSH/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/moonshadowrev/eXtensibleSH?style=for-the-badge&logo=github)](https://github.com/moonshadowrev/eXtensibleSH/network)
[![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg?style=for-the-badge&logo=semver)](https://github.com/moonshadowrev/eXtensibleSH/releases)

<br>

**🚀 [Quick Start](#-quick-start) • 📚 [Documentation](#-documentation) • 🔌 [Plugin System](#-plugin-system) • 🛠️ [Development Tools](#%EF%B8%8F-development-tools) • 🌟 [Features](#-features) • 🤝 [Contributing](#-contributing)**

<br>

---

</div>

## 🌟 Overview

> **eXtensibleSH** is a revolutionary plugin-extensible Bash framework that transforms the way you deploy and manage self-hosted services. With its beautiful interactive menu system, intelligent OS detection, and extensive plugin ecosystem, setting up your homelab or server has never been easier.

<br>

### ✨ What makes eXtensibleSH special?

<table>
<tr>
<td width="50%">

**🎯 Zero Installation**
> Run directly from GitHub with a single curl command

**🤖 Smart OS Detection**
> Automatically adapts to your Linux distribution

**🔌 Plugin Ecosystem**
> Categorized plugins for web servers, databases, containers, and more

**🌐 Third-Party Support**
> Community-contributed scripts for extended functionality

</td>
<td width="50%">

**🎨 Beautiful Interface**
> Colorful, interactive terminal UI with progress indicators

**📊 Comprehensive Logging**
> Full audit trail of all actions and changes

**🔒 Security First**
> Built-in safety checks and secure execution patterns

**⚡ Performance Optimized**
> Intelligent server profiling and configuration tuning

</td>
</tr>
</table>

<br>

---

## 🚀 Quick Start

### 🎯 One-Command Setup

Launch the interactive menu to explore available plugins:

```bash
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
```

<details>
<summary>📋 <b>What happens when you run this command?</b></summary>
<br>

1. **🔍 OS Detection**: Automatically detects your Linux distribution
2. **📝 Logging Setup**: Creates comprehensive logs in `./logs/`
3. **🎨 Interactive Menu**: Displays a beautiful terminal interface
4. **🔌 Plugin Discovery**: Shows available plugins and third-party scripts
5. **⚙️ Configuration**: Guides you through server-specific optimizations

</details>

<br>

### 🎯 Direct Plugin Installation

Install specific services directly:

```bash
# Install NGINX web server
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx webservers

```

<br>

### 🔍 Explore Available Options

```bash
# Browse plugin categories
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/plugins/list.txt

# View third-party scripts
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/thirdparty/list.txt
```

<br>

---

## 🌟 Features

<div align="center">

### 🎨 Interactive Experience

<img src="https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/docs/image.webp" alt="Interactive Menu" width="600" />

*Beautiful, intuitive terminal interface with real-time feedback*

</div>

<br>

<table>
<tr>
<td width="33%">

### 🔌 **Plugin System**
- **Modular Architecture**: Clean separation of concerns
- **Category Organization**: Organized by service type
- **Version Management**: Support for multiple versions
- **OS-Specific Scripts**: Tailored for each distribution
- **Metadata Rich**: Comprehensive plugin information

</td>
<td width="33%">

### 🐧 **OS Compatibility**
- **Multi-Distribution**: Debian, RHEL, Arch, and more
- **Intelligent Detection**: Automatic OS identification
- **Adaptive Configuration**: OS-specific optimizations
- **Legacy Support**: Works with older distributions
- **Architecture Aware**: x86_64 and ARM support

</td>
<td width="33%">

### 🔒 **Security & Safety**
- **Secure Downloads**: All scripts fetched over HTTPS
- **Privilege Management**: Smart sudo handling
- **Input Validation**: Comprehensive security checks
- **Audit Trail**: Complete logging of all actions
- **Third-Party Warnings**: Clear security notices

</td>
</tr>
</table>

<br>

### 📊 **Performance & Reliability**

<table>
<tr>
<td width="25%" align="center">

**⚡ Fast Execution**
<br>
Optimized for speed and efficiency

</td>
<td width="25%" align="center">

**🔄 Idempotent Operations**
<br>
Safe to run multiple times

</td>
<td width="25%" align="center">

**📈 Resource Optimization**
<br>
Smart server profiling

</td>
<td width="25%" align="center">

**🛡️ Error Handling**
<br>
Robust error recovery

</td>
</tr>
</table>

<br>

---

## 🐧 Operating System Support

<div align="center">

<table>
<tr>
<th width="25%">OS Family</th>
<th width="35%">Distributions</th>
<th width="20%">Support Level</th>
<th width="20%">Status</th>
</tr>
<tr>
<td align="center"><b>Debian</b></td>
<td>Ubuntu, Debian, Mint, Kali, Raspbian</td>
<td align="center">✅ Full Support</td>
<td align="center">🟢 Stable</td>
</tr>
<tr>
<td align="center"><b>RHEL</b></td>
<td>CentOS, RHEL, Fedora, Rocky, AlmaLinux</td>
<td align="center">✅ Full Support</td>
<td align="center">🟢 Stable</td>
</tr>
<tr>
<td align="center"><b>Arch</b></td>
<td>Arch Linux, Manjaro, EndeavourOS</td>
<td align="center">✅ Full Support</td>
<td align="center">🟢 Stable</td>
</tr>
<tr>
<td align="center"><b>openSUSE</b></td>
<td>openSUSE Leap, Tumbleweed, SLES</td>
<td align="center">🧪 Experimental</td>
<td align="center">🟡 Beta</td>
</tr>
<tr>
<td align="center"><b>Alpine</b></td>
<td>Alpine Linux</td>
<td align="center">🧪 Experimental</td>
<td align="center">🟡 Beta</td>
</tr>
<tr>
<td align="center"><b>Generic</b></td>
<td>Other Linux distributions</td>
<td align="center">⚠️ Basic Support</td>
<td align="center">🟡 Limited</td>
</tr>
</table>

</div>

<br>

---

## 🔌 Plugin System

<div align="center">

### 📦 **Plugin Categories**

<table>
<tr>
<td width="16%" align="center">

**🌐 Web Servers**
<br>
*NGINX, Apache, Caddy*

</td>
<td width="16%" align="center">

**💾 Databases**
<br>
*PostgreSQL, MySQL, MongoDB*

</td>
<td width="16%" align="center">

**🐳 Containers**
<br>
*Docker, Kubernetes, Podman*

</td>
<td width="16%" align="center">

**📊 Monitoring**
<br>
*Prometheus, Grafana, ELK*

</td>
<td width="16%" align="center">

**🔒 Security**
<br>
*Fail2ban, UFW, SSL*

</td>
<td width="16%" align="center">

**💿 Storage**
<br>
*NFS, Samba, MinIO*

</td>
</tr>
</table>

</div>

<br>

### 🌟 **Plugin Features**

<details>
<summary>🔧 <b>Advanced Configuration</b></summary>
<br>

- **Server Profiling**: Automatic resource detection and optimization
- **Interactive Setup**: Guided configuration with intelligent defaults
- **Version Management**: Support for multiple software versions
- **Dependency Handling**: Automatic prerequisite installation
- **Conflict Resolution**: Smart handling of conflicting services

</details>

<details>
<summary>🔍 <b>Plugin Discovery</b></summary>
<br>

- **Real-time Browsing**: Interactive web interface for plugin exploration
- **Category Filtering**: Organize plugins by service type
- **Search Functionality**: Find plugins by name, description, or features
- **Compatibility Check**: Visual indicators for OS compatibility
- **Installation Commands**: One-click copy for installation

</details>

<details>
<summary>🌐 <b>Third-Party Integration</b></summary>
<br>

- **Community Scripts**: Extensive collection of community-contributed scripts
- **Security Validation**: Comprehensive security review process
- **Quality Assurance**: Automated testing and validation
- **Documentation**: Detailed information for each script
- **Source Transparency**: Direct links to original repositories

</details>

<br>

---

## 📚 Documentation

<div align="center">

### 📖 **User Guides**

<table>
<tr>
<td width="33%" align="center">

**📋 [Usage Guide](docs/usage.md)**
<br>
*Complete usage instructions and examples*

</td>
<td width="33%" align="center">

**🔧 [Plugin Development](docs/how-to-create-plugin.md)**
<br>
*How to create and contribute plugins*

</td>
<td width="33%" align="center">

**🌐 [GitHub Pages](https://moonshadowrev.github.io/eXtensibleSH/)**
<br>
*Interactive online documentation*

</td>
</tr>
</table>

</div>

<br>

### 🛠️ **Technical Documentation**

<details>
<summary>📋 <b>Project Documentation</b></summary>
<br>

- **[🔒 Security Policy](SECURITY.md)**: Security guidelines and vulnerability reporting
- **[🤝 Contributing Guide](CONTRIBUTING.md)**: How to contribute to the project
- **[📜 Code of Conduct](CODE_OF_CONDUCT.md)**: Community guidelines
- **[🌟 Third-Party Scripts](thirdparty/README.md)**: Community script documentation
- **[📝 GitHub Templates](.github/TEMPLATES.md)**: Issue and PR templates guide

</details>

<br>

---

## 🛠️ Development Tools

<div align="center">

### 🚀 **Plugin Development Made Easy**

</div>

<br>

**🔧 Automated Plugin Generator**

Create new plugins effortlessly with our interactive development tool:

```bash
# Clone the repository
git clone https://github.com/moonshadowrev/eXtensibleSH.git
cd eXtensibleSH

# Install git hooks for code quality (recommended)
./hooks/install.sh

# Run the plugin generator
./dev.sh
```

**🎯 Features:**
- ✅ **Interactive Wizard**: Step-by-step plugin creation
- ✅ **Auto-Generation**: Creates complete directory structure
- ✅ **Template Scripts**: OS-specific script templates
- ✅ **Metadata Creation**: Comprehensive metadata.json generation
- ✅ **Documentation**: Auto-generated README files
- ✅ **Registry Updates**: Automatic plugin list updates
- ✅ **Git Hooks**: Pre-commit validation for code quality

<details>
<summary>🔍 <b>Development Tool Screenshot</b></summary>
<br>

```
════════════════════════════════════════════════════════════════════════════════
║                    eXtensibleSH Plugin Development Tool                        ║
════════════════════════════════════════════════════════════════════════════════

⚙️ Plugin Configuration

Enter plugin name: myapp
Select category (1-10): 1
Enter display name: My Awesome App
Enter description: Custom application with auto-scaling
Select OS support (1-5): 5
Enter OS list: debian rhel arch

✅ Created: plugins/webservers/myapp
✅ Created: plugins/webservers/myapp/debian
✅ Created: plugins/webservers/myapp/rhel
✅ Created: plugins/webservers/myapp/arch
✅ Created: plugins/webservers/myapp/metadata.json
✅ Created: plugins/webservers/myapp/debian/latest.sh
✅ Created: plugins/webservers/myapp/rhel/latest.sh
✅ Created: plugins/webservers/myapp/arch/latest.sh
✅ Created: plugins/webservers/myapp/README.md
✅ Updated: plugins/list.txt

🚀 Plugin 'myapp' created successfully!
```

</details>

<br>

### 🪝 **Code Quality Assurance**

**Pre-commit Git Hook:**

```bash
# Install the pre-commit hook for automatic validation
./hooks/install.sh
```

**What it validates:**
- ✅ **Shell Script Syntax**: Validates all `.sh` files using `bash -n`
- ✅ **JSON File Validity**: Ensures proper JSON format in all `.json` files
- ✅ **File Permissions**: Automatically fixes executable permissions
- ✅ **Project Standards**: Validates plugin metadata and list formats
- ✅ **Error Prevention**: Prevents commits with syntax or format errors

**Benefits:**
- 🚀 **Faster Development**: Catch errors before they reach the repository
- 🛡️ **Quality Assurance**: Maintain consistent code quality across contributions
- 🔧 **Auto-fixes**: Automatically fix common issues like file permissions
- 📊 **Detailed Feedback**: Clear error messages with suggestions

<details>
<summary>🔍 <b>Hook Output Example</b></summary>
<br>

```
🪝 eXtensibleSH Pre-commit Hook
═══════════════════════════════════════

1. Checking shell script syntax...
  Checking dev.sh... ✅ Valid syntax
  Checking ex.sh... ✅ Valid syntax

2. Checking JSON file validity...
  Checking metadata.json... ✅ Valid JSON

3. Checking executable permissions...
  Checking dev.sh... ✅ Executable

4. Checking project-specific requirements...
  Checking plugins/list.txt... ✅ Valid format

✅ All checks passed! Commit proceeding...
```

</details>

<br>

---

## 🛠️ Installation Examples

<div align="center">

### 🎯 **Common Use Cases**

</div>

<br>

<details>
<summary>🌐 <b>Web Server Setup</b></summary>
<br>

```bash
# Interactive setup with server profile selection
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s nginx webservers
```

**Features included:**
- ✅ Server profile selection (low-end, mid-level, high-end)
- ✅ SSL certificate setup
- ✅ Performance tuning options
- ✅ Firewall configuration
- ✅ Security hardening

</details>

<details>
<summary>🐳 <b>Container Platform</b></summary>
<br>

```bash
# Install Docker with automatic configuration
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash -s docker containerization
```

**Features included:**
- ✅ Docker Engine installation
- ✅ User group configuration
- ✅ Service enablement
- ✅ Basic security setup
- ✅ Container management tools

</details>

<details>
<summary>📊 <b>Monitoring Stack</b></summary>
<br>

```bash
# Interactive menu for monitoring tools
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
```

**Available options:**
- ✅ Prometheus (metrics collection)
- ✅ Grafana (visualization)
- ✅ ELK Stack (logging)
- ✅ Uptime monitoring
- ✅ Performance dashboards

</details>

<br>

---

## 🔒 Security & Safety

<div align="center">

### 🛡️ **Security Features**

<table>
<tr>
<td width="50%">

**🔐 Secure Downloads**
<br>
All scripts fetched over HTTPS

**🔍 Code Review**
<br>
Scripts executed directly from memory

**👤 Privilege Management**
<br>
Automatic detection of root/sudo requirements

**📋 Audit Trail**
<br>
Complete logging of all actions and changes

</td>
<td width="50%">

**⚠️ Safety Checks**
<br>
Built-in validation and error handling

**🛡️ Third-Party Warnings**
<br>
Clear security notices for community scripts

**🔒 Input Validation**
<br>
Comprehensive security checks

**🚨 Error Recovery**
<br>
Robust error handling and recovery

</td>
</tr>
</table>

</div>

<br>

### 🚨 **Best Practices**

<details>
<summary>🔍 <b>Security Guidelines</b></summary>
<br>

1. **📋 Review Scripts**: Always review third-party scripts before execution
2. **👤 Use Sudo**: Run as regular user with sudo privileges (not root)
3. **📊 Monitor Logs**: Check logs for any suspicious activity
4. **🧪 Test First**: Test in a safe environment before production use
5. **🔄 Keep Updated**: Regularly check for plugin updates

</details>

<br>

---

## 📈 System Requirements

<div align="center">

<table>
<tr>
<th width="50%">✅ Minimum Requirements</th>
<th width="50%">🚀 Recommended Setup</th>
</tr>
<tr>
<td>

**Operating System**: Linux (any major distribution)
<br>
**Shell**: Bash 4.0 or higher
<br>
**Tools**: curl, sudo (or root access)
<br>
**Network**: Internet connection for downloading scripts

</td>
<td>

**System**: 1GB RAM, 1 CPU core
<br>
**Storage**: 10GB free space
<br>
**Additional**: systemd, package manager (apt/yum/pacman)
<br>
**Optional**: jq for enhanced JSON parsing

</td>
</tr>
</table>

</div>

<br>

---

## 🤝 Contributing

<div align="center">

### 🌟 **Join Our Community**

*We welcome contributions from developers of all skill levels!*

<br>

<table>
<tr>
<td width="33%" align="center">

**🔌 Plugin Development**
<br>
*Create and contribute new plugins*

</td>
<td width="33%" align="center">

**🌟 Third-Party Scripts**
<br>
*Share community scripts*

</td>
<td width="33%" align="center">

**🐛 Bug Reports & Features**
<br>
*Help improve the platform*

</td>
</tr>
</table>

</div>

<br>

### 🛠️ **How to Contribute**

<details>
<summary>🔌 <b>Plugin Development</b></summary>
<br>

**🚀 Quick Start with Development Tool:**

```bash
# Use the automated plugin generator
./dev.sh
```

**📋 Manual Development Steps:**

1. **📂 Fork the repository**
2. **🪝 Install git hooks** for code quality: `./hooks/install.sh`
3. **🔧 Create a new plugin** following our [development guide](docs/how-to-create-plugin.md)
4. **🧪 Test thoroughly** on multiple OS distributions
5. **📝 Submit a pull request** with detailed description

**🎯 Plugin Generator Features:**
- ✅ Interactive plugin creation wizard
- ✅ Automatic directory structure generation
- ✅ Metadata.json template creation
- ✅ OS-specific script templates
- ✅ README generation
- ✅ Plugin registry updates

</details>

<details>
<summary>🌟 <b>Third-Party Scripts</b></summary>
<br>

1. **📋 Add your script** to `thirdparty/list.txt`
2. **📝 Follow the format**: `name:category:url:description`
3. **🔒 Ensure security** and compatibility
4. **📤 Create a pull request**

</details>

<details>
<summary>🐛 <b>Bug Reports & Features</b></summary>
<br>

- **🐛 Report bugs**: [GitHub Issues](https://github.com/moonshadowrev/eXtensibleSH/issues)
- **💡 Request features**: [GitHub Discussions](https://github.com/moonshadowrev/eXtensibleSH/discussions)
- **🔒 Security issues**: See [Security Policy](SECURITY.md)

</details>

<br>

---

## 🌐 Links & Resources

<div align="center">

<table>
<tr>
<td width="25%" align="center">

[![Website](https://img.shields.io/badge/Website-eXtensibleSH-blue?style=for-the-badge&logo=github)](https://moonshadowrev.github.io/eXtensibleSH/)

</td>
<td width="25%" align="center">

[![Documentation](https://img.shields.io/badge/Documentation-Docs-green?style=for-the-badge&logo=gitbook)](https://github.com/moonshadowrev/eXtensibleSH/tree/main/docs)

</td>
<td width="25%" align="center">

[![Issues](https://img.shields.io/badge/Issues-GitHub-red?style=for-the-badge&logo=github)](https://github.com/moonshadowrev/eXtensibleSH/issues)

</td>
<td width="25%" align="center">

[![Discussions](https://img.shields.io/badge/Discussions-GitHub-purple?style=for-the-badge&logo=github)](https://github.com/moonshadowrev/eXtensibleSH/discussions)

</td>
</tr>
</table>

</div>

<br>

---

## 📄 License

<div align="center">

This project is licensed under the **GNU General Public License v3.0**

See the [LICENSE](LICENSE) file for details.

<br>

---

## 🙏 Acknowledgments

<table>
<tr>
<td width="33%" align="center">

**🤝 Contributors**
<br>
*Thank you to all our amazing contributors!*

</td>
<td width="33%" align="center">

**🌟 Community**
<br>
*Special thanks to the self-hosting community*

</td>
<td width="33%" align="center">

**💡 Inspiration**
<br>
*Built with love for open-source*

</td>
</tr>
</table>

<br>

---

<div align="center">

**Made with ❤️ by [moonshadowrev](https://github.com/moonshadowrev)**

<br>

⭐ **Star this repository if you find it helpful!** ⭐

<br>

---

<sub>
🚀 Ready to transform your self-hosting experience? 
<br>
<a href="#-quick-start">Get started now!</a>
</sub>

</div>

</div> 
