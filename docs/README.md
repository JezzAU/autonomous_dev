# Autonomous Development Documentation

**Project**: Autonomous development supervisor using Cline CLI + z.ai GLM Coding Plan

**Purpose**: Enable TRUE autonomous development that Claude Code cannot provide (no milestone stops)

---

## Documentation Index

### Quick Start
- **[../README.md](../README.md)** - Project overview and quick start
- **[../CLAUDE.md](../CLAUDE.md)** - Claude Code session context and setup

### Detailed Documentation

#### 1. Getting Started
📍 *Coming soon* - Will be extracted from AUTONOMOUS_DEVELOPMENT.md
- Installation and setup
- First autonomous task
- Configuration basics

#### 2. Configuration
📍 *Coming soon* - Will be extracted from AUTONOMOUS_DEVELOPMENT.md
- z.ai Coding Plan endpoints (CRITICAL: use coding endpoint!)
- Cline CLI authentication
- autonomous_supervisor.py configuration
- Time windows and scheduling

#### 3. **[Agent Orchestration](./03-agent-orchestration.md)** ✅
**Complete and ready to use!**
- `.clinerules/` agent definition system
- Sub-agent capabilities (fresh context windows)
- Multi-agent orchestration patterns
- Mapping AIUML Forge workflow to Cline agents
- Practical examples and best practices

#### 4. Workflows
📍 *Coming soon*
- Four usage patterns (scripted, on-demand, hybrid, interactive)
- Heterogeneous agent orchestration (Claude + GLM-4.6)
- Integration with AIUML Architecture Driven Development
- Task queue patterns

#### 5. Reference
📍 *Coming soon* - Will be extracted from AUTONOMOUS_DEVELOPMENT.md
- Capacity planning (Pro vs Max plan)
- Troubleshooting
- API reference
- Ethical guidelines

---

## Current Status

### ✅ Completed
- Cline CLI installed and configured (v1.0.4)
- z.ai Coding Plan authentication working
- Autonomous mode validated (`--yolo --oneshot`)
- Agent orchestration capabilities documented
- Heterogeneous agent pattern validated (116/116 methods in aiuml-forge)

### 📍 In Progress
- Documentation reorganization
- Creating `.clinerules/` for forge workflow

### 🎯 Next Steps
1. Create `.clinerules/` structure for AIUML Forge agents
2. Port forge agents.md to Cline agent definitions
3. Test multi-agent workflows
4. Complete documentation reorganization

---

## Key Capabilities

### 1. **Scheduled Autonomous** (autonomous_supervisor.py)
Run task queue during unavailable hours (10 PM - 6 AM)

### 2. **On-Demand Agents** (from Claude Code)
```bash
cline "Implement feature X" --yolo --oneshot
```

### 3. **Multi-Agent Orchestration** (.clinerules)
Define specialized agents with strict workflows

### 4. **Heterogeneous Agents** (Claude + GLM-4.6)
- Claude: Architecture, exploration, complex reasoning
- GLM-4.6: Implementation, tests, documentation (TRUE autonomy!)

---

## Why This Matters

**Primary Problem**: Claude Code requires human intervention at milestones - even with Max plan, cannot run truly autonomous overnight operations.

**Solution**: Cline CLI's `--yolo --oneshot` mode provides TRUE autonomy - runs to completion without approval stops.

**This isn't about cost optimization** - it's about **capabilities Claude Code doesn't offer by design**.

---

## Documentation Organization Plan

```
autonomous_dev/
├── README.md                       # Quick start (GitHub convention)
├── CLAUDE.md                      # Claude Code context (stays at root)
├── docs/
│   ├── README.md                  # This file (index)
│   ├── 01-getting-started.md      # Installation, first task
│   ├── 02-configuration.md        # Setup and auth
│   ├── 03-agent-orchestration.md  # ✅ Agent definitions (COMPLETE)
│   ├── 04-workflows.md            # Usage patterns
│   └── 05-reference.md            # Troubleshooting, API docs
├── autonomous_supervisor.py
├── task_queue.txt
└── tests/
    ├── test_hello.py
    └── test_math.py
```

---

## Quick Links

### External Resources
- [Cline CLI Documentation](https://docs.cline.bot/cline-cli/overview)
- [z.ai Coding Plan](https://z.ai/model-api)
- [Cline .clinerules Guide](https://cline.bot/blog/clinerules-version-controlled-shareable-and-ai-editable-instructions)
- [Cline Prompts Repository](https://github.com/cline/prompts)

### Project Files
- [autonomous_supervisor.py](../autonomous_supervisor.py) - Main supervisor script
- [task_queue.txt](../task_queue.txt) - Task queue template
- [AUTONOMOUS_DEVELOPMENT.md](../AUTONOMOUS_DEVELOPMENT.md) - Original comprehensive docs

---

**Last Updated**: 2025-11-02
**Status**: Agent orchestration documented, ready for .clinerules implementation
