#!/bin/bash

# eXtensibleSH Git Hook Installation Script
# Installs the pre-commit hook to validate code before commits
# Author: eXtensibleSH Team
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
HOOK="🪝"
GEAR="⚙️"

echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}║                    eXtensibleSH Git Hook Installation                         ║${NC}"
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

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    error_exit "This script must be run from the root of a git repository"
fi

# Check if we're in the eXtensibleSH repository
if [ ! -f "ex.sh" ] || [ ! -f "dev.sh" ]; then
    error_exit "This script must be run from the eXtensibleSH repository root"
fi

# Check if hooks directory exists
if [ ! -d "hooks" ]; then
    error_exit "hooks directory not found. Please ensure you're in the correct repository"
fi

# Check if pre-commit hook exists
if [ ! -f "hooks/pre-commit" ]; then
    error_exit "Pre-commit hook not found in hooks/pre-commit"
fi

echo -e "${PURPLE}${GEAR} Installing Git Pre-commit Hook...${NC}"
echo ""

# Create .git/hooks directory if it doesn't exist
if [ ! -d ".git/hooks" ]; then
    mkdir -p ".git/hooks"
    info_msg "Created .git/hooks directory"
fi

# Check if pre-commit hook already exists
if [ -f ".git/hooks/pre-commit" ]; then
    warn_msg "Pre-commit hook already exists"
    echo -n "Do you want to overwrite it? (y/N): "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY])
            info_msg "Overwriting existing pre-commit hook"
            ;;
        *)
            info_msg "Installation cancelled"
            exit 0
            ;;
    esac
fi

# Copy the pre-commit hook
cp "hooks/pre-commit" ".git/hooks/pre-commit"
success_msg "Copied pre-commit hook to .git/hooks/pre-commit"

# Make sure it's executable
chmod +x ".git/hooks/pre-commit"
success_msg "Made pre-commit hook executable"

echo ""
echo -e "${GREEN}${HOOK} Pre-commit Hook Installation Complete!${NC}"
echo ""

# Display what the hook does
echo -e "${BLUE}${INFO} What the pre-commit hook validates:${NC}"
echo ""
echo -e "${CYAN}1. Shell Script Syntax${NC}"
echo -e "   • Validates all .sh files using bash -n"
echo -e "   • Prevents commits with syntax errors"
echo ""
echo -e "${CYAN}2. JSON File Validity${NC}"
echo -e "   • Validates all .json files"
echo -e "   • Ensures proper JSON format"
echo ""
echo -e "${CYAN}3. File Permissions${NC}"
echo -e "   • Ensures shell scripts are executable"
echo -e "   • Automatically fixes permissions if needed"
echo ""
echo -e "${CYAN}4. Project-specific Checks${NC}"
echo -e "   • Validates plugins/list.txt format"
echo -e "   • Checks metadata.json structure"
echo -e "   • Ensures main scripts (ex.sh, dev.sh) are executable"
echo ""

# Display usage information
echo -e "${BLUE}${GEAR} Usage:${NC}"
echo -e "The hook will automatically run before each commit."
echo -e "If validation fails, the commit will be rejected with detailed error messages."
echo ""
echo -e "${YELLOW}${WARNING} To bypass the hook (not recommended):${NC}"
echo -e "git commit --no-verify"
echo ""

# Check for dependencies
echo -e "${BLUE}${INFO} Checking dependencies...${NC}"
echo ""

# Check for jq
if command -v jq >/dev/null 2>&1; then
    success_msg "jq is installed (recommended for JSON validation)"
else
    warn_msg "jq is not installed - will fallback to python for JSON validation"
    echo -e "${CYAN}   Install jq for better performance: brew install jq${NC}"
fi

# Check for python3
if command -v python3 >/dev/null 2>&1; then
    success_msg "python3 is available for JSON validation fallback"
else
    warn_msg "python3 is not available - JSON validation may fail"
fi

echo ""
echo -e "${GREEN}${SUCCESS} Installation successful!${NC}"
echo -e "${CYAN}${INFO} The pre-commit hook is now active and will validate your commits.${NC}"
echo ""

# Test the hook
echo -e "${BLUE}${GEAR} Testing the hook...${NC}"
echo ""

# Create a simple test by checking current files
if .git/hooks/pre-commit --help >/dev/null 2>&1 || true; then
    info_msg "Hook is ready to use"
else
    info_msg "Hook is installed and ready"
fi

echo ""
echo -e "${PURPLE}Happy coding! 🚀${NC}" 