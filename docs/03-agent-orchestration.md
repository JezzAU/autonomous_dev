# Agent Orchestration with Cline

**Last Updated**: 2025-11-02
**Status**: Production capabilities documented

## Overview

Cline provides powerful multi-agent orchestration capabilities through `.clinerules` and sub-agent delegation. This enables systematic workflow automation that goes beyond simple task execution to create hierarchical agent systems.

**Key Capabilities:**
- ✅ Define custom agents via `.clinerules/` directory
- ✅ Sub-agent delegation with fresh context windows
- ✅ Hierarchical agent workflows (agent → sub-agent → sub-sub-agent)
- ✅ Integration with Claude Code for heterogeneous agent patterns
- ✅ Version-controlled, shareable agent definitions

## Table of Contents

1. [Agent Definition System (.clinerules)](#agent-definition-system)
2. [Sub-Agent Capabilities](#sub-agent-capabilities)
3. [Multi-Agent Orchestration Patterns](#multi-agent-orchestration-patterns)
4. [Mapping Forge Workflow to Cline](#mapping-forge-workflow-to-cline)
5. [Practical Examples](#practical-examples)
6. [Best Practices](#best-practices)

---

## Agent Definition System

### The `.clinerules/` Directory

Cline uses **`.clinerules/`** - a directory of Markdown files that define agent behaviors, workflows, and knowledge. These files are:

- **Version controlled** - Commit to git with full history
- **Shareable** - Team members get consistent agent behaviors
- **AI-editable** - Cline can modify its own rule files
- **Modular** - Each file focuses on one topic/workflow
- **Toggleable** - Activate/deactivate rules on the fly

### Project Structure

```
your_project/
├── .clinerules/
│   ├── agents/
│   │   ├── 01-architect-agent.md
│   │   ├── 02-implementer-agent.md
│   │   └── 03-validator-agent.md
│   ├── workflows/
│   │   ├── full-feature-workflow.md
│   │   └── quick-implementation.md
│   └── context/
│       ├── architecture.md
│       ├── coding-standards.md
│       └── aiuml-notation.md
├── AGENTS.md                    # Standard format (optional, cross-tool compatibility)
└── your_code/
```

### Rule File Format

Every `.clinerules` file uses this structure:

```yaml
---
description: Brief explanation of the rule's purpose
author: Your Name/Handle
version: 1.0
globs: ["**/pattern.js", "config.json"]  # Optional: file patterns this rule applies to
tags: ["category", "workflow"]            # Optional: categorization
---

# Rule Title

## Your Content Here

Markdown content with instructions, workflows, context, etc.
```

### Four Rule Types

#### 1. **Informational/Documentation Rules**

Comprehensive system overviews, architecture explanations, and definitions.

**Use for:**
- System architecture documentation
- AIUML notation specifications
- Component design patterns
- Key terminology definitions

**Example:**
```markdown
---
description: AIUML notation reference for component design
author: Jeremy
version: 1.0
tags: ["aiuml", "documentation", "reference"]
---

# AIUML Notation Reference

## Component Structure
Components are defined with:
- Class declarations with metaclass specifications
- Method signatures with type hints
- Pseudos for implementation guidance
- Token compression ratios (10-100x vs code)

## Example Component
<AIUML notation example>

## Token Compression
AIUML achieves 10-100x compression by...
```

#### 2. **Process/Workflow Rules**

Sequential step-by-step instructions with clear start and endpoints.

**Use for:**
- Multi-step development workflows
- Feature implementation sequences
- Testing protocols
- Deployment procedures

**Structure:**
- Clear numbered steps
- Decision points with conditions
- Tool specifications (which Cline tools to use)
- Expected inputs and outputs
- Success criteria

**Example:**
```markdown
---
description: AIUML component implementation workflow
author: Jeremy
version: 1.0
tags: ["workflow", "implementation", "aiuml"]
---

# AIUML Component Implementation Workflow

## Workflow Steps

### Step 1: Read Design Specification
1. Locate the `.aiuml` design file in `design/` directory
2. Use `read_file` tool to load the specification
3. Parse component structure, methods, and pseudos
4. Verify all pseudos are present and complete

### Step 2: Validate Design
1. Check that design follows AIUML notation standards
2. Verify all methods have type hints and pseudos
3. MUST NOT proceed if pseudos are missing or incomplete
4. Report validation status

### Step 3: Delegate Implementation
**Decision Point**: If design is valid, delegate to implementer agent

```bash
cline "Implement <ComponentName> from design/<file>.aiuml. Follow implementer-agent rules." \
  --yolo --oneshot
```

### Step 4: Wait for Completion
- Sub-agent runs to completion
- Review implementation output
- Proceed to validation step

### Step 5: Delegate Validation
```bash
cline "Validate <ComponentName> implementation against design/<file>.aiuml. Follow validator-agent rules." \
  --yolo --oneshot
```

## Success Criteria
✅ All pseudos implemented as code
✅ Type hints preserved
✅ Tests passing
✅ Validation complete
```

#### 3. **Behavioral/Instructional Rules**

Direct AI guidance using imperative language with strict directives.

**Use for:**
- Coding standards enforcement
- Security requirements
- Critical constraints
- Error prevention

**Language:**
- **MUST** = absolute requirement (non-negotiable)
- **SHOULD** = strong recommendation (preferred approach)
- **MAY** = optional (contextual choice)
- **MUST NOT / NEVER** = prohibition (never do this)

**Visual markers:**
- 🚨 Critical warnings
- ⚠️ Important cautions
- ❌ Don't do this
- ✅ Do this instead

**Example:**
```markdown
---
description: Implementer agent behavioral rules
author: Jeremy
version: 1.0
tags: ["agent", "behavior", "implementation"]
---

# Implementer Agent Behavior

## Role Definition
You are the **Implementer Agent**. Your ONLY responsibility is translating AIUML pseudos into production code.

## Critical Rules

### 🚨 MUST Requirements

1. **MUST** read the complete `.aiuml` design file before starting
2. **MUST** implement every pseudo exactly as specified
3. **MUST** preserve all type hints from design
4. **MUST** create implementation in correct directory (`src/components/`)
5. **MUST** use `write_to_file` for new implementations

### ⚠️ SHOULD Guidelines

1. **SHOULD** add docstrings that reference the design pseudo
2. **SHOULD** include inline comments for complex logic
3. **SHOULD** follow Python PEP-8 standards
4. **SHOULD** use descriptive variable names

### ❌ NEVER / MUST NOT

1. **NEVER** modify the design `.aiuml` file
2. **NEVER** skip pseudos or mark methods as TODO/BLOCKED
3. **NEVER** change method signatures from design
4. **NEVER** add features not specified in design
5. **NEVER** delegate to other agents (stay in your lane)

## Code Examples

### ✅ Correct Implementation
```python
def process_data(self, data: List[Dict]) -> ProcessedData:
    """Process input data according to design spec.

    Pseudo: Filter invalid entries, transform to ProcessedData format
    """
    # Filter invalid entries (missing required fields)
    valid_entries = [d for d in data if self._is_valid(d)]

    # Transform to ProcessedData format
    return ProcessedData(entries=valid_entries)
```

### ❌ Incorrect Implementation
```python
def process_data(self, data):  # ❌ No type hints
    # TODO: Implement this later  # ❌ Skipping pseudo
    pass
```

## Tool Usage

**Allowed tools:**
- `read_file` - Read design specifications
- `write_to_file` - Create implementation files
- `execute_command` - Run validation scripts only

**Forbidden tools:**
- `ask_followup_question` - Implementation should be deterministic from design
- Bash commands for delegation - No sub-agents allowed

## Completion Criteria

Before using `attempt_completion`:
1. <thinking>Verify all pseudos are implemented</thinking>
2. <thinking>Confirm type hints match design</thinking>
3. <thinking>Check file is in correct location</thinking>
4. Report implementation summary with file path
```

#### 4. **Meta-Rules**

Define how Cline improves its own processes and rules.

**Use for:**
- Self-improvement workflows
- Rule refinement protocols
- Learning from errors
- Process optimization

**Example:**
```markdown
---
description: Self-improving agent meta-rules
author: Jeremy
version: 1.0
tags: ["meta", "improvement", "learning"]
---

# Self-Improving Agent Protocol

## When to Self-Improve

**Triggers:**
1. User explicitly requests rule refinement
2. Repeated errors in same category (3+ occurrences)
3. User provides feedback on workflow inefficiency
4. New patterns emerge from completed tasks

## Improvement Process

### Step 1: Identify Improvement Need
- What went wrong or could be better?
- Which rule file needs updating?
- What specific change would help?

### Step 2: Propose Changes
```markdown
I suggest updating `.clinerules/agents/implementer-agent.md`:

**Change:** Add requirement to run type checker before completion

**Reason:** Last 3 implementations had type errors caught in validation

**New rule section:**
### Type Checking Requirement
**MUST** run `mypy <file>` before using `attempt_completion`
```

### Step 3: Get User Approval
- Wait for user confirmation
- Explain impact of proposed change

### Step 4: Update Rule File
```bash
# Use edit_file to modify the rule
<edit the .clinerules file>
```

### Step 5: Validate Change
- Read updated rule back
- Confirm change is correct
- Document in version history

## Learning Patterns

Keep mental note of:
- Which rules prevent errors most effectively
- Which workflows complete fastest
- Which agent combinations work best
- Common user preferences

Use this to suggest proactive improvements.
```

---

## Sub-Agent Capabilities

### Fresh Context Window Delegation

**Cline agents can launch sub-agents with fresh context windows!**

From Cline Blog (Nov 2025):
> "IDE Cline can call the Cline CLI to delegate tasks with a fresh context window. In this first version, Cline is instructed to use one sub-cline at a time, and to wait until the sub-cline completes."

### Current Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **JetBrains IDEs** | ✅ Available | Full sub-agent delegation support |
| **VS Code** | ⏳ Coming Soon | In development |
| **CLI → CLI** | ✅ Available | Manual delegation via bash (works now) |
| **Claude Code → Cline** | ✅ Available | Via Bash tool (our use case!) |

### Delegation Patterns

#### Pattern 1: Sequential Sub-Agents (Wait for Completion)

```markdown
### Workflow Step: Implement Component

1. Delegate to implementer sub-agent:
```bash
cline "Implement StorageManager from design/storage.aiuml" --yolo --oneshot
```

2. Wait for sub-agent to complete
3. Review implementation output
4. Proceed to next step (validation)
```

**Key characteristic:** One sub-agent at a time, sequential execution

#### Pattern 2: Parallel Sub-Agents (Background Tasks)

```markdown
### Workflow Step: Generate Documentation and Tests

Launch parallel sub-agents:

```bash
# Documentation agent (background)
cline "Generate API documentation for StorageManager" --yolo --oneshot &

# Test agent (background)
cline "Write unit tests for StorageManager" --yolo --oneshot &

# Wait for both to complete
wait
```
```

**Key characteristic:** Multiple sub-agents running concurrently

#### Pattern 3: Hierarchical Delegation (Multi-Level)

```markdown
### Master Agent Workflow

**Level 1 (Master Agent):**
- Reads project requirements
- Designs high-level architecture
- Delegates to Component Agents

**Level 2 (Component Agents):**
```bash
# Each component gets its own agent
cline "Design StorageManager component" --yolo --oneshot
cline "Design ValidationEngine component" --yolo --oneshot
```

**Level 3 (Sub-Component Agents):**
- Component agents further delegate:
  - Implementation sub-agent
  - Testing sub-agent
  - Documentation sub-agent
```

**Key characteristic:** Agent hierarchy, delegation chains

### Context Management

**Why Fresh Context Windows Matter:**

1. **Avoid context pollution** - Each sub-agent starts clean
2. **Focus on specific task** - No distractions from parent context
3. **Scale beyond limits** - Parent at 150K tokens? Sub-agent starts at 0
4. **Parallel specialization** - Different agents need different context

**Example:**
```
Parent Agent Context (150K tokens):
- Entire codebase exploration
- Architecture discussions
- Design iterations

Sub-Agent Context (5K tokens):
- Single .aiuml design file
- Implementation rules
- Coding standards

Result: Sub-agent is focused, efficient, fast
```

---

## Multi-Agent Orchestration Patterns

### Pattern 1: Pipeline (Sequential Agents)

**Use case:** Each step depends on previous step's output

```
Design Agent → Implementation Agent → Validation Agent → Test Agent
     ↓                ↓                      ↓                ↓
  .aiuml file    Python code          Validation report    Test suite
```

**Implementation:**
```markdown
# .clinerules/workflows/pipeline-workflow.md

## Pipeline Workflow

### Step 1: Design
```bash
cline "Design <Component> following AIUML notation" --yolo --oneshot
```
Output: `design/<component>.aiuml`

### Step 2: Implement
```bash
cline "Implement <Component> from design/<component>.aiuml" --yolo --oneshot
```
Output: `src/components/<component>.py`

### Step 3: Validate
```bash
cline "Validate <Component> implementation against design" --yolo --oneshot
```
Output: Validation report

### Step 4: Test
```bash
cline "Write comprehensive tests for <Component>" --yolo --oneshot
```
Output: `tests/test_<component>.py`
```

### Pattern 2: Fan-Out (Parallel Specialization)

**Use case:** Independent tasks that can run concurrently

```
            Master Agent
                 ↓
        ┌────────┼────────┐
        ↓        ↓        ↓
   Component A  Component B  Component C
   Implementation Implementation Implementation
```

**Implementation:**
```bash
# Launch all component implementations in parallel
cline "Implement ComponentA from design/a.aiuml" --yolo --oneshot &
cline "Implement ComponentB from design/b.aiuml" --yolo --oneshot &
cline "Implement ComponentC from design/c.aiuml" --yolo --oneshot &

# Wait for all to complete
wait

# Proceed to integration
cline "Integrate components A, B, C" --yolo --oneshot
```

### Pattern 3: Supervisor (Orchestrator Agent)

**Use case:** Complex workflow with dynamic delegation

```
        Supervisor Agent
              ↓
     ┌────────┼────────┐
     ↓        ↓        ↓
  Worker 1  Worker 2  Worker 3
     ↓        ↓        ↓
   Reports results back
     ↓
  Supervisor decides next steps
```

**Implementation:**
```markdown
# .clinerules/agents/supervisor-agent.md

## Supervisor Agent Responsibilities

1. **Analyze Requirements** - Understand full scope
2. **Plan Delegation** - Decide which agents to use
3. **Delegate Tasks** - Launch appropriate sub-agents
4. **Monitor Progress** - Review sub-agent outputs
5. **Integrate Results** - Combine outputs into coherent whole
6. **Decide Next Steps** - Adaptive workflow based on results

## Delegation Decision Tree

```
Is this a design task?
├─ YES → Delegate to Architect Agent
└─ NO → Is this implementation?
    ├─ YES → Delegate to Implementer Agent
    └─ NO → Is this validation?
        ├─ YES → Delegate to Validator Agent
        └─ NO → Handle directly or ask user
```

## Example Supervision Flow

```bash
# Step 1: Analyze (Supervisor does this)
# Supervisor reads requirements, understands scope

# Step 2: Delegate design
cline "Design system architecture for <feature>" --yolo --oneshot

# Step 3: Review design output, decide on components
# Supervisor analyzes design, identifies 3 components needed

# Step 4: Delegate component implementations
cline "Implement ComponentA..." --yolo --oneshot &
cline "Implement ComponentB..." --yolo --oneshot &
cline "Implement ComponentC..." --yolo --oneshot &
wait

# Step 5: Supervisor reviews all implementations
# Identifies integration needs

# Step 6: Delegate integration
cline "Integrate components A, B, C" --yolo --oneshot

# Step 7: Final validation
cline "Run full system validation" --yolo --oneshot
```
```

### Pattern 4: Heterogeneous (Multi-Model Orchestration)

**Use case:** Use different models for different strengths

```
Claude Code (Interactive)
    ↓
Claude Agent (Architecture, Exploration) ←→ GLM-4.6 Agent (Implementation)
    ↓                                           ↓
Design Review                              Code Output
```

**Implementation:**
```markdown
# Within Claude Code session:

## Phase 1: Architecture (Claude)
User + Claude: Explore codebase, design solution

## Phase 2: Implementation (GLM-4.6 via Cline)
```bash
cline "Implement feature X from design spec" --yolo --oneshot
```

## Phase 3: Review (Claude)
Claude: Review implementation, validate architecture compliance

## Phase 4: Testing (GLM-4.6 via Cline)
```bash
cline "Write comprehensive tests for feature X" --yolo --oneshot
```

## Phase 5: Final Validation (Claude)
Claude: Final review, integration testing, approval
```

**Why this works:**
- Claude: Superior at complex reasoning, exploration, architecture
- GLM-4.6: Validated at implementation (116/116 methods in aiuml-forge)
- Cost: Claude for high-value tasks, GLM-4.6 for mechanical work
- **Autonomy**: GLM-4.6 via Cline runs to completion (no milestone stops!)

### Pattern 5: Fire-and-Forget (Zero-Context Background Agents)

**Use case:** Non-critical mechanical tasks that don't need monitoring - check results later

**The Breakthrough:** Launch background agents without consuming parent context or waiting for completion!

```
Morning (8 AM): Launch background workforce
     ↓
Fire-and-forget agents work all day (no monitoring!)
     ↓
Evening (5 PM): Review what they accomplished
     ↓
Accept good work, queue fixes if needed
```

**Key Characteristics:**
- ✅ **Zero context cost** - Fire & forget, don't monitor
- ✅ **Massive parallelization** - Launch dozens without context bloat
- ✅ **Risk-appropriate** - Only for low-risk mechanical tasks
- ✅ **Check later** - Review results when convenient

#### Fire-and-Forget Candidates

**✅ GOOD for Fire-and-Forget (Low Risk):**
- Documentation generation (README, API docs, docstrings)
- Test writing (unit tests for existing code)
- Code formatting and linting
- Type hint additions
- Comment improvements
- Simple refactoring (consistent patterns)
- Dependency updates
- Configuration file updates
- Converting prints to logging
- Adding error handling to utilities

**❌ NOT for Fire-and-Forget (High Risk):**
- Architecture changes (needs design review)
- Database migrations (can break system)
- Security-critical code (requires thorough review)
- API contract changes (affects clients)
- Complex algorithms (needs validation)
- Anything that can cause data loss
- Production deployment changes

#### Implementation Pattern

**Morning Launch (Fire & Forget):**
```bash
# Launch background agents - no monitoring, no context cost!

# Documentation workforce
cline "Update all module README files with current status" --yolo --oneshot &
cline "Generate API documentation for all components" --yolo --oneshot &
cline "Update docstrings to Google style format" --yolo --oneshot &

# Testing workforce
cline "Write unit tests for untested utility functions" --yolo --oneshot &
cline "Add integration tests for StorageManager" --yolo --oneshot &
cline "Add edge case tests for all validators" --yolo --oneshot &

# Code quality workforce
cline "Add type hints to all untyped functions" --yolo --oneshot &
cline "Run auto-formatter (black) on all Python files" --yolo --oneshot &
cline "Convert all print statements to proper logging" --yolo --oneshot &
cline "Add error handling to all utility functions" --yolo --oneshot &

# Refactoring workforce
cline "Refactor config loading to use dataclasses" --yolo --oneshot &
cline "Update exception handling to use custom exceptions" --yolo --oneshot &

echo "🚀 Launched 12 background agents - zero context cost!"
# Continue your critical work - agents work independently
```

**Evening Review (Check Results):**
```bash
# List all task results
cline task list

# Review specific tasks
cline task view <doc-agent-task-id>
cline task view <test-agent-task-id>
cline task view <refactor-agent-task-id>

# Decision for each:
# ✅ Good work → Accept and commit
# ⚠️ Minor issues → Quick fix yourself
# ❌ Major issues → Queue for overnight supervisor or next day
```

#### Morning Launch Script

Create `scripts/morning-agents.sh`:

```bash
#!/bin/bash
# Morning fire-and-forget agent launcher

echo "🚀 Launching background agent workforce..."
echo ""

# Documentation agents (3 agents)
echo "📚 Documentation agents..."
cline "Update all README files with latest features and status" --yolo --oneshot &
cline "Generate comprehensive API documentation for all modules" --yolo --oneshot &
cline "Update all docstrings to Google style with examples" --yolo --oneshot &

# Testing agents (4 agents)
echo "🧪 Testing agents..."
cline "Write unit tests for all untested utility functions" --yolo --oneshot &
cline "Add integration tests for database operations" --yolo --oneshot &
cline "Write edge case tests for input validators" --yolo --oneshot &
cline "Add performance tests for critical paths" --yolo --oneshot &

# Code quality agents (5 agents)
echo "✨ Code quality agents..."
cline "Add type hints to all functions missing them" --yolo --oneshot &
cline "Run black formatter on all Python files" --yolo --oneshot &
cline "Run pylint and auto-fix safe issues" --yolo --oneshot &
cline "Convert all print() to proper logging calls" --yolo --oneshot &
cline "Add comprehensive error handling to utils/" --yolo --oneshot &

# Refactoring agents (3 agents)
echo "🔧 Refactoring agents..."
cline "Refactor configuration loading to use Pydantic" --yolo --oneshot &
cline "Update error handling to use custom exception hierarchy" --yolo --oneshot &
cline "Consolidate duplicate code patterns into shared utilities" --yolo --oneshot &

echo ""
echo "✅ Launched 15 background agents (zero context cost!)"
echo "📊 Continue your work - agents run independently"
echo "🕐 Review progress: cline task list"
echo ""
```

#### Evening Review Script

Create `scripts/evening-review.sh`:

```bash
#!/bin/bash
# Evening fire-and-forget agent review

echo "📊 Background Agent Progress Report"
echo "===================================="
echo ""

# Get task list
echo "Recent tasks (run 'cline task view <id>' to see details):"
cline task list

echo ""
echo "📝 Review Process:"
echo "  1. cline task view <task-id>  # View task details"
echo "  2. Review changes made"
echo "  3. Decide: ✅ Accept / ⚠️ Fix / ❌ Reject"
echo ""
echo "💡 Tip: Use 'cline logs' to see detailed execution logs"
```

#### .clinerules Integration

Create `.clinerules/workflows/daily-fire-and-forget.md`:

```markdown
---
description: Daily fire-and-forget agent workflow for mechanical tasks
author: Jeremy
version: 1.0
tags: ["workflow", "fire-and-forget", "parallel", "zero-context"]
---

# Daily Fire-and-Forget Workflow

## Purpose
Launch background agents for low-risk mechanical tasks without monitoring.
Zero context cost in parent session!

## Morning Routine (8 AM)

### 1. Identify Today's Mechanical Work
Review backlog for:
- Documentation gaps
- Missing tests
- Code quality issues
- Simple refactoring needs

### 2. Launch Fire-and-Forget Agents

**Documentation Tasks:**
```bash
cline "Update README with new features" --yolo --oneshot &
cline "Generate API docs" --yolo --oneshot &
```

**Testing Tasks:**
```bash
cline "Write tests for utility functions" --yolo --oneshot &
cline "Add integration tests" --yolo --oneshot &
```

**Code Quality Tasks:**
```bash
cline "Add type hints" --yolo --oneshot &
cline "Format code" --yolo --oneshot &
cline "Add error handling" --yolo --oneshot &
```

**Refactoring Tasks:**
```bash
cline "Refactor config loading" --yolo --oneshot &
cline "Consolidate duplicate code" --yolo --oneshot &
```

### 3. Continue Critical Work
- Focus on architecture with Claude
- Complex problem solving
- Design decisions
- **Zero context consumed by background agents!**

## Evening Routine (5 PM)

### 1. Review Background Work
```bash
cline task list
```

### 2. For Each Completed Task
```bash
cline task view <task-id>
```

**Decision Tree:**
- ✅ **Good work** → Accept and commit
- ⚠️ **Minor issues** → Quick manual fix
- ❌ **Major issues** → Queue for rework

### 3. Update Tomorrow's Plan
- Note what worked well
- Identify patterns of good results
- Adjust task types based on success rate

## Success Metrics

**High-performing fire-and-forget tasks:**
- Documentation generation (90%+ success)
- Test writing (85%+ success)
- Code formatting (95%+ success)
- Type hint additions (80%+ success)

**Tasks to avoid:**
- Complex refactoring (<50% success)
- Algorithmic changes (requires validation)
- Architecture modifications (too risky)

## Safety Guidelines

### ✅ ALWAYS Safe to Fire-and-Forget
- Documentation updates
- Adding tests (not changing logic)
- Formatting and linting
- Type hint additions
- Docstring improvements

### ⚠️ SOMETIMES Safe (Review Carefully)
- Simple refactoring (if well-defined)
- Configuration updates
- Dependency updates
- Error handling additions

### ❌ NEVER Fire-and-Forget
- Database migrations
- Security-critical code
- API contract changes
- Complex algorithms
- Production deployments
```

#### Three-Tier Agent System

With fire-and-forget, you now have a **complete three-tier development system**:

```
┌─────────────────────────────────────────────────────┐
│   TIER 1: Interactive (Claude + You)               │
│   - Architecture & complex design                  │
│   - Exploratory problem solving                    │
│   - Critical decision making                       │
│   CONTEXT: High cost, high value                   │
│   WHEN: During your active work hours              │
└─────────────────────────────────────────────────────┘
              ↓ Delegates to ↓
┌─────────────────────────────────────────────────────┐
│   TIER 2: Monitored Autonomous (GLM-4.6)           │
│   - Important feature implementation               │
│   - Work requiring validation checkpoints          │
│   - Sequential critical workflows                  │
│   CONTEXT: Medium cost, wait for completion        │
│   WHEN: Overnight (autonomous_supervisor.py)       │
└─────────────────────────────────────────────────────┘
              ↓ Delegates to ↓
┌─────────────────────────────────────────────────────┐
│   TIER 3: Fire-and-Forget (GLM-4.6 Background)     │
│   - Documentation, tests, formatting               │
│   - Parallel independent mechanical work           │
│   - Low-risk code quality improvements             │
│   CONTEXT: ZERO cost, check results later          │
│   WHEN: During your active hours (background)      │
└─────────────────────────────────────────────────────┘
```

#### 24/7 Development Capacity

**Typical Day:**

**Morning (8 AM):**
```bash
# 5 minutes: Launch 15 fire-and-forget agents
./scripts/morning-agents.sh
```

**Day (8 AM - 5 PM):**
- **You + Claude (Tier 1):** Architecture, complex work
- **Background agents (Tier 3):** 15 agents working independently (zero context cost!)
- **Effective workforce:** 1 human + 1 Claude + 15 background agents = 17x parallelization!

**Evening (5 PM):**
```bash
# 15 minutes: Review background agent work
./scripts/evening-review.sh
# Accept good work, queue fixes
```

**Night (10 PM - 6 AM):**
```bash
# autonomous_supervisor.py runs critical tasks (Tier 2)
# 8 hours of monitored autonomous implementation
```

**Next Morning:**
- Review overnight supervisor results
- Launch new fire-and-forget workforce
- Repeat!

#### Real-World Example

**Monday Morning (8 AM):**

Jeremy launches 12 fire-and-forget agents:
```bash
./scripts/morning-agents.sh
# Agents working on: docs, tests, formatting, type hints
```

**Monday Day (8 AM - 5 PM):**

Jeremy + Claude focus on critical work:
- Design new authentication system (Tier 1)
- Complex debugging session (Tier 1)
- Architecture review (Tier 1)

Meanwhile, 12 background agents work independently (zero context cost!)

**Monday Evening (5 PM):**

Jeremy reviews background work:
```bash
cline task list
```

Results:
- ✅ 9 agents succeeded (docs updated, tests written, code formatted)
- ⚠️ 2 agents minor issues (quick manual fixes)
- ❌ 1 agent failed (refactoring too complex - expected)

Acceptance rate: 75% perfect, 92% acceptable with minor fixes

**Monday Night (10 PM - 6 AM):**

autonomous_supervisor.py runs critical tasks:
- Implement auth system from design (Tier 2)
- Write integration tests (Tier 2)
- Run validation suite (Tier 2)

**Tuesday Morning:**

Jeremy reviews:
1. Overnight supervisor results (critical work)
2. Launches new fire-and-forget workforce
3. Continues cycle

**Effective capacity:**
- **Day:** 1 human + Claude + 12 background agents
- **Night:** 8 hours autonomous implementation
- **Total:** ~24/7 development with risk-appropriate delegation!

#### Why This is Genuinely Novel

**Traditional development:**
- One developer, one task at a time
- Manual review for everything
- Sequential execution

**With fire-and-forget pattern:**
- Massive parallelization (dozens of agents)
- Risk-appropriate delegation (only mechanical tasks)
- Zero context cost (agents run independently)
- Review when convenient (not blocked waiting)

**This is like having:**
- 1 senior architect (you + Claude)
- 15 junior developers (fire-and-forget agents)
- 1 night shift developer (autonomous supervisor)

All coordinated in a single workflow!

---

## Mapping Forge Workflow to Cline

### Your Current Forge Workflow (agents.md)

Based on AIUML Forge's Architecture Driven Development:

```
Requirements → Design (AIUML) → Pseudos → Implementation → Validation → Tests
```

### Proposed .clinerules Structure

```
.clinerules/
├── agents/
│   ├── 01-requirements-agent.md      # Gather and document requirements
│   ├── 02-architect-agent.md         # Design components in AIUML notation
│   ├── 03-pseudo-generator-agent.md  # Generate pseudos for all methods
│   ├── 04-implementer-agent.md       # Translate pseudos to code
│   ├── 05-validator-agent.md         # Validate implementation vs design
│   └── 06-test-agent.md              # Write and run comprehensive tests
├── workflows/
│   ├── full-feature-workflow.md      # Complete: requirements → tests
│   ├── design-workflow.md            # Just: requirements → design
│   ├── implement-workflow.md         # Just: design → implementation
│   └── validate-workflow.md          # Just: validate + test
└── context/
    ├── aiuml-notation.md             # AIUML specification reference
    ├── aiuml-forge-architecture.md   # System architecture
    ├── coding-standards.md           # Python coding standards
    └── pseudo-examples.md            # Good pseudo examples
```

### Agent Definitions

#### Requirements Agent

```markdown
---
description: Requirements gathering and documentation agent
author: Jeremy
version: 1.0
tags: ["requirements", "planning", "aiuml"]
---

# Requirements Agent

## Role
Gather user requirements and document them in a structured format suitable for architecture design.

## Workflow

### Step 1: Gather Requirements
1. Ask user about feature/component purpose
2. Identify key functionality needed
3. Document user constraints and preferences
4. Clarify ambiguities

### Step 2: Document Requirements
Create `requirements/<feature>.md`:
- Feature overview
- Functional requirements
- Non-functional requirements (performance, security, etc.)
- Dependencies and constraints
- Success criteria

### Step 3: Delegate to Architect
```bash
cline "Design <feature> from requirements/<feature>.md following AIUML notation" --yolo --oneshot
```

## Output Format
Structured requirements document ready for architecture design.
```

#### Architect Agent

```markdown
---
description: AIUML component architecture design agent
author: Jeremy
version: 1.0
tags: ["architecture", "design", "aiuml"]
---

# Architect Agent

## Role
Design components using AIUML notation based on requirements.

## MUST Requirements

1. **MUST** read requirements document first
2. **MUST** use AIUML notation (10-100x token compression)
3. **MUST** include type hints for all methods
4. **MUST** generate pseudos for all methods (delegate to Pseudo Generator)
5. **MUST** validate design before delegation

## Workflow

### Step 1: Read Requirements
```python
requirements = read_file("requirements/<feature>.md")
```

### Step 2: Design Architecture
Create `design/<component>.aiuml`:
- Component class definition
- Method signatures with type hints
- Data structures
- Dependencies

### Step 3: Delegate Pseudo Generation
```bash
cline "Generate pseudos for design/<component>.aiuml" --yolo --oneshot
```

### Step 4: Validate Design
- All methods have type hints ✅
- All methods have pseudos ✅
- Design follows AIUML notation ✅

### Step 5: Report or Delegate
- Report design completion to user
- OR delegate to implementer if in full workflow

## Output Format
`.aiuml` file with complete component design and pseudos.

## Reference Documentation
See `.clinerules/context/aiuml-notation.md` for AIUML specification.
```

#### Implementer Agent

```markdown
---
description: Code implementation agent from AIUML pseudos
author: Jeremy
version: 1.0
tags: ["implementation", "coding", "aiuml"]
---

# Implementer Agent

## Role
Translate AIUML pseudos into production Python code.

## Critical Rules

### 🚨 MUST Requirements

1. **MUST** read complete `.aiuml` design file before starting
2. **MUST** implement every pseudo exactly as specified
3. **MUST** preserve all type hints from design
4. **MUST** create files in correct directory structure
5. **MUST NOT** skip any pseudos (no TODO/BLOCKED markers)
6. **MUST NOT** modify method signatures
7. **MUST NOT** add features not in design

### Code Quality

1. **SHOULD** add docstrings referencing design pseudo
2. **SHOULD** include inline comments for complex logic
3. **SHOULD** follow PEP-8 standards
4. **SHOULD** use descriptive variable names

## Workflow

### Step 1: Read Design
```python
design = read_file("design/<component>.aiuml")
```

### Step 2: Parse Structure
- Extract class name and metaclass
- Extract all method signatures
- Extract all pseudos
- Extract type hints

### Step 3: Implement Methods
For each method:
1. Create method with exact signature from design
2. Implement logic following pseudo
3. Add docstring with pseudo reference
4. Preserve type hints

### Step 4: Create File
Write to `src/components/<component>.py`

### Step 5: Validate
Before completion:
```python
<thinking>
- All pseudos implemented? YES/NO
- Type hints preserved? YES/NO
- File in correct location? YES/NO
</thinking>
```

## Completion Criteria
✅ All pseudos implemented
✅ Type hints match design
✅ File created in correct location
✅ No TODO or BLOCKED markers

## Next Step
Report completion OR delegate to validator agent if in full workflow.
```

#### Validator Agent

```markdown
---
description: Implementation validation against design agent
author: Jeremy
version: 1.0
tags: ["validation", "quality", "aiuml"]
---

# Validator Agent

## Role
Validate implementation against AIUML design specification.

## Validation Checklist

### 1. Structure Validation
- [ ] Class exists with correct name
- [ ] All methods from design are present
- [ ] No extra methods added (unless private helpers)

### 2. Signature Validation
- [ ] Method names match exactly
- [ ] Parameter names and types match
- [ ] Return type hints match
- [ ] No signature modifications

### 3. Pseudo Implementation
- [ ] Every pseudo has corresponding code
- [ ] Logic matches pseudo intent
- [ ] No TODO or BLOCKED markers
- [ ] Edge cases handled

### 4. Code Quality
- [ ] Follows PEP-8 standards
- [ ] Has docstrings
- [ ] Type hints present
- [ ] No obvious bugs

## Workflow

### Step 1: Load Files
```python
design = read_file("design/<component>.aiuml")
implementation = read_file("src/components/<component>.py")
```

### Step 2: Parse and Compare
- Extract design specifications
- Parse implementation structure
- Compare method by method

### Step 3: Run Automated Checks
```bash
# Type checking
mypy src/components/<component>.py

# Linting
pylint src/components/<component>.py

# Tests (if exist)
pytest tests/test_<component>.py -v
```

### Step 4: Generate Report
Create `validation/<component>-report.md`:
- ✅ Passes / ❌ Failures
- List of issues found
- Recommendations

### Step 5: Decide Next Step
- All checks pass → Delegate to test agent OR report completion
- Issues found → Report to user for decision

## Output Format
Validation report with pass/fail status and detailed findings.
```

#### Test Agent

```markdown
---
description: Comprehensive test generation agent
author: Jeremy
version: 1.0
tags: ["testing", "quality", "pytest"]
---

# Test Agent

## Role
Write comprehensive test suites for implemented components.

## Test Requirements

1. **MUST** use pytest framework
2. **MUST** achieve >80% code coverage
3. **MUST** test all public methods
4. **SHOULD** test edge cases and error conditions
5. **SHOULD** include integration tests if component has dependencies

## Workflow

### Step 1: Analyze Implementation
```python
implementation = read_file("src/components/<component>.py")
design = read_file("design/<component>.aiuml")  # Optional: for context
```

### Step 2: Identify Test Cases
For each method:
- Happy path (normal inputs)
- Edge cases (empty, null, boundary values)
- Error cases (invalid inputs, exceptions)
- Integration scenarios (if applicable)

### Step 3: Write Tests
Create `tests/test_<component>.py`:
```python
import pytest
from src.components.<component> import <ComponentClass>

class Test<ComponentClass>:
    @pytest.fixture
    def instance(self):
        return <ComponentClass>()

    def test_method_happy_path(self, instance):
        result = instance.method(valid_input)
        assert result == expected_output

    def test_method_edge_case(self, instance):
        result = instance.method(edge_case_input)
        assert result == edge_expected

    def test_method_error_handling(self, instance):
        with pytest.raises(ExpectedException):
            instance.method(invalid_input)
```

### Step 4: Run Tests
```bash
pytest tests/test_<component>.py -v --cov=src/components/<component>.py
```

### Step 5: Report Results
- Test count (passed/failed)
- Coverage percentage
- Any failures or issues

## Output Format
Test file with comprehensive test suite and coverage report.
```

### Full Workflow Orchestration

```markdown
---
description: Complete AIUML feature implementation workflow
author: Jeremy
version: 1.0
tags: ["workflow", "orchestration", "aiuml", "complete"]
---

# Full Feature Implementation Workflow

## Overview
Complete workflow from requirements to tested implementation.

## Prerequisites
- User has described feature/component needed
- Project structure exists (design/, src/, tests/, requirements/)

## Workflow Execution

### Step 1: Requirements (Optional - may start with design)
```bash
cline "Gather requirements for <feature>. Follow requirements-agent rules." --yolo --oneshot
```
**Output:** `requirements/<feature>.md`

### Step 2: Architecture Design
```bash
cline "Design <component> from requirements. Follow architect-agent rules. Include AIUML notation and pseudos." --yolo --oneshot
```
**Output:** `design/<component>.aiuml`

**Human checkpoint:** Review design, approve before implementation

### Step 3: Implementation
```bash
cline "Implement <component> from design/<component>.aiuml. Follow implementer-agent rules." --yolo --oneshot
```
**Output:** `src/components/<component>.py`

### Step 4: Validation
```bash
cline "Validate <component> implementation against design/<component>.aiuml. Follow validator-agent rules." --yolo --oneshot
```
**Output:** `validation/<component>-report.md`

**Human checkpoint:** Review validation report

### Step 5: Testing
```bash
cline "Write comprehensive tests for <component>. Follow test-agent rules." --yolo --oneshot
```
**Output:** `tests/test_<component>.py`

### Step 6: Final Validation
```bash
# Run all tests
pytest tests/test_<component>.py -v --cov

# Type checking
mypy src/components/<component>.py

# Linting
pylint src/components/<component>.py
```

## Success Criteria
✅ Design complete with pseudos
✅ Implementation matches design
✅ Validation passed
✅ Tests written and passing
✅ >80% code coverage
✅ Type checking clean
✅ Linting clean

## Output Summary
- Requirements document (if created)
- AIUML design file
- Python implementation
- Validation report
- Test suite
- All checks passing

**Total time:** ~30-60 minutes for medium component (mostly autonomous!)
```

---

## Practical Examples

### Example 1: Simple Component Implementation

**Scenario:** Implement a simple DataValidator component

#### Step 1: Create .clinerules

Already have rules from above sections.

#### Step 2: Run Workflow

```bash
# From autonomous_dev directory or within Claude Code Bash tool:

# Design the component
cline "Design a DataValidator component that validates JSON data against schemas. Include AIUML notation with pseudos for: validate_schema, validate_required_fields, validate_types. Follow architect-agent rules." --yolo --oneshot
```

**Agent executes:**
- Reads architect-agent.md rules
- Creates `design/data_validator.aiuml`
- Generates pseudos for all methods
- Reports completion

#### Step 3: Implement

```bash
cline "Implement DataValidator from design/data_validator.aiuml. Follow implementer-agent rules." --yolo --oneshot
```

**Agent executes:**
- Reads implementer-agent.md rules
- Reads design/data_validator.aiuml
- Implements all pseudos as Python code
- Creates src/components/data_validator.py
- Reports completion

#### Step 4: Validate

```bash
cline "Validate DataValidator implementation. Follow validator-agent rules." --yolo --oneshot
```

**Agent executes:**
- Reads validator-agent.md rules
- Compares design to implementation
- Runs mypy and pylint
- Generates validation report
- Reports pass/fail status

#### Step 5: Test

```bash
cline "Write tests for DataValidator. Follow test-agent rules." --yolo --oneshot
```

**Agent executes:**
- Reads test-agent.md rules
- Analyzes implementation
- Creates comprehensive test suite
- Runs tests
- Reports coverage

**Total time:** ~15-20 minutes, fully autonomous!

### Example 2: Complex Multi-Component Feature

**Scenario:** Build a complete StorageManager system with multiple components

#### Step 1: Design Phase (Interactive with Claude)

User + Claude in Claude Code:
- Discuss requirements
- Explore existing codebase
- Design high-level architecture
- Identify components needed:
  - StorageManager (main interface)
  - FileBackend (file storage)
  - CacheLayer (caching)
  - ValidationEngine (data validation)

#### Step 2: Create Designs (Parallel GLM-4.6 Agents)

```bash
# Launch parallel design agents
cline "Design StorageManager component with AIUML. Methods: save, load, delete, list. Follow architect-agent rules." --yolo --oneshot &

cline "Design FileBackend component with AIUML. Methods: write_file, read_file, delete_file, list_files. Follow architect-agent rules." --yolo --oneshot &

cline "Design CacheLayer component with AIUML. Methods: get, set, invalidate, clear. Follow architect-agent rules." --yolo --oneshot &

cline "Design ValidationEngine component with AIUML. Methods: validate_data, check_schema, sanitize. Follow architect-agent rules." --yolo --oneshot &

wait
```

**Result:** 4 .aiuml design files, ~10 minutes total

#### Step 3: Review Designs (Claude)

Claude reviews all designs for:
- Architectural consistency
- Interface compatibility
- Potential issues

User approves or requests changes.

#### Step 4: Implement Components (Parallel GLM-4.6 Agents)

```bash
# Launch parallel implementation agents
cline "Implement StorageManager from design/storage_manager.aiuml. Follow implementer-agent rules." --yolo --oneshot &

cline "Implement FileBackend from design/file_backend.aiuml. Follow implementer-agent rules." --yolo --oneshot &

cline "Implement CacheLayer from design/cache_layer.aiuml. Follow implementer-agent rules." --yolo --oneshot &

cline "Implement ValidationEngine from design/validation_engine.aiuml. Follow implementer-agent rules." --yolo --oneshot &

wait
```

**Result:** 4 Python implementation files, ~15 minutes total

#### Step 5: Integration Testing (Sequential)

```bash
# First validate each component
cline "Validate all StorageManager components. Follow validator-agent rules." --yolo --oneshot

# Then write integration tests
cline "Write integration tests for StorageManager system. Test component interactions. Follow test-agent rules." --yolo --oneshot
```

#### Step 6: Final Review (Claude)

Claude:
- Reviews all implementations
- Runs integration tests
- Validates architecture compliance
- Identifies any issues

**Total time:** ~45 minutes for complete multi-component system!

### Example 3: Overnight Autonomous Queue

**Scenario:** Queue multiple components for overnight implementation

#### Setup: task_queue.txt

```
Design UserManager component with AIUML. Methods: create_user, get_user, update_user, delete_user, list_users. Follow architect-agent rules.
Implement UserManager from design/user_manager.aiuml. Follow implementer-agent rules.
Validate UserManager implementation. Follow validator-agent rules.
Write tests for UserManager. Follow test-agent rules.
Design AuthManager component with AIUML. Methods: login, logout, verify_token, refresh_token. Follow architect-agent rules.
Implement AuthManager from design/auth_manager.aiuml. Follow implementer-agent rules.
Validate AuthManager implementation. Follow validator-agent rules.
Write tests for AuthManager. Follow test-agent rules.
```

#### Run Autonomous Supervisor

```bash
python autonomous_supervisor.py
```

**Supervisor executes (10 PM - 6 AM):**
1. Processes each task from queue
2. Launches Cline for each task
3. Waits for completion
4. Logs results
5. Moves to next task

**Morning result:**
- 2 complete components (design → code → validation → tests)
- All done while you slept
- Ready for review

---

## Best Practices

### 1. Rule Organization

**DO:**
- ✅ One focused topic per rule file
- ✅ Use descriptive filenames (verb-noun pattern)
- ✅ Number files for reading order if sequence matters
- ✅ Group related rules in subdirectories
- ✅ Version control your .clinerules

**DON'T:**
- ❌ Create monolithic rule files
- ❌ Mix multiple concerns in one file
- ❌ Use vague filenames like "rules.md"
- ❌ Forget to update rules when workflows change

### 2. Agent Design

**DO:**
- ✅ Define clear, single responsibilities for each agent
- ✅ Use MUST/SHOULD/NEVER language consistently
- ✅ Include success criteria and completion checks
- ✅ Specify which tools agents should use
- ✅ Add <thinking> blocks for validation steps

**DON'T:**
- ❌ Create agents with overlapping responsibilities
- ❌ Use ambiguous language ("try to", "maybe")
- ❌ Skip error handling guidance
- ❌ Allow agents to delegate outside their scope

### 3. Workflow Design

**DO:**
- ✅ Define clear start and end points
- ✅ Include decision points with conditions
- ✅ Specify expected inputs and outputs
- ✅ Add human checkpoints for critical decisions
- ✅ Make workflows idempotent (can re-run safely)

**DON'T:**
- ❌ Create workflows with unclear stopping conditions
- ❌ Skip validation steps
- ❌ Forget to handle errors and edge cases
- ❌ Make workflows that assume perfect execution

### 4. Sub-Agent Delegation

**DO:**
- ✅ Delegate when context needs to be fresh
- ✅ Delegate when task is independent
- ✅ Wait for sub-agent completion before proceeding
- ✅ Review sub-agent outputs before continuing
- ✅ Use parallel delegation for independent tasks

**DON'T:**
- ❌ Delegate tasks that need parent context
- ❌ Create circular delegation (A→B→A)
- ❌ Forget to specify which rules sub-agent should follow
- ❌ Skip validation of sub-agent results

### 5. Testing and Validation

**DO:**
- ✅ Test your .clinerules with simple tasks first
- ✅ Validate that agents follow rules correctly
- ✅ Iterate on rules based on results
- ✅ Document which rules work best for which tasks
- ✅ Keep examples of successful runs

**DON'T:**
- ❌ Deploy untested rules to production workflows
- ❌ Assume agents will interpret ambiguous rules correctly
- ❌ Skip monitoring agent behavior
- ❌ Forget to update rules when they fail

### 6. Documentation

**DO:**
- ✅ Include examples in rule files
- ✅ Document why rules exist (not just what)
- ✅ Show both correct and incorrect patterns
- ✅ Keep rules updated as systems evolve
- ✅ Version your rules (use git)

**DON'T:**
- ❌ Write rules without context or rationale
- ❌ Skip examples (agents learn from them)
- ❌ Leave outdated rules in place
- ❌ Forget to document rule interactions

### 7. Integration with AIUML Workflow

**DO:**
- ✅ Use AIUML designs as source of truth
- ✅ Validate implementations against .aiuml files
- ✅ Reference pseudos in implementation
- ✅ Maintain design → code traceability
- ✅ Use agents to enforce AIUML standards

**DON'T:**
- ❌ Skip design phase and go straight to code
- ❌ Allow implementations to drift from design
- ❌ Modify designs without updating implementations
- ❌ Lose track of which pseudo maps to which code

---

## Next Steps

### Immediate Actions

1. **Review your forge agents.md**
   - Understand current workflow
   - Identify agent roles
   - Map to .clinerules structure

2. **Create .clinerules directory**
   - Start with one agent (e.g., implementer)
   - Test with simple task
   - Iterate based on results

3. **Build incrementally**
   - Add one agent at a time
   - Validate each works correctly
   - Combine into workflows

### Future Enhancements

1. **AGENTS.md Standard**
   - Monitor Cline PR #5405 for AGENTS.md support
   - Plan migration strategy
   - Maintain cross-tool compatibility

2. **Advanced Orchestration**
   - Experiment with multi-level delegation
   - Build supervisor agents
   - Optimize parallel execution

3. **Integration**
   - Integrate with autonomous_supervisor.py
   - Build task queue templates
   - Create reusable workflow library

---

## Resources

### Official Documentation
- [Cline .clinerules Blog Post](https://cline.bot/blog/clinerules-version-controlled-shareable-and-ai-editable-instructions)
- [Cline Prompts Repository](https://github.com/cline/prompts)
- [Writing Effective .clinerules Guide](https://github.com/cline/prompts/blob/main/.clinerules/writing-effective-clinerules.md)

### Related Issues & Discussions
- [AGENTS.md Standard Proposal #5033](https://github.com/cline/cline/issues/5033)
- [Multi-Agent Framework Discussion #489](https://github.com/cline/cline/discussions/489)
- [Cline CLI Blog Post](https://cline.bot/blog/cline-cli-my-undying-love-of-cline-core)

### Your Documentation
- `CLAUDE.md` - Project context and setup
- `autonomous_supervisor.py` - Scheduled task processor
- `aiuml-forge/agents.md` - Current workflow definition

---

**Document Status**: Complete - Ready for implementation
**Next Document**: Create actual .clinerules files for forge workflow
