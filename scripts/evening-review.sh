#!/bin/bash
# Evening fire-and-forget agent review
# Review what background agents accomplished during the day

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
echo ""
echo "Decision Guide:"
echo "  ✅ Good work → git add . && git commit -m 'Accept agent work'"
echo "  ⚠️ Minor issues → Fix manually, then commit"
echo "  ❌ Major issues → git restore . (revert) and queue for rework"
echo ""
