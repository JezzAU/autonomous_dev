# CLAUDE.md - Autonomous Development Project

## Project Context

This is an **autonomous development supervisor** that enables continuous coding during unavailable hours (sleep, work) using Cline CLI + z.ai coding plan.

**Core Problem (Primary)**: Claude Code requires human intervention at milestones - even with Max plan, you cannot run truly autonomous overnight operations. Claude stops and waits for approval to continue.

**Core Problem (Secondary)**: Jeremy has 16-18 hours/day unavailable (8 hours sleep + 8 hours work), limiting interactive coding to 4-6 hours/day.

**Solution**: Cline CLI's `--yolo --oneshot` mode provides TRUE autonomy - runs to completion without human approval stops. This enables overnight development that Claude Code fundamentally cannot provide by design.

**Ethical Framework**:
- 8-10 hours/day max (matches realistic human usage)
- Night shift: 8 hours (10 PM - 6 AM while sleeping)
- Optional day shift: 2 hours (while at work)
- NOT gaming the system - filling availability gaps with same quota usage

## What's Been Done

### Windows Session (Previous)
- ✅ Created project structure
- ✅ Implemented `autonomous_supervisor.py` (332 lines)
- ✅ Created `task_queue.txt` template
- ✅ Created `AUTONOMOUS_DEVELOPMENT.md` (440 lines complete docs)
- ✅ Created `README.md` (quick start guide)
- ✅ Created `.gitignore`
- ✅ Initialized git repo and committed
- ❌ **Blocked**: Cline CLI install failed (Windows not supported, WSL path issues)

### Discovery
- **Cline CLI**: Open source (Apache 2.0), on z.ai approved tools list
- **Autonomous mode**: `--yolo --oneshot` flags (designed feature, not hack)
- **Platform**: macOS and Linux only (NOT Windows)
- **Requirements**: Node.js >= 20.0.0

## Current Status

**Location**: Mac (~/claude_projects/aiuml-dev/autonomous_dev/)
**Cline CLI**: ✅ Installed (v1.0.4)
**Authentication**: ✅ Configured with z.ai Coding Plan endpoint
**Testing**: ✅ Validated with autonomous tasks (test_hello.py, test_math.py)
**Ready**: System ready for production use

### Mac Session (Completed)
- ✅ Installed Cline CLI v1.0.4 (Node.js v24.10.0)
- ✅ Configured z.ai Coding Plan endpoint: `https://api.z.ai/api/coding/paas/v4/`
- ✅ Authenticated with API key (using openai-compatible provider)
- ✅ Tested autonomous mode with `--yolo --oneshot` flags
- ✅ Validated end-to-end: task → plan → implement → test → complete
- ✅ Confirmed using Coding Plan subscription (not pay-as-you-go API credits)

### Key Discovery: Heterogeneous Agent Pattern
**This isn't just about cost - it's about capabilities Claude Code doesn't offer.**

**Within Claude Code, you can now orchestrate:**
- **Claude agents** (via Task tool) - Complex reasoning, architecture, exploratory work
- **GLM-4.6 agents** (via Cline CLI) - TRUE autonomy for implementation work

**Already validated at production scale:**
- aiuml-forge: 116/116 methods implemented correctly by GLM-4.6
- Forced validation when Anthropic servers were down
- Proves: AIUML designs + pseudos provide sufficient guidance for cheaper models
- Enables: Use right model for right task (specialization, not single-LLM constraint)

## Key Files

### autonomous_supervisor.py
**Purpose**: Main autonomous development supervisor
**Key features**:
- Time-windowed execution (configurable hours)
- Task queue processing (FIFO)
- State persistence (.autonomous_state.json)
- Progress logging (autonomous_progress.log)
- Cline CLI integration (`cline task new --yolo --oneshot`)

**Configuration**:
```python
NIGHT_START = dt_time(22, 0)   # 10:00 PM
NIGHT_END = dt_time(6, 0)      # 6:00 AM
# 8 hours autonomous work per night
```

### task_queue.txt
**Purpose**: Task queue (one task per line, FIFO processing)
**Format**:
```
# One task per line
Implement StorageManager from forge.aiuml/design/components/storage.aiuml
Write unit tests for StorageManager
Run validation and fix any BLOCKED methods
```

### AUTONOMOUS_DEVELOPMENT.md
**Purpose**: Complete documentation (440 lines)
**Sections**:
- Quick Start (5 minutes)
- Configuration guide
- Capacity planning (Pro vs Max plan)
- Ethical use guidelines
- Integration with forge workflow
- FAQ and troubleshooting

