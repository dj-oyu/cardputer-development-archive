# Verification

Version 0.2 verified on 2026-10-02 in a Linux cloud workspace, Python 3.12,
locked MCP Python SDK 2.2.0. **No actual USB device was opened or operated.**

Passed:

- `uv sync --frozen`
- `uv run ruff check src tests`
- `uv run ruff format --check src tests`
- `uv run mypy src` (strict, all 14 source modules)
- `uv run pytest -q` (208 tests)
- `uv build` (wheel and source distribution)
- Actual localhost Streamable HTTP server + original mock CLI demo
- Actual HTTP + real serial-adapter code + synthetic serial port: authentication,
  owner binding, exact local approval, HELLO marker validation and ownership handover

The suite includes 81 original mock/broker/HTTP cases, 41 authentication cases,
20 serial-adapter tests, 26 independent synthetic serial safety regressions and
one authenticated serial-backend HTTP integration case. Credentials and serial
identities in tests are deliberately synthetic; no external-service credential
or hardware setup was performed.

Serial review specifically reproduced and fixed stale buffered acknowledgements,
startup ordering, duplicate coalesced teardown, unconfirmed port close, and
cancellation of a worker wrapper while its underlying reader still ran. The
review suite passes after those fixes.

The original mock status/demo was separately reported successful by a user on
Windows 11. That validates the mock workflow there, not the new serial adapter,
Windows authentication setup, driver/reset behavior or the full test suite.

Not run or not implemented:

- Actual Windows USB open/read/write/close, driver control-line behavior and
  physical HELLO execution with this adapter
- Real firmware image attestation, flash/reboot, subprocess-tree handoff, GRID,
  fault injection or screenshot capture
- Tunnel authentication/deployment or cloud-controller access
- Firmware build/ESP-IDF or existing GUI integration
- Remote Git publication or CI execution

Read SERIAL.md before any user-authorized hardware operation. A successful
synthetic test is not proof of physical-device success.

## Windows launcher increment

Start-Cardputer.ps1 was added without changing application backend/auth code.
Its 15 tests cover listener/lock refusal, generic errors, bounded readiness, idle
state checks and an actual authenticated HTTP status check against a synthetic
serial backend, with zero port opens. The full suite passes (184 tests).
Independent static review checked PowerShell 5.1/7 constructs, path quoting,
environment inheritance, failure cleanup and console visibility. No PowerShell
executable was available here, so native parsing/Windows launch remains unverified.

## Sanitized failure-diagnostics increment

The full suite now passes 208 tests. New tests distinguish silence, noisy
unrecognized prefixes, read/write errors and marker timeout; retain safe logical
step/expected-marker/count fields; migrate older history without clearing review;
and reject raw error/secret reflection. Pinned firmware source 22f6d54 and ordinary
ESP_LOG/ANSI fixtures confirm that being on HOME alone is not a reason to bypass
the initial Back acknowledgement. No hardware or control-signal changes were run.

## v0.3 scoped keys and Tunnel preparation checkpoint

444 tests pass; Ruff and strict mypy (17 source modules) pass. Includes actual
loopback HTTP tests for current MCP and three legacy versions, a synthetic relay
contract, authenticated mock mode, registry/operator security, and mocked native
client supervision. The new tests use synthetic credentials only. Independent
reviews fixed foreign-owned ancestor handling, interrupted key disclosure, Windows
console allocation and console credential lifetime. Native PowerShell 5.1/7,
official client execution, account-backed Tunnel discovery and hardware were not run.
The official v0.0.15 Windows AMD64 archive was read-only inspected and its published
ZIP digest/member digest checked; it is not installed or included in this package.

No logical cross-client waiting queue or management GUI is included in this
checkpoint; those are separate subsequent work. Existing device_busy behavior stays.

## v0.4 logical sessions, FIFO and native queue GUI

Final aggregate: **608 tests passed**, Ruff lint/format passed, strict mypy passed
for all 20 source modules, and `uv sync --frozen --offline` installed the local
0.4.0 package successfully. No dependency expansion was needed for Tkinter.

New coverage includes separate resume/per-grant capabilities, same-key distinct
work sessions, reconnect, FIFO/legacy fairness, cancellation races, waiter versus
lease expiry, live revocation/scope checks, active/uncertain-close holds, stale
lease and plan rejection, restart invalidation/quarantine, bounded history/views,
slow-metadata TTL expiry, local-only operator auth and stale-reorder revision CAS.
Independent review found and fixed an old-owner dequeued job being spuriously
quarantined after handover even though no backend operation began.

An actual native **Linux** GUI was exercised on the cloud desktop against an
actual authenticated loopback HTTP broker with a synthetic backend: three logical
sessions, one owner, two waiters; select/reorder/cancel; reject the release dialog;
confirm idle release; observe exactly the next waiter receive a fresh lease.
The final ASCII labels were visually checked. Clicking Close window left the
broker reachable via authenticated HTTP before the disposable fixture cleaned up
its own broker. The GUI itself did not stop broker work.

