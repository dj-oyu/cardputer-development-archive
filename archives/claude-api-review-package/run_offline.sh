#!/bin/sh
set -eu
uv sync --frozen
uv run --frozen --no-sync python -m unittest discover -s lambda/tests -p test_claude_provider.py -v
uv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_live_pilot.py -v
uv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_tool_plan.py -v
uv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_secret_sync.py -v
uv run --frozen --no-sync python scripts/claude_live_pilot.py
uv run --frozen --no-sync ruff check lambda/ai_processor.py lambda/claude_provider.py lambda/tests/test_claude_provider.py scripts/claude_live_pilot.py scripts/tests/test_claude_live_pilot.py scripts/tests/test_claude_secret_sync.py
uv run --frozen --no-sync mypy --follow-imports=silent lambda/ai_processor.py lambda/claude_provider.py
