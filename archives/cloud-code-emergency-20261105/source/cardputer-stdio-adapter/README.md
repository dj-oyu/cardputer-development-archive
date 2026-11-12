# Cardputer Device MCP

Local Claude Code and Codex can share the same resident broker through the
tools-only stdio adapter. It reads one explicit private client-key file outside
repositories and forwards the broker's catalog/results without owning a device.
See [STDIO-CLIENTS.md](STDIO-CLIENTS.md) for Windows registration templates and
the distinction between shared-key identity and separate work sessions.

**A single-owner MCP/CLI broker with mock mode and an opt-in serial adapter.**
Two clients connect over Streamable HTTP and share one resident queue, one workflow
lease, durable job history, and the same bounded log cache.

Version 0.2 adds bounded passive USB observation and one ordinary HELLO cycle for
the inspected PocketJS firmware protocol. These real-adapter paths have been tested
with synthetic serial devices, **not physical hardware**. They require explicit
startup opt-in, authenticated clients and exact local per-job approval. See
[SERIAL.md](SERIAL.md) for effects, limitations and user-run Windows instructions.

Mock remains the default. `mock_flash`, `mock_boot`, and `mock_test` are synthetic.
Real flashing, cloud Tunnel deployment, screenshots and firmware build integration remain
unimplemented. A [local queue GUI](GUI-WINDOWS.md) and [logical work sessions/FIFO](SESSIONS.md)
are now implemented and mock-tested. The optional [Windows Tunnel preparation](TUNNEL-WINDOWS.md) launcher
and [local scoped-key management](KEYS.md) are available; cloud connectivity is unverified. Nothing opens USB automatically at startup.

## Windows queue GUI

Version 0.5 adds an integrated **Tunnel...** panel: metadata editing in the
broker TOML's `[tunnel]` section, explicit connect/disconnect/manual restart,
owned-process monitoring, and separate local/cloud evidence. Runtime keys are
masked and never saved. No automatic connection or restart occurs. Windows
process ownership is covered by synthetic API tests, not native Windows validation.
See [TUNNEL-WINDOWS.md](TUNNEL-WINDOWS.md).


Run `& .\Start-CardputerGui.ps1` after `uv sync --frozen` for authenticated mock mode.
See [GUI-WINDOWS.md](GUI-WINDOWS.md). Real mode requires explicit opt-in and approval.

## Windows serial startup

The bundled [Start-Cardputer.ps1](Start-Cardputer.ps1) now handles project location,
both process-only credentials, a separate visible server console and authenticated
readiness. See [START-WINDOWS.md](START-WINDOWS.md) for the one-command setup. This
helper starts no USB operation and leaves every hardware approval requirement intact.

## Quick start (mock mode)