### README.md
**Purpose**: Quick start guide for GitHub
**Highlights**:
- Problem statement (limited availability)
- Solution overview (autonomous supervisor)
- 5-minute quick start
- Ethical design (ToS compliant)

## Configuration Notes

### CRITICAL: z.ai Has Two Different API Endpoints

**Standard API (Pay-as-you-go):**
- Endpoint: `https://api.z.ai/api/paas/v4/`
- Pricing: Token-based (depletes API credits)
- ❌ DO NOT USE for Coding Plan subscription

**Coding Plan (Subscription):**
- Endpoint: `https://api.z.ai/api/coding/paas/v4/` ✅
- Pricing: Flat subscription ($15/mo Pro = 600 prompts/5hr cycle)
- ✅ USE THIS for autonomous development

### Cline CLI Authentication
```bash
# Configure with Coding Plan endpoint (IMPORTANT!)
cline auth --provider openai-compatible \
  --apikey YOUR_ZAI_API_KEY \
  --modelid glm-4.6 \
  --baseurl https://api.z.ai/api/coding/paas/v4/

# Verify configuration
cline config list | grep -A 2 "open-ai"
```

### Usage Examples

**Simple autonomous task:**
```bash
cline "Your task description here" --yolo --oneshot
```

**Run autonomous supervisor:**
```bash
# Add tasks to task_queue.txt, then:
python autonomous_supervisor.py
```

**Within Claude Code session (heterogeneous agents):**
```bash
# From Claude Code Bash tool:
cline "Implement feature X from design spec" --yolo --oneshot
```

## Two-Plan Architecture (Future)

**Plan 1** ($15/month Pro): Interactive development (Jeremy's day work)
**Plan 2** ($15/month Pro): Autonomous supervisor (night work)
**Total**: $30/month (same as Max plan, cleaner separation)

Benefits:
- Zero quota conflicts
- Clean separation of concerns
- Actually MORE ethical (independent usage tracking)

## Integration with AIUML Forge

This autonomous system is designed to work with the aiuml-forge refactoring:

**Workflow**:
1. Design component in AIUML with pseudos (Jeremy + Claude interactive)
2. Queue implementation tasks for autonomous supervisor
3. Supervisor processes queue overnight (Cline + z.ai GLM-4.6)
4. Morning: Review results, validate, iterate

**Why GLM-4.6 Works**:
- Already proved itself (implemented forge: 116/116 methods correctly)
- Near parity with Sonnet 4 (48.6% win rate)
- 9x cheaper than Sonnet 4
- AIUML designs + pseudos provide enough guidance

## Important Notes

**DO**:
- Use on Mac (native support)
- Configure time windows to match availability gaps
- Start with simple tasks to validate approach
- Monitor z.ai quota usage
- Review autonomous work each morning

**DON'T**:
- Try to force Windows install (not supported)
- Exceed 10 hours/day (ethical limit)
- Queue complex decision-making tasks (needs human)
- Skip validation of autonomous outputs

## Ethical Commitment

This tool uses Cline CLI's autonomous mode **as designed**. It respects z.ai's ToS by:
- Using approved tool (Cline CLI on approved list)
- Within fair use limits (10 hours/day = realistic human usage)
- Transparent usage (not hiding automation)
- Filling availability gaps, not gaming quota

**If you have concerns about usage patterns, contact z.ai support or adjust configuration.**

## Repository Status

```
Current branch: master
Recent commit: "Initial autonomous development supervisor implementation"
Status: Clean working directory
Location (Windows): D:\Claude_Workspace_2\Projects\autonomous_dev\
```

## Prompt for Next Session

**Hi Claude! I'm continuing work on the autonomous development supervisor.**

**Context**: We created an autonomous task supervisor for overnight development using Cline CLI + z.ai. All files are implemented, but Cline CLI install failed on Windows (not supported).

**Your task**:
1. We're now on Mac (Cline has native macOS support)
2. Install Cline CLI: `npm install -g cline`
3. Configure z.ai authentication
4. Run initial test task to validate the approach
5. Document any issues found

**Key file**: Read this CLAUDE.md for complete context (you're reading it now!)

**Ethical note**: This uses 8-10 hours/day during sleep/work hours - same quota as manual use, just different timing. Fully ToS compliant.

Let's get Cline working and test our autonomous development system!

---

**Last Updated**: 2025-11-02
**Session**: Mac installation and validation complete
**Status**: Production ready - autonomous supervisor validated and configured
**Key Insight**: Enables TRUE autonomy that Claude Code cannot provide (no milestone stops)
