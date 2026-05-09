# FirmwareToolkit — Claude Code Project Context

Automation suite for ESP32/embedded firmware development with PlatformIO, Git, and CI/CD.

## Project Layout

```
FirmwareToolkit/
├── scripts/           # Build, flash, serial, and git automation (.bat + .py)
├── templates/         # PlatformIO project starters (esp32-basic, esp32-wifi)
├── git-hooks/         # Shell hooks: pre-commit, pre-push, commit-msg
├── ci-cd/             # GitHub Actions workflow template
├── testing/           # Serial test runner and performance benchmark
└── docs/              # Quick reference
```

## Key Conventions

- **Windows-first**: automation scripts are `.bat`; Python scripts run cross-platform.
- **PlatformIO**: all build/flash/test operations go through `pio` CLI.
- **Conventional commits** enforced by `git-hooks/commit-msg`. Format: `type(scope): description`.
- **No hardcoded credentials**: use `.env` → `include/config.h` via `scripts/env-manager.bat`.
- **Python deps**: `pip install -r requirements.txt` (pyserial only).

## Common Tasks

### Build & Flash
```batch
scripts\pio-full-cycle.bat esp32dev
```

### Serial Testing
```batch
python testing/serial-test.py -p COM3
python testing/performance-benchmark.py -p COM3 -d 60
```

### Create a New Project from Template
```batch
templates\create-project.bat
```

### Install Git Hooks (in a project repo)
```batch
%FIRMWARE_TOOLKIT_PATH%\git-hooks\install-hooks.bat
```

## CI/CD

`ci-cd/github-actions-esp32.yml` is a **template** to copy into a project's `.github/workflows/`.
- Triggers: push to `main`/`develop`, tags `v*`, PRs
- Jobs: build → test → static-analysis → release (tags only)
- Releases auto-detect pre-release from tag suffix (`-alpha`, `-beta`, `-rc`)

## Paired Project

[esp32-devops-mcp](https://github.com/JosephR26/esp32-devops-mcp) exposes these scripts as MCP tools so Claude can invoke them directly during a session.
