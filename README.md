# Autonomous Development Supervisor

**Fill your availability gaps with ethical autonomous development.**

An autonomous task supervisor that uses [Cline CLI](https://cline.bot/) + [z.ai coding plan](https://z.ai/) to continue development work during unavailable hours (sleep, work, etc.).

## The Problem

You have limited availability:
- 8 hours/day: Sleep
- 8 hours/day: Work
- 2-4 hours/day: Life (meals, family, etc.)
- **Only 4-6 hours/day for coding**

But your z.ai coding plan could be used 24/7.

## The Solution

**Autonomous supervisor** that:
- Processes task queue during configured hours
- Uses Cline CLI autonomous mode (designed feature)
- Respects fair use (10 hours/day max = realistic human usage)
- 100% ToS compliant (approved tool, intended use)

**Result**: 2-3x productivity without gaming the system.

## Quick Start (5 Minutes)

### 1. Install Cline CLI

```bash
npm install -g cline
```

### 2. Configure z.ai

```bash
cline auth zai YOUR_ZAI_API_KEY
```

### 3. Queue Tasks

```bash
cat > task_queue.txt << 'EOF'
Implement user authentication following OAuth 2.0 spec
Write unit tests for authentication module
Update documentation with new auth flow
EOF
```

### 4. Start Supervisor

```bash
# Runs during configured hours (default: 10 PM - 6 AM)
python autonomous_supervisor.py
```

### 5. Review Results

```bash
# Morning: check what happened
cat autonomous_progress.log
git diff
```

## Features

- ✅ **Time-windowed execution**: Only runs during configured hours
- ✅ **Task queue system**: FIFO processing with state persistence
- ✅ **Fair use limits**: 8-10 hours/day (matches realistic human usage)
- ✅ **Progress logging**: Detailed logs of all activity
- ✅ **Error handling**: Graceful failure with logging
- ✅ **Ethical design**: Respects ToS and community fairness

## Configuration

Edit `autonomous_supervisor.py`:

```python
# Night shift (while you sleep)
NIGHT_START = dt_time(22, 0)   # 10:00 PM
NIGHT_END = dt_time(6, 0)      # 6:00 AM
# Total: 8 hours

# Optional: Day shift (while at work)
DAY_START = dt_time(9, 0)      # 9:00 AM
DAY_END = dt_time(11, 0)       # 11:00 AM
# Total: 10 hours (8 night + 2 day)
```

## Capacity

### z.ai Pro Plan ($15/month)
- 600 prompts per 5 hours
- ~1,200 prompts per 8-hour night
- ~80-120 tasks per night
- **Way more than you'll need**

### z.ai Max Plan ($30/month)
- 2,400 prompts per 5 hours
- ~4,800 prompts per 8-hour night
- ~320-480 tasks per night
- **Massive capacity**

## Ethics & Fairness

### What This Does ✅
- ✅ Fills availability gaps (sleep + work)
- ✅ Uses approved tool (Cline CLI) as designed
- ✅ Respects fair use (10 hours/day = human limit)
- ✅ Legitimate productivity enhancement

### What This Doesn't Do ❌
- ❌ Circumvent rate limits
- ❌ Abuse quota (same usage as manual)
- ❌ Violate ToS (100% compliant)
- ❌ Game the system (transparent use)

### Why This Is Fair

**Manual usage** (if you had infinite time):
- 10 hours/day actively coding
- ~600-1000 prompts/day

**Autonomous usage** (this system):
- 8-10 hours/day during unavailable hours
- ~600-1000 prompts/day

**Difference**: Not more usage, just different timing.

## Documentation

See [AUTONOMOUS_DEVELOPMENT.md](AUTONOMOUS_DEVELOPMENT.md) for complete documentation:
- Setup guide
- Configuration options
- Usage patterns
- Monitoring & debugging
- FAQ & troubleshooting

## Requirements

- Python 3.8+
- Node.js 18+ (for Cline CLI)
- z.ai coding plan (Lite, Pro, or Max)
- Git (optional, recommended)

## License

MIT

## Credits

Built for [AIUML project](https://github.com/aiuml) to enable 24/7 development on [aiuml-forge](https://github.com/aiuml/forge).

Uses:
- [Cline CLI](https://cline.bot/) - Open source autonomous coding agent
- [z.ai](https://z.ai/) - Affordable AI coding platform (GLM-4.6)

## Disclaimer

This tool uses Cline CLI's autonomous mode as designed. It respects z.ai's terms of service by using approved tools within fair use limits. If you have concerns about usage patterns, please contact z.ai support or adjust your configuration.

**Use responsibly and ethically.** 🙏
