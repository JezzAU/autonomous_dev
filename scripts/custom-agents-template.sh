#!/bin/bash
# Custom fire-and-forget agent template
# Copy this file and customize for your specific project needs

echo "🚀 Launching custom agent workforce..."
echo ""

# =============================================================================
# CUSTOMIZE BELOW: Replace with your project-specific tasks
# =============================================================================

# Example: Documentation agents
echo "📚 Documentation agents..."
# cline "Your documentation task here" --yolo --oneshot &
# cline "Another documentation task" --yolo --oneshot &

# Example: Testing agents
echo "🧪 Testing agents..."
# cline "Your testing task here" --yolo --oneshot &
# cline "Another testing task" --yolo --oneshot &

# Example: Code quality agents
echo "✨ Code quality agents..."
# cline "Your code quality task here" --yolo --oneshot &
# cline "Another code quality task" --yolo --oneshot &

# Example: Refactoring agents
echo "🔧 Refactoring agents..."
# cline "Your refactoring task here" --yolo --oneshot &
# cline "Another refactoring task" --yolo --oneshot &

# =============================================================================
# SAFETY GUIDELINES
# =============================================================================
#
# ✅ GOOD for fire-and-forget:
#   - Documentation generation
#   - Test writing (for existing code)
#   - Code formatting and linting
#   - Type hint additions
#   - Converting prints to logging
#   - Simple refactoring patterns
#
# ❌ BAD for fire-and-forget:
#   - Architecture changes
#   - Database migrations
#   - Security-critical code
#   - API contract changes
#   - Complex algorithms
#   - Anything that can cause data loss
#
# =============================================================================

echo ""
echo "✅ Launched X background agents"
echo "📊 Review progress: cline task list"
echo "🕐 Review results: ./scripts/evening-review.sh"
echo ""