This is not Windows-native GUI/PowerShell verification, a cloud Tunnel connection,
or physical Cardputer validation. No real API key or persistent user access was
issued, no real serial port was opened, no hardware job retried, and no repository
was published. The pre-existing diagnostic and needs_review behavior is preserved.

## v0.5 GUI-owned Tunnel supervision and shared TOML

Final aggregate: **822 tests passed**, Ruff lint/format and strict mypy (23 source
modules) passed. New tests cover atomic Windows job assignment and restricted
handle inheritance through a synthetic Win32 API, subtree accounting and uncertain
cleanup, process loss/restart, auth-failure stop, repeated operations, secret
lifetime/redaction, role introspection, canonical/legacy conflict detection,
Unicode TOML round trips, atomic metadata save and external-config changes.
Health tests include real loopback slow-header and slow-body responses to verify
the total timeout covers headers as well as streamed body.

Native Linux Tk smoke used a **simulated Tunnel manager** and a real authenticated
mock broker with one gated running job. Verified masked credential entry, visible
unexpected exit code, no automatic reconnect, fresh input on reconnect/manual
restart, and close confirmation. After connect -> simulated exit -> reconnect ->
manual restart -> GUI close, authenticated broker state still reported the same
active job and backend execution count1. The fixture then completed and stopped
its own synthetic broker. The official tunnel-client was not executed.

Windows PowerShell, the Job Object implementation on actual Windows, official
client startup, account-backed cloud polling/app discovery and real USB were not
validated. No user key was issued, no account/Tunnel created, no network/security
setting changed, and no hardware operation retried. Existing private configs,
job history and needs_review remain outside the distribution archive.


## v0.5.1 HTTP denial diagnostics

Final aggregate: **932 tests passed** on CPython 3.12.14; Ruff lint/format passed
(58 Python files), strict mypy passed (24 source modules), and frozen offline uv
sync installed v0.5.1. No dependency versions changed.

Fixed-size process-local denial counters preserve existing guard/auth decisions
and error bodies. The new GET operator endpoint requires local control authority
and has no MCP-tool counterpart. Tests cover each denial gate and its precedence,
unchanged responses, downstream redaction, no body reads, bounded/copied/saturating
snapshots, scope restrictions, exact paths/methods, real authenticated mock HTTP,
CLI failure redaction, and GUI stale/closed/repeated-action guards.

Cloud Linux Tk smoke visibly displayed a synthetic origin rejection as
origin_not_allowed=1, layer=guard, route=mcp, HTTP=403. Its other counters were zero.
The follow-on native dialog dismissal/reopen step was not verified after the
computer-action approval block. Unit tests cover repeat and close/result behavior.
Native Windows PowerShell/Tk and real hosted Tunnel request reproduction were not
run here. No real USB or account operation was performed.

See [HTTP-DIAGNOSTICS.md](HTTP-DIAGNOSTICS.md) for the idle-only source update and
GUI baseline/comparison steps. Counts start at broker startup and cannot recover
previous failures or prove individual request identity.


## v0.5.2 Explicit authenticated Tunnel ingress

Final aggregate: **1080 tests passed** on CPython 3.12.14 (30.92 seconds); Ruff
lint/format passed (60 Python files), strict mypy passed (24 source modules),
and frozen offline uv sync installed v0.5.2. No dependency versions changed.

An explicit strict boolean `[tunnel] ingress_enabled = true` enables exactly
`/tunnel/mcp` on the same authenticated loopback broker. Default remains false.
The five documented proxy metadata headers are discarded only after raw guard
checks and current remote/read authentication; the original guard and MCP auth
run again. No forwarding metadata becomes identity, URL, peer or permission.
Direct MCP/operator guards, device ownership and local plan approval remain.

81 dedicated ingress tests cover raw guard order, exact routing and mount/query
rejection, duplicates, unknown forwarding names, scope and live-key rejection,
revocation between gates, immutable ASGI scope/body/header forwarding, actual
SDK legacy/modern discovery over mock HTTP, shared leases/work sessions, approval
denial, operator isolation and no leaked input. All real HTTP fixtures assert
zero backend execution. Config tests cover default-off/strict booleans, legacy
conflicts, GUI preservation, derived child URL and stale broker refusal. Console
startup now also refuses local operator keys before launching its child.

Independent safety review found no remaining blocker after the console identity
and PowerShell configuration fixes. A separate real mock HTTP smoke verified
that forwarded metadata succeeds on the enabled alias, stays rejected on direct
/mcp, and bad Origin stays rejected. No real Tunnel account, Windows runtime,
USB operation or changed user configuration was exercised here. The actual
cloud request's precise forwarding names remain uncollected; unknown names and
non-JSON POSTs intentionally remain rejected. Cloud discovery is still subject
to the operator's next explicit mock validation.
