# Third-Party Scripts

The `thirdparty` directory contains community-contributed scripts from various GitHub repositories that automatically install and configure services. These scripts are maintained by their respective authors and may have different structures and approaches compared to official eXtensibleSH plugins.

## ⚠️ Important Security Notice

**Third-party scripts are not officially maintained by eXtensibleSH.** Always review the source code before executing any third-party script. We are not responsible for any damage caused by third-party scripts.

## Directory Structure

```
thirdparty/
├── script-name.sh      # Individual script files
├── docker-install.sh   # Docker installation script
├── portainer-install.sh # Portainer monitoring UI
├── list.txt            # Registry of all third-party scripts
├── registry.json       # Auto-generated registry
└── README.md           # This documentation
```

## How to Add a Third-Party Script

### 1. Manual Addition

Add an entry to `thirdparty/list.txt` with the following format:
```
script-name:category:url:description
```

Example:
```
docker-install:containerization:https://github.com/user/repo/raw/main/docker-install.sh:Quick Docker installation script
```

### 2. Automatic Updates

Third-party scripts are automatically updated via GitHub Actions workflow. The workflow:
- Scans for new entries in `list.txt`
- Validates URLs are accessible
- Updates the registry
- Maintains the list in sorted order

## Script Requirements

For a script to be compatible with eXtensibleSH third-party system:

1. **Must be publicly accessible** via direct URL
2. **Must be executable** bash script
3. **Should include** basic error handling
4. **Should log** actions for debugging
5. **Should be** idempotent (safe to run multiple times)

## Categories

- **webservers**: NGINX, Apache, Caddy, etc.
- **databases**: MySQL, PostgreSQL, MongoDB, etc.
- **containerization**: Docker, Kubernetes, Podman, etc.
- **monitoring**: Prometheus, Grafana, ELK stack, etc.
- **security**: Fail2ban, UFW, SSL certificates, etc.
- **storage**: NFS, Samba, MinIO, etc.
- **misc**: Any other useful scripts

## Usage

Third-party scripts are accessible through the main eXtensibleSH interface:

```bash
# Interactive menu will show both plugins and third-party scripts
curl -s https://raw.githubusercontent.com/moonshadowrev/eXtensibleSH/main/ex.sh | bash
```

## Contributing

To contribute a third-party script:

1. Fork the repository
2. Add your script entry to `thirdparty/list.txt`
3. Create a pull request
4. Include:
   - Script name and description
   - Supported OS distributions
   - Testing information
   - Your contact information

## License

Each third-party script retains its original license. Please check the source repository for license information.

## Support

For issues with third-party scripts, please contact the original author. For issues with the third-party system itself, please [open an issue](https://github.com/moonshadowrev/eXtensibleSH/issues). 