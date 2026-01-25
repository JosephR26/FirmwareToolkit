# Quick Reference Guide

Essential commands and workflows for daily ESP32 firmware development.

**Note:** Replace `%FIRMWARE_TOOLKIT_PATH%` with your actual toolkit location, or set it as an environment variable.

## 🔨 Build & Flash Commands

```batch
# Build only
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-build.bat esp32dev

# Flash only
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-flash.bat esp32dev [COM3]

# Build + Flash + Monitor
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-full-cycle.bat esp32dev

# Monitor serial
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-monitor.bat esp32dev [COM3] [115200]

# Run tests
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-test.bat esp32dev

# Static analysis
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-check.bat esp32dev
```

## 📦 Project Setup

```batch
# Create new project
%FIRMWARE_TOOLKIT_PATH%\templates\create-project.bat

# Install Git hooks in existing project
cd your-project
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat

# Setup GitHub Actions
%FIRMWARE_TOOLKIT_PATH%\ci-cd\setup-github-actions.bat
```

## 🧪 Testing

```batch
# Serial tests
python %FIRMWARE_TOOLKIT_PATH%\testing\serial-test.py

# Performance benchmark (60s)
python %FIRMWARE_TOOLKIT_PATH%\testing\performance-benchmark.py -d 60

# Test runner (interactive)
%FIRMWARE_TOOLKIT_PATH%\testing\run-tests.bat

# Local CI test
%FIRMWARE_TOOLKIT_PATH%\ci-cd\local-ci-test.bat
```

## 🔀 Git Workflows

```batch
# Git workflow helper (interactive)
%FIRMWARE_TOOLKIT_PATH%\scripts\git-workflow-helper.bat

# Quick commands
git st                    # Short status
git lg                    # Pretty log
git amend                 # Amend last commit
git undo                  # Undo last commit (soft)
```

## 💻 System Optimization

```batch
# Optimize laptop for development
%FIRMWARE_TOOLKIT_PATH%\scripts\optimize-laptop.bat

# Clean temp files
%FIRMWARE_TOOLKIT_PATH%\scripts\clean-temp.bat

# Monitor resources
%FIRMWARE_TOOLKIT_PATH%\scripts\monitor-resources.bat
```

## 📋 Conventional Commits Format

```
type(scope): description

Examples:
feat(esp32): add deep sleep mode
fix(wifi): correct reconnection logic
perf(bluetooth): optimize BLE advertising
docs(readme): update installation steps
test(serial): add communication tests
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style
- `refactor`: Code refactoring
- `perf`: Performance
- `test`: Tests
- `build`: Build system
- `ci`: CI/CD
- `chore`: Maintenance

## 🎯 Daily Workflow

### Morning Startup
```batch
# 1. Pull latest changes
git pull

# 2. Check status
git st

# 3. Build to verify
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-build.bat esp32dev
```

### During Development
```batch
# 1. Quick build + flash + monitor
%FIRMWARE_TOOLKIT_PATH%\scripts\pio-full-cycle.bat esp32dev

# 2. In another terminal: monitor resources
%FIRMWARE_TOOLKIT_PATH%\scripts\monitor-resources.bat
```

### Before Committing
```batch
# 1. Test locally
%FIRMWARE_TOOLKIT_PATH%\ci-cd\local-ci-test.bat

# 2. Review changes
git diff

# 3. Commit (hooks run automatically)
git add .
git commit -m "feat(scope): description"
```

### End of Day
```batch
# 1. Push changes
git push

# 2. Clean temp files (optional)
%FIRMWARE_TOOLKIT_PATH%\scripts\clean-temp.bat
```

## 🚨 Emergency Commands

```batch
# Build failing? Deep clean
pio run --target clean
pio system prune --force
pio update

# Git hooks blocking? (fix issues first!)
git commit --no-verify

# Serial port stuck?
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# Reset Git hooks
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat
```

## ⌨️ Keyboard Shortcuts (VS Code)

```
Ctrl+Shift+B    - Build
Ctrl+Shift+T    - Run test
Ctrl+Shift+U    - Upload
Ctrl+Shift+M    - Serial monitor
F5              - Start debugging
```

## 📊 Performance Targets

```
Loop Time:      < 10ms  (excellent)
                < 50ms  (good)
                > 100ms (needs optimization)

Memory Leak:    < 5%    (good)
                < 10%   (acceptable)
                > 10%   (fix required)

WiFi RSSI:      > -50dBm (excellent)
                > -60dBm (good)
                > -70dBm (acceptable)
                < -70dBm (poor)
```

## 🔗 Useful Links

- PlatformIO Docs: https://docs.platformio.org/
- ESP32 Docs: https://docs.espressif.com/
- Conventional Commits: https://www.conventionalcommits.org/

---

**Print this page and keep it handy!** 📄
