# eXtensibleSH Git Hooks

This directory contains Git hooks to maintain code quality and consistency in the eXtensibleSH project.

## 🪝 Available Hooks

### Pre-commit Hook

The pre-commit hook validates code before each commit to ensure:
- ✅ Shell script syntax correctness
- ✅ JSON file validity
- ✅ Proper file permissions
- ✅ Project-specific requirements

## 🚀 Quick Installation

```bash
# Install the pre-commit hook
./hooks/install.sh
```

## 📋 What the Pre-commit Hook Validates

### 1. **Shell Script Syntax**
- Validates all `.sh` files using `bash -n`
- Prevents commits with syntax errors
- Shows detailed error messages for debugging

### 2. **JSON File Validity**
- Validates all `.json` files
- Uses `jq` if available, falls back to `python3`
- Ensures proper JSON format

### 3. **File Permissions**
- Ensures shell scripts are executable
- Automatically fixes permissions if needed
- Adds fixed files back to the commit

### 4. **Project-specific Checks**
- **Main Scripts**: Ensures `ex.sh` and `dev.sh` are executable
- **Plugin List**: Validates `plugins/list.txt` format (`name:category:os`)
- **Metadata Files**: Checks `metadata.json` structure in plugins
- **Required Fields**: Validates required fields in plugin metadata

## 🔧 Manual Installation

If you prefer to install the hook manually:

```bash
# Copy the hook to your git hooks directory
cp hooks/pre-commit .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

## 📊 Hook Output Example

```
🪝 eXtensibleSH Pre-commit Hook
═══════════════════════════════════════

Checking staged files...

1. Checking shell script syntax...
  Checking dev.sh... ✅ Valid syntax
  Checking ex.sh... ✅ Valid syntax
  Checking plugins/webservers/nginx/debian/latest.sh... ✅ Valid syntax

2. Checking JSON file validity...
  Checking plugins/webservers/nginx/metadata.json... ✅ Valid JSON
  Checking plugins/template/metadata.json... ✅ Valid JSON

3. Checking executable permissions...
  Checking dev.sh permissions... ✅ Executable
  Checking ex.sh permissions... ✅ Executable

4. Checking project-specific requirements...
  Checking plugins/list.txt format... ✅ Valid plugins list format

═══════════════════════════════════════
🪝 Pre-commit Hook Summary
═══════════════════════════════════════

Total files checked: 5
Passed: 5
Failed: 0

✅ All checks passed! Commit proceeding...
```

## ⚠️ Bypassing the Hook

**Not recommended**, but you can bypass the hook if needed:

```bash
git commit --no-verify
```

## 🔍 Dependencies

The hook works best with these tools installed:

### Required
- `bash` - Shell script validation
- `git` - Version control operations

### Recommended
- `jq` - Fast JSON validation
- `python3` - Fallback JSON validation

### Installation
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq
```

## 🛠️ Troubleshooting

### Hook Not Running
```bash
# Check if hook is installed
ls -la .git/hooks/pre-commit

# Check if hook is executable
chmod +x .git/hooks/pre-commit
```

### Permission Errors
```bash
# Fix permissions for the hook
chmod +x .git/hooks/pre-commit

# Fix permissions for project scripts
chmod +x ex.sh dev.sh
find plugins -name "*.sh" -exec chmod +x {} \;
```

### JSON Validation Issues
```bash
# Install jq for better JSON validation
brew install jq  # macOS
sudo apt-get install jq  # Ubuntu/Debian

# Or ensure python3 is available
python3 --version
```

## 🔧 Customization

You can modify the hook behavior by editing `hooks/pre-commit`:

### Adding New Validations
```bash
# Add new validation section
echo -e "${BLUE}5. Checking custom requirements...${NC}"
# Your custom validation logic here
```

### Modifying File Patterns
```bash
# Change which files are checked
shell_scripts=$(echo "$staged_files" | grep -E '\.(sh|bash)$' || true)
```

### Project-specific Rules
```bash
# Add specific rules for your project
if echo "$staged_files" | grep -q "specific-file.txt"; then
    # Custom validation for specific files
fi
```

## 📚 Integration with Development Workflow

### For Plugin Development
1. Create a new plugin using `./dev.sh`
2. Edit the generated files
3. Commit your changes - the hook will validate everything
4. Submit your pull request

### For Core Development
1. Make changes to core files (`ex.sh`, `dev.sh`, etc.)
2. Run syntax checks manually: `bash -n filename.sh`
3. Commit - the hook provides additional validation
4. Push to your branch

## 🤝 Contributing

To contribute to the hook system:

1. **Fork the repository**
2. **Make your changes** to `hooks/pre-commit`
3. **Test thoroughly** with various scenarios
4. **Update documentation** if needed
5. **Submit a pull request**

### Testing the Hook
```bash
# Test with various file types
touch test.sh test.json
git add test.sh test.json
git commit -m "Test commit"  # Hook will run

# Test with syntax errors
echo "if [ incomplete" > test.sh
git add test.sh
git commit -m "Test error"  # Hook should fail
```

## 📄 License

This hook system is part of the eXtensibleSH project and is licensed under the GNU General Public License v3.0.

## 🔗 Related Documentation

- [Plugin Development Guide](../docs/how-to-create-plugin.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [Project README](../README.md)

---

**Made with ❤️ by the eXtensibleSH Team** 