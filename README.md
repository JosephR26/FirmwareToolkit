# ESP32 Firmware Development Toolkit

Complete automation suite for ESP32/embedded firmware development with PlatformIO, Git, and CI/CD integration.

## 📦 Installation

Clone this toolkit to your preferred location:

```batch
git clone https://github.com/JosephR26/FirmwareToolkit.git
cd FirmwareToolkit
```

**Recommended location:** `%USERPROFILE%\Documents\FirmwareToolkit`

For convenience, you can set an environment variable:

```batch
setx FIRMWARE_TOOLKIT_PATH "%CD%"
```

## 📁 Directory Structure

```
FirmwareToolkit/
├── scripts/           # Build, flash, and automation scripts
├── templates/         # Project templates for quick start
├── git-hooks/         # Git hooks for code quality
├── ci-cd/             # GitHub Actions and CI/CD configs
├── testing/           # Testing and validation tools
└── docs/              # Documentation
```

## 🚀 Quick Start

### 1. Initial Setup

Run the complete environment setup:

```batch
scripts\setup-dev-environment.bat
```

This installs:
- Git, Python, Node.js (if missing)
- PlatformIO Core
- ESP32 platform and libraries
- VS Code extensions (if VS Code installed)

### 2. Configure Git

Optimize Git for firmware development:

```batch
scripts\configure-git.bat
```

### 3. Optimize Your Laptop

Improve compilation performance:

```batch
scripts\optimize-laptop.bat
```

### 4. Create a New Project

```batch
templates\create-project.bat
```

Choose from templates:
- **Basic ESP32**: Minimal setup with system info
- **WiFi ESP32**: WiFi-enabled with auto-reconnection
- **Custom**: Empty PlatformIO project

## 🔧 Development Workflow

### Building Firmware

```batch
# Navigate to your project
cd C:\path\to\your\project

# Build firmware
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-build.bat esp32dev

# Flash to device
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-flash.bat esp32dev

# Or do both in one command
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-full-cycle.bat esp32dev
```

### Monitoring Serial Output

```batch
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-monitor.bat esp32dev [PORT] [BAUDRATE]
```

### Running Tests

```batch
# Run unit tests
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-test.bat esp32dev

# Run static analysis
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-check.bat esp32dev

# Run automated serial tests
%FIRMWARE_TOOLKIT_PATH%\testing\run-tests.bat
```

## 🔒 Git Hooks (Automatic Quality Checks)

### Installing Hooks

From your project root:

```batch
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat
```

### What Hooks Do

**pre-commit** (runs before commit):
- ✅ Verifies code compiles
- ✅ Checks firmware size
- ✅ Scans for hardcoded credentials
- ✅ Detects common issues (Serial.print, delay(), etc.)
- ✅ Checks for large files

**pre-push** (runs before push):
- ✅ Full clean build
- ✅ Runs all tests
- ✅ Static code analysis

**commit-msg** (validates commit messages):
- ✅ Enforces conventional commits format
- ✅ Example: `feat(esp32): add deep sleep mode`

### Bypassing Hooks

```batch
git commit --no-verify
git push --no-verify
```

## 🤖 GitHub CI/CD

### Setup GitHub Actions

From your project root:

```batch
%FIRMWARE_TOOLKIT_PATH%\ci-cd\setup-github-actions.bat
```

This creates `.github/workflows/build.yml` which automatically:
- 🔨 Builds firmware on every push/PR
- ✅ Runs tests
- 📊 Performs static analysis
- 📦 Uploads firmware artifacts
- 🚀 Creates releases for tags

### Test CI Locally

Before pushing, test your build process:

```batch
%FIRMWARE_TOOLKIT_PATH%\ci-cd\local-ci-test.bat
```

## 📊 Testing & Validation

### Serial Communication Tests

Automated testing via serial port:

```batch
cd testing
python serial-test.py [-p PORT] [-b BAUDRATE]
```

Tests:
- ✅ Boot sequence detection
- ✅ Heartbeat verification
- ✅ Memory leak detection

### Performance Benchmarking

Collect and analyze performance metrics:

```batch
python performance-benchmark.py [-p PORT] [-d DURATION]
```

Analyzes:
- 📈 Memory usage over time
- ⚡ Loop execution times
- 📡 WiFi signal strength (RSSI)
- 🔍 CPU usage patterns

## 💻 Laptop Optimization

### Performance Optimization

```batch
scripts\optimize-laptop.bat
```

Configures:
- High performance power plan
- Disabled USB selective suspend (better serial stability)
- Optimized visual effects
- Background service priority

