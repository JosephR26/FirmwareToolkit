# AI Assistant Prompts for ESP32 Development

Optimized prompts for working with Claude, ChatGPT, Grok, Manus AI, Gemini, and DeepSeek on firmware projects.

> **Claude models (2025–2026):** Claude 4.x is the current family.
> - **Opus 4** (`claude-opus-4-7`) — highest capability, best for complex reasoning
> - **Sonnet 4** (`claude-sonnet-4-6`) — balanced speed/capability, recommended default
> - **Haiku 4** (`claude-haiku-4-5`) — fastest, lightest tasks
>
> Use Claude Code CLI (`claude`) or the [ESP32 DevOps MCP](https://github.com/JosephR26/esp32-devops-mcp) for hands-on development.

## 🤖 Claude Code (Primary Development Assistant)

### Project Setup
```
Create a new ESP32 project for [describe functionality] with WiFi, MQTT, and deep sleep capabilities.
Use the FirmwareToolkit and set up proper error handling and logging.
```

### Code Review
```
Review this ESP32 firmware code for:
- Memory leaks
- Security issues (hardcoded credentials, buffer overflows)
- Performance optimizations
- Power consumption improvements
- Embedded best practices
```

### Debugging
```
I'm getting [error message] when [describe scenario].
ESP32 board: [model]
Serial output: [paste output]
Help me debug this issue.
```

### Optimization
```
Optimize this ESP32 code for:
- Memory usage (currently using [X]% RAM)
- Battery life (target: [Y] hours)
- Response time (currently [Z]ms)
```

## 💬 ChatGPT (Architecture & Design)

### System Design
```
Design an ESP32 IoT system for [use case] that needs:
- [Feature 1]
- [Feature 2]
- [Feature 3]

Provide architecture diagram, component selection, and implementation plan.
```

### Algorithm Development
```
Create an efficient algorithm for [task] on ESP32 with:
- Limited RAM: [X]KB
- Real-time constraints: <[Y]ms
- Low power requirement
```

## 🚀 Grok (Research & Innovation)

### Latest Tech
```
What are the latest ESP32 libraries/techniques for [functionality] as of 2026?
Include performance benchmarks and code examples.
```

### Troubleshooting
```
ESP32 [specific issue] - find latest solutions, known bugs, and workarounds.
Check ESP-IDF forums, GitHub issues, and recent discussions.
```

## 🎨 Manus AI (UI/UX for Web Dashboards)

### Dashboard Design
```
Design a web dashboard for ESP32 device monitoring with:
- Real-time sensor data display
- Device configuration
- Firmware update interface
- Responsive design for mobile

Create HTML/CSS/JS code.
```

## 🔍 Gemini (Data Analysis & Documentation)

### Data Analysis
```
Analyze this ESP32 sensor data CSV:
[paste data or file]

Provide:
- Statistical summary
- Anomaly detection
- Performance trends
- Visualization recommendations
```

### Documentation
```
Generate comprehensive documentation for this ESP32 firmware:
[paste code or describe project]

Include:
- API reference
- Setup instructions
- Troubleshooting guide
- Architecture overview
```

## 🧠 DeepSeek (Code Generation & Refactoring)

### Code Generation
```
Generate ESP32 C++ code for [functionality] with:
- Async operation (no blocking)
- Error handling
- Memory efficient
- Well-commented
```

### Refactoring
```
Refactor this ESP32 code to:
- Reduce memory usage
- Improve readability
- Follow SOLID principles
- Add unit tests
```

## 🔄 Multi-AI Workflow Examples

### Complete Feature Development

**1. Claude Code (Planning)**
```
Plan the implementation of [feature] for ESP32 firmware.
List files to modify, functions to add, and testing strategy.
```

**2. ChatGPT (Architecture)**
```
Review this implementation plan and suggest architectural improvements.
Focus on scalability and maintainability.
```

**3. DeepSeek (Implementation)**
```
Implement the planned [feature] with production-ready code.
```

**4. Claude Code (Review)**
```
Review the implemented code using the /review skill.
Check for bugs, security issues, and optimizations.
```

**5. Gemini (Documentation)**
```
Document the new feature for end users and developers.
```

### Debugging Workflow

**1. Grok (Research)**
```
Search for ESP32 [error type] issues in 2026 knowledge base.
Find recent solutions and patches.
```

**2. Claude Code (Analysis)**
```
Analyze this error with toolkit diagnostics:
[run serial tests, performance benchmark]
```

**3. ChatGPT (Root Cause)**
```
Given this error pattern and system state, identify root cause:
[provide analysis from Claude]
```

**4. DeepSeek (Fix)**
```
Implement fix for [identified issue] with tests.
```

## 📊 AI Assistant Specializations

| Assistant | Best For | Use When |
|-----------|----------|----------|
| **Claude Code** | Hands-on development, debugging, toolkit execution | Writing/reviewing code, running builds |
| **ChatGPT** | Architecture, system design, algorithms | Planning major features |
| **Grok** | Latest tech, research, real-time info | Need cutting-edge solutions |
| **Manus AI** | UI/UX, web interfaces | Building dashboards |
| **Gemini** | Data analysis, documentation | Analyzing logs, writing docs |
| **DeepSeek** | Code generation, refactoring | Need production code fast |

## 🎯 Power User Tips

### Context Sharing
When moving between AI assistants, provide:
```
Project: ESP32 [project name]
Current task: [task]
Context: [relevant info]
Previous AI: [what previous AI suggested]
Need: [what you need now]
```

### Iterative Refinement
```
Claude: Generate initial implementation
ChatGPT: Review and suggest improvements
DeepSeek: Refactor with improvements
Claude: Final review and integration
```

### Parallel Tasking
```
Claude Code: Implement feature A
ChatGPT: Design feature B architecture
Gemini: Analyze existing data
DeepSeek: Refactor legacy code
```

## 💡 Quick Commands

### For Claude Code
- "Build and flash my ESP32 project"
- "Run all tests and analyze results"
- "Set up GitHub Actions"
- "Review my code for issues"

### For Others
- "Explain [ESP32 concept]" → ChatGPT/Gemini
- "Latest ESP32 [library] updates" → Grok
- "Generate UI for [feature]" → Manus AI
- "Refactor this to use async/await" → DeepSeek

---

**Your AI Team is Ready!** Use each assistant for their strengths and leverage Claude Code for hands-on development with the toolkit.
