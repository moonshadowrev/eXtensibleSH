# eXtensibleSH Project Structure

This document explains the directory structure and organization of the eXtensibleSH project.

## 📁 Root Directory

```
eXtensibleSH/
├── .gitignore              # Git ignore rules
├── ex.sh                   # Main execution script
├── dev.sh                  # Plugin development tool
├── README.md               # Project documentation
├── LICENSE                 # Project license
├── CONTRIBUTING.md         # Contribution guidelines
├── CODE_OF_CONDUCT.md     # Community guidelines
├── SECURITY.md            # Security policy
├── docs/                  # Documentation directory
├── plugins/               # Plugin directory (organized by category)
├── thirdparty/           # Community scripts
├── hooks/                # Git hooks for code quality
├── logs/                 # Log files (with .gitkeep)
└── .github/              # GitHub templates and workflows
```

## 🔌 Plugin Directory Structure

The `plugins/` directory is organized by category to maintain clean separation of concerns:

```
plugins/
├── list.txt                    # Plugin registry
├── webservers/                # Web servers and reverse proxies
│   └── nginx/                 # NGINX plugin
│       ├── metadata.json
│       ├── debian/latest.sh
│       ├── rhel/latest.sh
│       └── arch/latest.sh
├── databases/                 # Database systems (.gitkeep)
├── containerization/          # Container platforms (.gitkeep)
├── monitoring/               # Monitoring tools (.gitkeep)
├── security/                 # Security tools (.gitkeep)
├── storage/                  # Storage solutions (.gitkeep)
├── development/              # Development tools
│   └── template/             # Plugin template (development_only: true)
│       ├── metadata.json
│       └── generic/latest.sh
├── networking/               # Network tools (.gitkeep)
└── backup/                   # Backup solutions (.gitkeep)
```

## 📋 Plugin Categories

### Active Categories
- **webservers**: NGINX, Apache, Caddy, etc.
- **development**: Development tools and templates

### Available Categories (with .gitkeep)
- **databases**: MySQL, PostgreSQL, MongoDB, etc.
- **containerization**: Docker, Kubernetes, Podman, etc.
- **monitoring**: Prometheus, Grafana, ELK stack, etc.
- **security**: Fail2ban, UFW, SSL certificates, etc.
- **storage**: NFS, Samba, MinIO, etc.
- **networking**: Network tools and configurations
- **backup**: Backup and recovery solutions

## 🗂️ Documentation Structure

```
docs/
├── index.html                 # GitHub Pages main page
├── index.md                   # Documentation index
├── usage.md                   # Usage instructions
├── how-to-create-plugin.md    # Plugin development guide
├── project-structure.md       # This file
└── image.webp                 # Documentation images
```

## 🌐 Third-party Directory

```
thirdparty/
├── README.md                  # Third-party documentation
├── list.txt                   # Third-party script registry
├── docker-install.sh          # Example script
└── portainer-install.sh       # Example script
```

## 🪝 Git Hooks

```
hooks/
├── README.md                  # Hook documentation
├── install.sh                 # Hook installation script
└── pre-commit                 # Pre-commit validation hook
```

## 📊 Logs Directory

```
logs/
├── .gitkeep                   # Preserves directory structure
└── exsh-log-*.log            # Log files (ignored by git)
```

## 🔧 GitHub Integration

```
.github/
├── workflows/                 # GitHub Actions
│   ├── test.yml
│   ├── update-plugin-list.yml
│   └── update-thirdparty-list.yml
├── ISSUE_TEMPLATE/           # Issue templates
│   ├── bug_report.yml
│   ├── feature_request.yml
│   ├── plugin_request.yml
│   └── config.yml
└── PULL_REQUEST_TEMPLATE.md  # PR template
```

## 📄 .gitkeep Files

### Purpose
`.gitkeep` files are used to preserve empty directories in git repositories. Since git doesn't track empty directories, these files ensure the project structure remains intact.

### Locations
- `logs/.gitkeep` - Preserves log directory
- `plugins/*/. gitkeep` - Preserves empty plugin categories

### Why This Matters
1. **Consistency**: All contributors see the same directory structure
2. **Development**: Plugin developers know where to place their plugins
3. **Automation**: Scripts can rely on directory existence
4. **Organization**: Clear separation of plugin categories

## 📁 Directory Purpose

| Directory | Purpose | Contains |
|-----------|---------|----------|
| `plugins/` | Plugin storage by category | Plugin scripts and metadata |
| `thirdparty/` | Community scripts | External scripts and registry |
| `docs/` | Documentation | User and developer guides |
| `hooks/` | Git hooks | Code quality validation |
| `logs/` | Log files | Execution logs (git-ignored) |
| `.github/` | GitHub integration | Templates and workflows |

## 🔄 Directory Lifecycle

### Plugin Development
1. Choose appropriate category in `plugins/`
2. Use `./dev.sh` to create plugin structure
3. Plugin automatically placed in correct category
4. `.gitkeep` files ensure category structure persists

### New Categories
1. Create new category directory in `plugins/`
2. Add `.gitkeep` file if initially empty
3. Update `plugins/list.txt` categories comment
4. Update documentation

## 🚀 Getting Started

1. **Clone the repository**
2. **Install git hooks**: `./hooks/install.sh`
3. **Explore plugins**: `ls plugins/`
4. **Create a plugin**: `./dev.sh`
5. **Check logs**: `ls logs/`

## 🛠️ Maintenance

### Adding New Categories
```bash
# Create new category directory
mkdir plugins/new-category

# Add .gitkeep file
touch plugins/new-category/.gitkeep

# Update plugins/list.txt categories comment
# Update documentation
```

### Removing Empty Categories
```bash
# Only remove if truly no longer needed
# Consider keeping with .gitkeep for future use
```

## 📚 Related Documentation

- [Plugin Development Guide](how-to-create-plugin.md)
- [Usage Instructions](usage.md)
- [Git Hooks Documentation](../hooks/README.md)
- [Contributing Guidelines](../CONTRIBUTING.md)

---

**This structure ensures a clean, organized, and maintainable project that scales with the community's needs.** 