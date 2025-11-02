# Autonomous Development with Cline CLI

**Purpose**: Fill availability gaps (sleep + work hours) with legitimate autonomous development using z.ai coding plan.

**Ethical use**: Respects fair use (10 hours/day max), uses Cline CLI as designed, stays within ToS.

---

## Quick Start (5 Minutes)

### 1. Install Cline CLI

```bash
# Install globally
npm install -g cline

# Verify installation
cline --version
```

### 2. Configure z.ai Coding Plan

```bash
# Authenticate with your z.ai API key
cline auth zai YOUR_ZAI_API_KEY

# Verify connection
cline task new "Echo hello world" --oneshot
```

### 3. Test Autonomous Mode

```bash
# Test autonomous oneshot mode (no prompts)
echo "Create a Python function that adds two numbers" | cline task new --yolo --oneshot

# Should complete without any user interaction
```

### 4. Queue Your First Tasks

```bash
# Edit task_queue.txt
cat > task_queue.txt << 'EOF'
# Tonight's tasks
Implement CacheManager from forge.aiuml/design/components/cache.aiuml
Write unit tests for CacheManager
Run validation with run_validation.py
EOF
```

### 5. Start Supervisor (Before Bed)

```bash
# Start supervisor (runs until 6 AM or queue empty)
python autonomous_supervisor.py

# Or run in background
nohup python autonomous_supervisor.py > supervisor.log 2>&1 &
```

### 6. Review Results (Morning)

```bash
# Check progress log
cat autonomous_progress.log

# Check what was implemented
git diff

# Check validation results
python run_validation.py
```

---

## Configuration

### Work Hours (Default: 8-Hour Night Shift)

Edit `autonomous_supervisor.py` configuration:

```python
# Night shift (while you sleep)
NIGHT_START = dt_time(22, 0)   # 10:00 PM
NIGHT_END = dt_time(6, 0)      # 6:00 AM
# Total: 8 hours

# Optional: Add day shift (while at work)
# Uncomment to add 2 hours during work day (total = 10 hours)
DAY_START = dt_time(9, 0)      # 9:00 AM
DAY_END = dt_time(11, 0)       # 11:00 AM
```

**Fairness rationale**: 10 hours/day matches upper bound of manual usage. 8-hour night shift is conservative.

### Task Queue Format

**File**: `task_queue.txt`

**Format**: One task per line, processed in order (FIFO)

**Good task descriptions**:
```
Implement NavigationService from forge.aiuml/design/components/navigation.aiuml following ADR-003
Write unit tests for NavigationService with >80% coverage
Fix bug #127: Path traversal in SecurityService.validate_path()
Add docstrings to all public methods in CacheManager
Update CLAUDE.md with latest validation results
```

**Bad task descriptions**:
```
Fix the code
Make it better
Do some tests
Update docs
```

**Why specificity matters**: Cline needs clear context. Reference design files, ADRs, bug numbers, specific files.

---

## Usage Patterns

### Evening Workflow (Queue Tomorrow's Work)

```bash
# Review current state
git status
python run_validation.py

# Queue next tasks
cat >> task_queue.txt << 'EOF'
Implement StorageManager from storage.aiuml
Write tests for StorageManager
Fix any validation errors
EOF

# Start supervisor before bed
python autonomous_supervisor.py &

# Go to sleep - supervisor works overnight
```

### Morning Workflow (Review Progress)

```bash
# Check what happened overnight
cat autonomous_progress.log | tail -50

# Review implementations
git diff --stat
git diff src/

# Run validation
python run_validation.py

# If good: commit
git add .
git commit -m "Autonomous implementation: StorageManager + tests"

# If issues: add fixes to queue
echo "Fix StorageManager validation errors" >> task_queue.txt
```

### Continuous Operation (Long Projects)

