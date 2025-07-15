#!/bin/bash

# NGINX Plugin for eXtensibleSH
# OS: arch (Arch Linux, Manjaro, etc.)
# Description: Installs, heavily customizes NGINX, and tunes kernel based on server profile.

# Parse arguments
while getopts ":l:s:" opt; do
  case $opt in
    l) LOG_FILE="$OPTARG" ;;
    s) USE_SUDO="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

if [ "$USE_SUDO" = "true" ]; then
    PREFIX="sudo "
else
    PREFIX=""
fi

exec >> "$LOG_FILE" 2>&1
echo "NGINX plugin for Arch started at $(date)"

# Install NGINX if not present
if ! command -v nginx >/dev/null 2>&1; then
  echo "Installing NGINX..."
  ${PREFIX}pacman -Syu --noconfirm nginx
fi

# Interactive profile choice
echo "Choose your server profile:"
select profile in "Low end server (1 vCPU + 4GB RAM)" "Mid level (4 vCPU + 16GB RAM)" "High level (8+ vCPU + 32GB+ RAM)"; do
  case $profile in
    "Low end server (1 vCPU + 4GB RAM)")
      echo "Tuning for low-end server"
      ${PREFIX}sed -i 's/worker_processes auto;/worker_processes 1;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/worker_connections 1024;/worker_connections 512;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i '/events {/a multi_accept off;' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/gzip on;/gzip off;/' /etc/nginx/nginx.conf
      # Kernel tuning
      ${PREFIX}sysctl -w fs.file-max=10000
      ${PREFIX}sysctl -w net.core.somaxconn=128
      ${PREFIX}sysctl -w net.ipv4.tcp_max_syn_backlog=128
      echo "fs.file-max=10000" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.core.somaxconn=128" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.ipv4.tcp_max_syn_backlog=128" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      ${PREFIX}sysctl --load=/etc/sysctl.d/99-nginx.conf
      ${PREFIX}systemctl restart nginx
      break
      ;;
    "Mid level (4 vCPU + 16GB RAM)")
      echo "Tuning for mid-level server"
      ${PREFIX}sed -i 's/worker_processes auto;/worker_processes 4;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/worker_connections 1024;/worker_connections 2048;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i '/events {/a multi_accept on;' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/gzip on;/gzip on;\n    gzip_types text/plain application/xml;' /etc/nginx/nginx.conf
      # Kernel tuning
      ${PREFIX}sysctl -w fs.file-max=50000
      ${PREFIX}sysctl -w net.core.somaxconn=512
      ${PREFIX}sysctl -w net.ipv4.tcp_max_syn_backlog=1024
      ${PREFIX}sysctl -w net.ipv4.tcp_fin_timeout=30
      echo "fs.file-max=50000" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.core.somaxconn=512" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.ipv4.tcp_max_syn_backlog=1024" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.ipv4.tcp_fin_timeout=30" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      ${PREFIX}sysctl --load=/etc/sysctl.d/99-nginx.conf
      ${PREFIX}systemctl restart nginx
      break
      ;;
    "High level (8+ vCPU + 32GB+ RAM)")
      echo "Tuning for high-level server"
      ${PREFIX}sed -i 's/worker_processes auto;/worker_processes auto;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/worker_connections 1024;/worker_connections 4096;/' /etc/nginx/nginx.conf
      ${PREFIX}sed -i '/events {/a multi_accept on;' /etc/nginx/nginx.conf
      ${PREFIX}sed -i 's/gzip on;/gzip on;\n    gzip_types *;\n    gzip_proxied any;' /etc/nginx/nginx.conf
      ${PREFIX}sed -i '/http {/a keepalive_timeout 65;' /etc/nginx/nginx.conf
      # Kernel tuning
      ${PREFIX}sysctl -w fs.file-max=100000
      ${PREFIX}sysctl -w net.core.somaxconn=1024
      ${PREFIX}sysctl -w net.ipv4.tcp_max_syn_backlog=2048
      ${PREFIX}sysctl -w net.ipv4.tcp_fin_timeout=15
      ${PREFIX}sysctl -w net.core.netdev_max_backlog=5000
      echo "fs.file-max=100000" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.core.somaxconn=1024" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.ipv4.tcp_max_syn_backlog=2048" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.ipv4.tcp_fin_timeout=15" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      echo "net.core.netdev_max_backlog=5000" | ${PREFIX}tee -a /etc/sysctl.d/99-nginx.conf
      ${PREFIX}sysctl --load=/etc/sysctl.d/99-nginx.conf
      ${PREFIX}systemctl restart nginx
      break
      ;;
    *) echo "Invalid selection" ;;
  esac
done

echo "NGINX and kernel tuned. Restarted NGINX."
echo "NGINX plugin completed at $(date)" 