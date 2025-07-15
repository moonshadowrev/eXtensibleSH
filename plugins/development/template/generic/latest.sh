#!/bin/bash

# Template Plugin for eXtensibleSH
# Plugin Name: template
# OS: generic
# Description: This is a template for creating new plugins. Replace with actual functionality.

# Parse arguments (e.g., --log, --use-sudo)
while getopts ":l:s:" opt; do
  case $opt in
    l) LOG_FILE="$OPTARG" ;;
    s) USE_SUDO="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Set command prefix
if [ "$USE_SUDO" = "true" ]; then
    PREFIX="sudo "
else
    PREFIX=""
fi

# Append to log
exec >> "$LOG_FILE" 2>&1
echo "Template plugin started for generic OS at $(date)"

# Example interactive choice
echo "Choose your server profile:"
select profile in "Low end" "Mid level" "High level"; do
  case $profile in
    "Low end") 
      echo "Tuning for low-end server"
      # Add tuning commands here, e.g., install packages, configure files
      # Example: ${PREFIX}apt update || ${PREFIX}yum update -y
      break
      ;;
    "Mid level") 
      echo "Tuning for mid-level server"
      # Add commands
      break
      ;;
    "High level") 
      echo "Tuning for high-level server"
      # Add commands
      break
      ;;
    *) echo "Invalid option" ;;
  esac
done

# Error handling
trap 'echo "Error in plugin at line $LINENO"; exit 1' ERR

# Your plugin logic here (install, configure, etc.)
# Remember to use OS-agnostic commands or detect further if needed.
# Avoid hardcoding; use variables.

echo "Template plugin completed at $(date)" 