```bash
# Keep queue populated
# Supervisor auto-starts when work hours begin
# Processes queue autonomously
# Stops when work hours end or queue empty

# Use cron or Task Scheduler to auto-start
# (Optional - supervisor can run 24/7 but only works during configured hours)
```

---

## Capacity Planning

### z.ai Pro Plan ($15/month)

**Quota**: 600 prompts per 5 hours

**8-hour night shift capacity**:
- ~1,200 prompts per night
- ~10-15 prompts per task
- **80-120 tasks per night**

**Realistic forge usage**:
- 5-10 tasks per night (implement, test, fix, doc)
- **Uses ~5-10% of capacity**
- Plenty of headroom

### z.ai Max Plan ($30/month)

**Quota**: 2,400 prompts per 5 hours

**If you upgrade**:
- ~4,800 prompts per night
- **320-480 tasks per night**
- Massive capacity (probably never hit this)

### When to Upgrade

**Stick with Pro if**:
- Working on forge only
- 5-10 tasks per night
- Never hitting limits

**Upgrade to Max if**:
- Multiple projects
- Large refactorings (100+ files)
- Hitting Pro limits regularly
- Want extra headroom

---

## Monitoring & Debugging

### Check Supervisor Status

```bash
# Check if supervisor is running
ps aux | grep autonomous_supervisor.py

# View live log
tail -f autonomous_progress.log

# Check state
cat .autonomous_state.json
```

### Common Issues

**Issue**: Supervisor not starting
```bash
# Check Cline CLI is installed
cline --version

# Check authentication
cline task new "Test" --oneshot

# Check Python version (need 3.8+)
python --version
```

**Issue**: Tasks failing
```bash
# Check task queue format
cat task_queue.txt

# Test task manually
cline task new "Your task description" --yolo --oneshot

# Check Cline quota usage (z.ai dashboard)
```

**Issue**: Supervisor stops unexpectedly
```bash
# Check logs for errors
cat autonomous_progress.log | grep ERROR

# Check disk space
df -h

# Check memory
free -m
```

---

## Ethical Use Guidelines

### What This System Does ✅

- ✅ Fills availability gaps (sleep + work hours)
- ✅ Uses Cline CLI as designed (autonomous mode is a feature)
- ✅ Respects fair use (10 hours/day max)
- ✅ Uses coding plan for coding work
- ✅ Legitimate productivity enhancement

### What This System Doesn't Do ❌

- ❌ Circumvent rate limits (respects 5-hour windows)
- ❌ Abuse quota (uses same as manual work)
- ❌ Violate ToS (uses approved tool legitimately)
- ❌ Game the system (transparent, ethical use)

### Why This Is Fair

**Manual usage** (if you had infinite time):
- 10 hours/day actively coding
- ~600-1000 prompts/day
- Realistic human capacity

**Autonomous usage** (this system):
- 8-10 hours/day during unavailable hours
- ~600-1000 prompts/day
- Same capacity, different timing

**Difference**: Not more usage, just different hours.

---

## Advanced Configuration

### Run as System Service (Linux/Mac)

```bash
# Create systemd service
sudo nano /etc/systemd/system/autonomous-dev.service
```

```ini
[Unit]
Description=Autonomous Development Supervisor
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/aiuml-forge
ExecStart=/usr/bin/python3 /path/to/aiuml-forge/autonomous_supervisor.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl enable autonomous-dev
sudo systemctl start autonomous-dev

# Check status
sudo systemctl status autonomous-dev
```

### Run as Scheduled Task (Windows)

```powershell
# Create scheduled task to run at 10 PM daily
$action = New-ScheduledTaskAction -Execute "python" -Argument "D:\path\to\autonomous_supervisor.py"
$trigger = New-ScheduledTaskTrigger -Daily -At 10PM
Register-ScheduledTask -TaskName "AutonomousDev" -Action $action -Trigger $trigger
```

### Custom Notifications

Add to `autonomous_supervisor.py` after task completion:

