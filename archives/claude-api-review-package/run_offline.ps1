$ErrorActionPreference = 'Stop'
function Invoke-CheckedUv {
    & uv @args
    if ($LASTEXITCODE -ne 0) { throw 'Offline verification failed' }
}
Invoke-CheckedUv sync --frozen
Invoke-CheckedUv run --frozen --no-sync python -m unittest discover -s lambda/tests -p test_claude_provider.py -v
Invoke-CheckedUv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_live_pilot.py -v
Invoke-CheckedUv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_tool_plan.py -v
Invoke-CheckedUv run --frozen --no-sync python scripts/claude_live_pilot.py
Invoke-CheckedUv run --frozen --no-sync ruff check lambda/ai_processor.py lambda/claude_provider.py lambda/tests/test_claude_provider.py scripts/claude_live_pilot.py scripts/tests/test_claude_live_pilot.py scripts/tests/test_claude_secret_sync.py
Invoke-CheckedUv run --frozen --no-sync mypy --follow-imports=silent lambda/ai_processor.py lambda/claude_provider.py
# Linux deployment-shell matrix is intentionally skipped on Windows.
# Do not change permissions or temp locations to bypass a denied temp directory.
