#!/bin/bash
# Morning fire-and-forget agent launcher
# Launch background agents for mechanical tasks - zero context cost!

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