```python
def send_notification(message: str):
    """Send notification via email/Discord/Slack/etc"""
    # Email example
    import smtplib
    from email.message import EmailMessage

    msg = EmailMessage()
    msg.set_content(message)
    msg['Subject'] = 'Autonomous Dev Update'
    msg['From'] = 'supervisor@yourdomain.com'
    msg['To'] = 'you@yourdomain.com'

    # Send via SMTP...
```

---

## Integration with forge Workflow

### Design-Implement-Validate Cycle

**Evening** (Jeremy, interactive):
1. Design component with Claude Code (Sonnet 4.5)
2. Write pseudos (SPEC, EDGE, ERR, PERF)
3. Save design to forge.aiuml/design/
4. Queue implementation task

**Night** (Autonomous, Cline CLI + GLM-4.6):
1. Read design file
2. Implement component following ADR-003
3. Write tests
4. Run validation

**Morning** (Jeremy, review):
1. Check validation results
2. Review implementation
3. Approve or queue fixes
4. Queue next design phase

**Continuous cycle**: Design → Implement → Validate → Repeat

### Validation Integration

```bash
# Add validation to queue
echo "Run validation and report results" >> task_queue.txt

# Or add as post-implementation step in task description:
echo "Implement StorageManager AND run validation" >> task_queue.txt
```

### Git Integration

Supervisor automatically works in git repo:
- Cline creates/edits files
- Changes appear in git diff
- Manual commit/review in morning

**Optional**: Auto-commit after successful validation
```python
# Add to supervisor after successful task
if "validation" in task.lower():
    subprocess.run(["git", "add", "."])
    subprocess.run(["git", "commit", "-m", f"Auto: {task[:50]}"])
```

---

## FAQ

### Q: Is this allowed by z.ai ToS?
**A**: Yes. Using Cline CLI (approved tool) in autonomous mode (designed feature) for coding work (intended use) within fair limits (10 hours/day).

### Q: How is this different from API usage?
**A**: Uses coding plan quota (prompt-based), not API (token-based). Stays within approved tool ecosystem.

### Q: Can I run 24/7?
**A**: Technically yes, but ethically no. Limit to realistic human usage (~10 hours/day) to be fair to z.ai.

### Q: What if I hit rate limits?
**A**: Unlikely with 8-10 hour window. Pro plan = 600 prompts/5hr. If you do, upgrade to Max plan ($30/month).

### Q: Will z.ai ban me for this?
**A**: No, if used ethically. You're using approved tool as designed, staying within fair limits. Transparent, legitimate use.

### Q: Can I modify Cline CLI source?
**A**: Yes (Apache 2.0 license), but unnecessary. Built-in autonomous mode already does what you need.

### Q: What about other projects (not forge)?
**A**: Works for any project. Just adjust task descriptions and validation commands.

---

## Roadmap

### Phase 1: Basic Automation ✅
- [x] Cline CLI integration
- [x] Task queue system
- [x] Time-based windowing
- [x] Progress logging

### Phase 2: Enhanced Monitoring
- [ ] Real-time dashboard
- [ ] Slack/Discord notifications
- [ ] Usage analytics
- [ ] Task success metrics

### Phase 3: Multi-Project Support
- [ ] Project-specific queues
- [ ] Priority-based scheduling
- [ ] Resource allocation
- [ ] Parallel project execution

### Phase 4: AI Supervisor
- [ ] Task generation from requirements
- [ ] Intelligent task ordering
- [ ] Automatic error recovery
- [ ] Quality assessment

---

## Support & Troubleshooting

**Issues with supervisor**: Check `autonomous_progress.log`
**Issues with Cline**: Check Cline docs at https://docs.cline.bot
**Issues with z.ai**: Check z.ai dashboard at https://z.ai

**Questions**: See CLAUDE.md for project context and architecture

---

**Last Updated**: 2025-11-02
**Status**: Production ready for ethical autonomous development
**License**: MIT (same as aiuml-forge)
