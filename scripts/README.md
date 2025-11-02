# Fire-and-Forget Agent Scripts

Scripts for launching and managing background Cline agents using the **fire-and-forget pattern**.

## Quick Start

### Morning: Launch Background Workforce

```bash
./scripts/morning-agents.sh
```

Launches 15 background agents working on:
- Documentation (3 agents)
- Testing (4 agents)
- Code quality (5 agents)
- Refactoring (3 agents)

**Zero context cost!** Agents run independently while you focus on critical work.

### Evening: Review Results

```bash
./scripts/evening-review.sh
```

Review what agents accomplished and decide:
- ✅ Accept good work
- ⚠️ Fix minor issues
- ❌ Reject and queue for rework

## Available Scripts

### `morning-agents.sh`

Launch standard daily background workforce.

**Customization:** Edit the file to change which agents launch and what tasks they perform.

**Example tasks:**
- Documentation generation
- Test writing
- Code formatting
- Type hint additions
- Error handling improvements

### `evening-review.sh`

Review progress of all background agents.

Shows task list and provides guidance on reviewing results.

### `custom-agents-template.sh`

Template for creating project-specific agent launchers.

**Usage:**
1. Copy template: `cp custom-agents-template.sh my-project-agents.sh`
2. Edit file and uncomment/customize tasks
3. Make executable: `chmod +x my-project-agents.sh`
4. Run: `./my-project-agents.sh`

## Fire-and-Forget Pattern

### Concept

Launch background agents for low-risk mechanical tasks without monitoring them. Review results later when convenient.

**Key Benefits:**
- **Zero context cost** - No tokens consumed in parent session
- **Massive parallelization** - Launch dozens of agents
- **Risk-appropriate** - Only mechanical tasks
- **Check later** - Review when convenient

### What to Fire-and-Forget

**✅ GOOD (Low Risk):**
- Documentation generation
- Test writing (for existing code)
- Code formatting and linting
- Type hint additions
- Converting prints to logging
- Simple refactoring (consistent patterns)
- Dependency updates
- Configuration updates

**❌ BAD (High Risk):**
- Architecture changes
- Database migrations
- Security-critical code
- API contract changes
- Complex algorithms
- Anything that can cause data loss
- Production deployment changes

### Daily Workflow

**Morning (8 AM):**
```bash
./scripts/morning-agents.sh
# 5 minutes to launch 15 agents
```

**Day (8 AM - 5 PM):**
- Focus on critical work with Claude
- Background agents work independently
- Zero context cost!

**Evening (5 PM):**
```bash
./scripts/evening-review.sh
# 15 minutes to review results
```

## Three-Tier System

```
┌─────────────────────────────────────────┐
│   TIER 1: You + Claude (Interactive)   │
│   - Architecture & design               │
│   - Complex problem solving             │
│   WHEN: Day (your active hours)         │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│   TIER 2: Autonomous Supervisor         │
│   - Important implementation            │
│   - Critical workflows                  │
│   WHEN: Night (autonomous_supervisor.py)│
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│   TIER 3: Fire-and-Forget (Background) │
│   - Documentation, tests, formatting    │
│   - Low-risk mechanical work            │
│   WHEN: Day (background, zero context)  │
└─────────────────────────────────────────┘
```

## Examples

### Custom Documentation Sprint

```bash
#!/bin/bash
# docs-sprint.sh - Generate all project documentation

echo "📚 Documentation sprint..."

cline "Update main README.md with current features" --yolo --oneshot &
cline "Generate API documentation for all modules" --yolo --oneshot &
cline "Create CONTRIBUTING.md with development guidelines" --yolo --oneshot &
cline "Write architecture overview in docs/architecture.md" --yolo --oneshot &
cline "Generate changelog from git history" --yolo --oneshot &

echo "✅ Launched 5 documentation agents"
```

### Custom Testing Sprint

```bash
#!/bin/bash
# test-sprint.sh - Generate comprehensive test coverage

echo "🧪 Testing sprint..."

cline "Write unit tests for utils/ module" --yolo --oneshot &
cline "Write unit tests for components/ module" --yolo --oneshot &
cline "Add integration tests for API endpoints" --yolo --oneshot &
cline "Add edge case tests for validators" --yolo --oneshot &
cline "Add performance tests for database queries" --yolo --oneshot &

echo "✅ Launched 5 testing agents"
```

### Custom Code Quality Sprint

```bash
#!/bin/bash
# quality-sprint.sh - Improve code quality across project

echo "✨ Code quality sprint..."

cline "Add type hints to all untyped functions" --yolo --oneshot &
cline "Update all docstrings to Google style" --yolo --oneshot &
cline "Run black formatter on all Python files" --yolo --oneshot &
cline "Run isort to organize imports" --yolo --oneshot &
cline "Add missing error handling to all functions" --yolo --oneshot &
cline "Convert all print() to logging calls" --yolo --oneshot &

echo "✅ Launched 6 code quality agents"
```

## Tips

### Start Small

First time using fire-and-forget?
1. Launch just 2-3 agents
2. Review results carefully
3. Identify what works well
4. Scale up gradually

### Track Success Rates

Keep notes on which tasks succeed:
- Documentation: Usually 90%+ success
- Testing: Usually 85%+ success
- Formatting: Usually 95%+ success
- Refactoring: Varies, 50-80%

### Customize for Your Project

The template scripts are generic. Create project-specific scripts for:
- Your coding standards
- Your testing framework
- Your documentation style
- Your refactoring patterns

### Integration with Autonomous Supervisor

**Fire-and-forget (Tier 3):** Day work, low-risk, check later
**Autonomous supervisor (Tier 2):** Night work, important, monitored

Use both! They complement each other:
- Day: Fire-and-forget handles mechanical work
- Night: Supervisor handles critical implementation

## Troubleshooting

### Too Many Agents?

Start with 3-5 agents, not 15. Scale up as you learn the pattern.

### Low Success Rate?

Tasks might be too complex for fire-and-forget. Move to:
- Tier 2 (autonomous supervisor) for important work
- Tier 1 (interactive with Claude) for complex work

### How to Check Agent Status?

```bash
# List all tasks
cline task list

# View specific task
cline task view <task-id>

# View logs
cline logs
```

## See Also

- [Agent Orchestration Documentation](../docs/03-agent-orchestration.md) - Complete guide
- [autonomous_supervisor.py](../autonomous_supervisor.py) - Tier 2 scheduled supervisor
- [CLAUDE.md](../CLAUDE.md) - Project context

---

**Last Updated:** 2025-11-02
**Pattern:** Fire-and-Forget (Tier 3)
**Status:** Production ready
