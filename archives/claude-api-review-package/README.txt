Claude API feature distribution

Repository: https://github.com/dj-oyu/echo-line-bot
Base main: b93459d26d208c40527b13b6cdfaecb1f0586179
Feature commit: 1b1a904b52d53417118d605859ac988ce264bba1
Commits: 2b6c45e, 813dd65, 1b1a904

Contains a full change patch, prerequisite-based Git bundle, portable offline
test commands, prompt/schema comparison, review evidence and cost guard notes.
No local .env, Git config, AWS credentials, real API keys, real user conversations,
Windows/WSL user paths, installed dependencies or raw machine logs are included.
Git bundle includes commit author identity using the project's GitHub noreply policy.

Import into a fresh checkout (replace ../ only with the extracted ZIP location):
  git clone https://github.com/dj-oyu/echo-line-bot.git echo-line-bot
  cd echo-line-bot
  git fetch ../claude-api.bundle HEAD:refs/heads/local-claude-review
  git checkout local-claude-review

Alternative patch import, instead of the bundle:
  git checkout -b local-claude-review b93459d26d208c40527b13b6cdfaecb1f0586179
  git apply --check ../claude-api.patch
  git apply ../claude-api.patch

Requirements: existing Python 3.14 and uv; dependency installation downloads
the public locked packages. No API key, GitHub login or AWS account is required
for the minimum mocked tests. Do not run --execute for an offline check.

Minimum offline check (from repository root):
  uv sync --frozen
  uv run --frozen --no-sync python -m unittest discover -s lambda/tests -p test_claude_provider.py -v
  uv run --frozen --no-sync python -m unittest discover -s scripts/tests -p test_claude_live_pilot.py -v
  uv run --frozen --no-sync python scripts/claude_live_pilot.py
  python ../verify_prompt_contract.py

For more offline checks, run ../run_offline.sh on a normal Linux shell or
../run_offline.ps1 on Windows. The full CDK checks additionally require the
repository's pinned pnpm and existing Node 22+. From the repository root:
  ./scripts/build-layer.sh
  python scripts/verify-layer-imports.py
  cd cdk
  pnpm install --frozen-lockfile
  pnpm run build
  pnpm test
  pnpm run cdk synth -- --strict --lookups=false --no-staging
The Layer import requires native Linux x86_64 Python 3.14, outside the project
virtualenv. No AWS credentials are needed for the offline import script; AWS is mocked.
For synth provide dummy credentials and a synthetic CDK account, never real keys.

Current restrictions: no push, paid API call, PR, main merge or deploy occurred.
The manual-only Claude test is ready but feature push was blocked by automated
approval review; it requires direct human approval. See review-report.txt.