Requires Python 3.11+ and [uv](https://docs.astral.sh/uv/). The lockfile currently
resolves the official [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk)
to **2.2.0**, using its v2 `MCPServer` and `Client` APIs. No unreviewed shell script,
firmware toolchain, ESP-IDF installation, API key, or connected device is needed.

From this project directory, in PowerShell or a Linux terminal:

```sh
uv sync --frozen
uv run cardputer serve --config examples/mock-demo.toml
```

Keep that terminal running. In a second terminal in the same project directory:

```sh
uv run cardputer status
uv run cardputer demo
```

Expected demo result:

```text
MOCK DEVICE / REAL MCP HTTP: one broker, two clients
1. Local CLI owns the whole flash -> boot -> test session
2. Second MCP client: device_busy (same broker, no second USB reader)
3. MOCK workflow passed; both clients read identical cached logs
4. Retrying the job ID returns the original result; no replay
5. Local releases; second MCP client acquires the device
PASS: exclusive ownership, shared logs, durable jobs, safe retry
No USB / real flash / Tunnel connection was used
```

`uv run cardputer demo --recording` spaces the visible results across about
21 seconds, suitable for a short screen recording. Show the MOCK label: the demo
proves actual MCP transport and arbitration, not an actual firmware flash or a
Tunnel connection. It does not print private lease capabilities. Stop the server
with Ctrl+C; shutdown drains any active mock workflow before releasing the lock.

`examples/mock-demo.toml` is an explicit **local-operator opt-in for synthetic
operations only**. The default policy requires individual local approval.

## Safer approval workflow

Start `uv run cardputer serve --config examples/mock-safe.toml` instead. MCP
clients can prepare plans but cannot grant approvals. In PowerShell:

```powershell
$lease = uv run cardputer acquire --owner local_cli --seconds 300 | ConvertFrom-Json
$plan = uv run cardputer prepare --session $lease.session --job trial-001 --test diagnostics | ConvertFrom-Json
uv run cardputer approve --state-dir .state/safe --plan $plan.plan_hash
# Inspect the printed immutable plan, then type the exact requested APPROVE phrase
uv run cardputer execute --session $lease.session --plan $plan.plan_hash
uv run cardputer job trial-001
uv run cardputer release --session $lease.session
```

`approve` is a local operator command, not an MCP tool. It only writes an approval
record to the local SQLite database while the broker is running. The broker
atomically consumes that approval and inserts the exact job in one transaction.
The SHA-256 binds the broker epoch, session, synthetic device, backend, job ID,
test, and ordered stages. Changing any field invalidates it. Approvals cannot be
reused for another job, lease, or broker restart. MCP annotations are descriptive;
actual enforcement is in the broker. If an agent is given shell/database access,
that agent is inside this local-operator trust boundary; an `APPROVE` prompt is
not a security boundary against that agent.

Lease capabilities authorize operations within a session. Keep them out of
public videos, chat, shared terminal history and screenshots. Display names
`local_cli` and `remote_mcp` are informational labels in mock mode. Serial mode
binds ownership to distinct authenticated clients.

## Architecture and invariants

```text
Local CLI -------> one Streamable HTTP /mcp endpoint ----> resident broker
Second MCP client --^                                      |
Future authenticated Tunnel ingress (not connected) --------^
                                                        SQLite jobs
                                                        in-memory lease
                                                        single worker
                                                        mock or opt-in serial
                                                        bounded event cache
```

- The CLI always connects to the existing HTTP service. It never creates another
  broker, serial reader, or stdio-owned hardware process as a fallback
- A non-blocking process lock excludes cooperating brokers for the same OS user
  in the same OS temporary-directory namespace, across worktrees, HTTP ports and
  state directories. Another state lock protects database recovery/review
- One session owns the entire operation sequence. Builds may eventually run in
  parallel outside this broker; physical flash/boot/test ownership must not be
  split between those stages
- Leases use monotonic time. Expiry cancels queued work and blocks further lease
  operations, but retains the active owner's device until the active adapter
  returns. A client disconnect does not cancel the worker
- Active jobs cannot be forcibly cancelled through MCP. Queued jobs can be
  cancelled by their lease owner. This release starts no child processes; future
  flash adapters must wait for the entire subprocess tree to exit before unlock
- Job IDs are unique within the retained database. Retries of one immutable plan
  return its original job; a conflicting reuse is rejected. After lease expiry,
  read `job_status` instead of trying to execute an old capability
- Restart converts both `queued` and `running` jobs to `needs_review`. Nothing is
  replayed. New sessions are blocked while any unacknowledged review is present
- Disconnects and unexpected adapter errors quarantine work for review. There is
  no implicit retry, port substitution, reset, flash, or recovery operation
- Cache reads use `{epoch, sequence}` cursors. Different clients read identical
  events without consuming them. Gaps caused by eviction or restart are explicit
- There is one device/session, up to 32 queued jobs by default, 256 cached events,
  a maximum 100 events per read, a 16 KiB HTTP body limit, and a 10,000-record cap
  for each of plans and jobs. History is never silently pruned: archive/reset
  offline as an explicit operator action when the cap is reached

### Interrupted work

1. Inspect `uv run cardputer job JOB_ID` and `uv run cardputer status`
2. Stop the broker
3. Run `uv run cardputer review --state-dir YOUR_STATE_DIR --job JOB_ID`
4. Inspect the saved result and type the exact `REVIEW JOB_ID` phrase
5. Restart the broker, acquire a new lease and prepare a new job if appropriate

Review acknowledgement does **not** rerun or mark the original action successful.
Do not delete the database to hide an interrupted operation. In serial mode, an
operator must establish the real physical state before acknowledgement.

## MCP tools

The endpoint is `http://127.0.0.1:8765/mcp`. Tools with arguments accept a nested
`request` object. All request models reject extra fields.

| Tool | Input summary | Effect |
| --- | --- | --- |
| `device_status` | none | Read backend/device/broker status |
| `read_logs` | optional cursor, limit | Read shared cached events |
| `acquire_session` | owner, lease_seconds | Obtain private session capability |
| `renew_session` | session, lease_seconds | Extend an unexpired lease |
| `release_session` | session | Release idle ownership, cancel queued work |
| `prepare_test` | session, job_id, test | Persist immutable allowlisted plan |
| `execute_test` | session, plan_hash | Enqueue only an approved plan |
| `job_status` | job_id | Read durable job result |
| `cancel_job` | session, job_id | Cancel queued work only |

Mock tests: `diagnostics`, `firmware_workflow`. Serial tests: `passive_observe`,
`hello`, with mandatory local approval and authentication. No generic shell, raw
serial, arbitrary file path, command upload, real flash, fault injection or image
capture tool exists. Domain failures use structured `{ok:false,error:...}`;
SDK validation failures return a generic MCP tool error without reflecting inputs.

## Windows 11 USB boundary

The project has **read-only** pySerial inventory and pure device-identity matching:

```sh
uv run cardputer ports
```

This explicit command lists current port name, VID, PID, USB serial number,
location and description. It never opens a port. Port metadata can identify your
device, so keep real output private. Inventory is not called during startup/demo.
`DeviceSelector` requires VID/PID plus serial number and/or USB location; resolving
an absent or ambiguous device fails closed. The current COM name is discovered
anew rather than hard-coded. Tests cover a synthetic COM-name change and Linux
`/dev/ttyACM*` naming without touching USB.

The opt-in pySerial adapter supports only bounded observation and HELLO; see
[SERIAL.md](SERIAL.md). Actual Windows driver/reset behavior, physical reconnect
identity and Linux permissions/exclusive-open behavior still need authorized
hardware validation. No bootloader PID substitution or flash adapter is available. A broker lock cannot prevent an unrelated terminal or flash
program from opening a real device; all participating tools must integrate with
one broker and the adapter must also acquire OS-level serial exclusivity.

## Network and private/public separation

- Loopback-only binding is enforced. Non-loopback clients, untrusted Host/Origin,
  forwarded identity headers and non-JSON POSTs are rejected. Proxy headers are
  disabled; the local client ignores environment HTTP/SOCKS proxies
- Mock authentication is opt-in; GUI and Tunnel preparation require it. Serial
  mode always requires bearer authentication and principal-bound leases. Optional
  scoped keys add local hash-only issuance, expiry and revocation. The process
  lock coordinates trusted processes; it is not a hostile-OS-user boundary
- Do not expose the broker through an arbitrary public reverse proxy. The pinned
  official Tunnel client uses the same authenticated loopback endpoint, with
  local origin/scope/Host checks intact. Hosted connector routing and actual
  account-backed invocation remain unverified; no cloud access is provisioned
- Local CLI and authenticated Tunnel traffic terminate at this same broker.
  Never deploy a second broker per client or per worktree. Merely labeling a
  client `remote_mcp` does not establish a Tunnel connection
- Public source and examples contain synthetic values only. Runtime databases,
  approvals, private local configuration and `.env` files are ignored by Git
- The cache contains structured synthetic events or exact allowlisted serial
  markers, not raw firmware logs. Unknown serial text, capabilities and raw driver
  exceptions are not saved in SQLite/event logs. Full raw-log capture is absent
- Config `state_dir` is relative to the directory from which you launch the server.
  Use a user-owned local directory on Windows; POSIX new directories use 0700 and
  the database uses 0600. Avoid shared/synchronized runtime-state folders

## Verification and limits

```sh
uv sync --frozen
uv run ruff check src tests
uv run ruff format --check src tests
uv run mypy src
uv run pytest -q
```

Tests include real TCP/HTTP MCP discovery and tool calls, client disconnect and
reconnect, two origins sharing one owner, whole-workflow locking, active lease
expiry, queue cancellation, approval consumption, retry deduplication, recovery
review, disconnect quarantine, port changes, bounded log fan-out, rejection of
credential-like inputs in error messages, and HTTP trust boundaries.

Automated checks run in a Linux cloud environment using Python 3.12. The original
mock status/demo was also reported successful by a user on Windows 11. Real Windows
USB access, driver behavior, physical protocol, flash/reboot and Tunnel deployment
are **not hardware-validated**. Existing
firmware projects, GUI, IDF environment and build worktrees are unchanged and are
not yet wired into this broker. Optional project/IDF paths belong in future private
local configuration, not public examples.

A future screenshot API may return a bounded, authenticated MCP image resource
once firmware can produce a verified capture. No placeholder bitmap is presented
as device evidence. Existing text-screen capture commands must not be assumed safe
or compatible without protocol-specific validation.

## Sources

- [Official Python SDK](https://github.com/modelcontextprotocol/python-sdk)
- [SDK v2 migration and APIs](https://py.sdk.modelcontextprotocol.io/migration/)
- [MCP specification](https://modelcontextprotocol.io/specification/latest)

License: MIT. Publication destination and remote repository are intentionally not
configured by this source project.