### Cleanup & Maintenance

```batch
# Clean temp files and build cache
scripts\clean-temp.bat

# Monitor system resources during builds
scripts\monitor-resources.bat
```

## 🔀 Git Workflow Helper

Interactive Git workflow assistant:

```batch
scripts\git-workflow-helper.bat
```

Features:
- Create feature branches
- Commit with conventional format
- Push to remote
- Create pull requests (via `gh`)
- Sync with main/develop
- View history and diffs

## ⚙️ Claude Code Integration

This toolkit works seamlessly with Claude Code! Use with the [ESP32 DevOps MCP](https://github.com/JosephR26/esp32-devops-mcp) for AI-powered automation.

### Environment Setup

Set the toolkit path for MCP integration:

```batch
setx FIRMWARE_TOOLKIT_PATH "%CD%"
```

## 📖 Common Workflows

### Starting a New Feature

```batch
# 1. Create project from template
templates\create-project.bat

# 2. Navigate to project
cd C:\path\to\new-project

# 3. Install Git hooks
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat

# 4. Create feature branch
git checkout -b feature/my-feature

# 5. Develop and test
# ... edit code ...
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-full-cycle.bat esp32dev

# 6. Commit (hooks validate automatically)
git add .
git commit -m "feat(esp32): add new feature"

# 7. Push and create PR
git push -u origin feature/my-feature
gh pr create
```

### Continuous Development Cycle

```batch
# 1. Build + Flash + Monitor in one command
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-full-cycle.bat esp32dev

# 2. In another terminal, monitor resources
%FIRMWARE_TOOLKIT_PATH%\scripts\monitor-resources.bat

# 3. Run performance benchmark
python %FIRMWARE_TOOLKIT_PATH%\testing\performance-benchmark.py -d 60
```

### Pre-Release Checklist

```batch
# 1. Run local CI test
%FIRMWARE_TOOLKIT_PATH%\ci-cd\local-ci-test.bat

# 2. Run full test suite
%FIRMWARE_TOOLKIT_PATH%\testing\run-tests.bat

# 3. Check firmware size
pio run --target size

# 4. Create tag and push
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## 🎯 Pro Tips

### Speed Up Builds

1. Use SSD for project files
2. Exclude `.pio` folder from antivirus
3. Run `optimize-laptop.bat` monthly
4. Clean cache: `pio system prune --force`

### Memory Optimization

1. Monitor heap during development
2. Use `performance-benchmark.py` to detect leaks
3. Review static analysis warnings: `pio check`
4. Test on actual hardware, not just serial

### Git Best Practices

1. Use conventional commits (enforced by hooks)
2. Keep commits atomic and focused
3. Run `local-ci-test.bat` before pushing
4. Use feature branches for new work

### CI/CD Optimization

1. Cache PlatformIO in GitHub Actions (already configured)
2. Run tests in parallel when possible
3. Use branch protection rules on `main`
4. Auto-deploy on tagged releases

## 🆘 Troubleshooting

### Build Fails

```batch
# Clean and rebuild
pio run --target clean
pio run

# Check PlatformIO
pio upgrade
pio update
```

### Serial Port Issues

```batch
# Disable USB selective suspend
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# List available ports
pio device list

# Use specific port
pio run --target upload --upload-port COM3
```

### Git Hooks Blocking Commits

```batch
# Fix the issues or bypass (not recommended)
git commit --no-verify

# Reinstall hooks
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat
```

### GitHub Actions Failing

```batch
# Test locally first
%FIRMWARE_TOOLKIT_PATH%\ci-cd\local-ci-test.bat

# Check workflow file
.github/workflows/build.yml

# View logs on GitHub
https://github.com/YOUR_USERNAME/YOUR_REPO/actions
```

## 📚 Additional Resources

- [PlatformIO Docs](https://docs.platformio.org/)
- [ESP32 Arduino Core](https://docs.espressif.com/projects/arduino-esp32/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Actions Docs](https://docs.github.com/actions)

## 🎓 Using with Claude Code

Ask Claude to:
- "Build and flash my ESP32 project"
- "Run the test suite on my firmware"
- "Create a new ESP32 project with WiFi"
- "Analyze my firmware performance"
- "Set up CI/CD for my project"
- "Review my embedded code for issues"

With the [ESP32 DevOps MCP](https://github.com/JosephR26/esp32-devops-mcp), Claude has access to all toolkit scripts and can execute them automatically!

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**JosephR26**
- GitHub: [@JosephR26](https://github.com/JosephR26)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

---

**Last Updated**: January 2026

Happy Firmware Development! 🚀
