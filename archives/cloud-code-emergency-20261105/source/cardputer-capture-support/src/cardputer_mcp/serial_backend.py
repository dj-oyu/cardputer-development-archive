"""Opt-in ordinary PocketJS serial operations. No reset, flash, upload, or raw command API.

A single dedicated worker thread opens, reads, writes and closes the port for one
approved job. All consumers receive sanitized events from that one reader.
"""

import asyncio
import hashlib
import json
import os
import re
import time
from collections.abc import Callable, Iterable
from typing import Any, Protocol

from .backend import BackendResult, DeviceOperationFailure
from .capture import CapturedImage, CaptureError, LegacyCaptureDecoder
from .config import SerialSettings
from .models import TestName
from .ports import PortInfo, enumerate_ports, resolve_port

ANSI = re.compile(rb"\x1b\[[0-?]*[ -/]*[@-~]")
PREFIX = re.compile(rb"^[IWEVD] \([^\r\n)]*\) [A-Za-z0-9_.-]+: ")
FAULT = re.compile(
    rb"Guru Meditation|panic(?:'ed)?|START_FAILED|PRESENTER_STEP_FAILED|APP_ERROR|"
    rb"APP_REFUSED|EXECUTION FAILED|abort\(|assert(?:ion)? failed|Stack canary|"
    rb"stack overflow|watchdog|Brownout detector|ESP_ERROR_CHECK failed|"
    rb"FRAME RUNAWAY|JOB QUEUE RUNAWAY",
    re.IGNORECASE,
)
FINAL_MEMORY = re.compile(rb"MEM free=(\d+) largest=(\d+) js=(\d+) frames=(\d+)")
KNOWN = {
    b"HOME_READY": "serial_home_ready",
    b"CATEGORY 0": "serial_category_apps",
    b"APP 0": "serial_row_hello",
    b"APP_ID local.hello": "serial_identity_hello",
    b"HELLO_READY": "serial_hello_ready",
    b"HELLO_COUNT 1": "serial_hello_count_one",
    b"HELLO_FRAME_PRESENTED": "serial_frame_presented",
    b"KASANE_FRAME_PRESENTED": "serial_frame_presented",
    b"APP_STOPPED": "serial_app_stopped",
}


class SerialPort(Protocol):
    dtr: bool
    rts: bool
    port: str | None
    is_open: bool

    def open(self) -> None: ...
    def close(self) -> None: ...
    def read(self, size: int = 1) -> bytes: ...
    def write(self, data: bytes) -> int | None: ...


class SerialFailure(DeviceOperationFailure):
    """Fixed-category failure; unknown device outcome always requires review."""


def make_serial() -> SerialPort:
    # Delayed until an approved job. Construct unopened, suppress control signals
    # before open. Drivers may still glitch DTR/RTS; this is not a no-reset guarantee.
    import serial

    return serial.Serial(
        port=None,
        baudrate=115200,
        timeout=0.05,
        write_timeout=1,
        exclusive=True if os.name != "nt" else None,
    )


def fingerprint(port: PortInfo) -> str:
    identity = port.model_dump(exclude={"description"})
    return hashlib.sha256(json.dumps(identity, sort_keys=True).encode()).hexdigest()


def clean_line(line: bytes) -> bytes:
    return PREFIX.sub(b"", ANSI.sub(b"", line).rstrip(b"\r"), count=1)


class Reader:
    """The only serial reader. Bounded framing retains fragmented/coalesced markers."""

    def __init__(
        self,
        port: SerialPort,
        emit: Callable[[str], None],
        clock: Callable[[], float],
        deadline: float,
    ) -> None:
        self.port, self.emit, self.clock, self.deadline = port, emit, clock, deadline
        self.pending = b""
        self.lines: list[bytes] = []
        self.bytes_read = 0
        self.fault_tail = b""
        self.step = "operation"
        self.expected_marker: str | None = None
        self.recognized_markers = 0
        self.capture_guard = False
        self.capture_decoder: LegacyCaptureDecoder | None = None

    def failure(self, code: str) -> SerialFailure:
        return SerialFailure(
            code,
            step=self.step,
            expected_marker=self.expected_marker,
            received_bytes=self.bytes_read,
            received_lines=len(self.lines),
            recognized_markers=self.recognized_markers,
        )

    def read_once(self) -> bool:
        if self.clock() >= self.deadline:
            raise self.failure("serial_deadline")
        try:
            incoming = self.port.read(4096)
        except Exception:
            raise self.failure("serial_read_failed") from None
        if self.capture_guard and self.clock() >= self.deadline:
            raise self.failure("serial_capture_timeout")
        if not incoming:
            return False
        self.bytes_read += len(incoming)
        if self.bytes_read > 256 * 1024:
            raise self.failure("serial_capture_limit")
        cleaned = ANSI.sub(b"", self.fault_tail + incoming)
        if FAULT.search(cleaned):
            raise self.failure("serial_fault_marker")
        self.fault_tail = cleaned[-256:]
        capture_finished = self.capture_decoder is not None and self.capture_decoder.complete
        if self.capture_decoder is not None and not capture_finished:
            try:
                self.capture_decoder.feed(incoming)
            except CaptureError:
                raise self.failure("serial_capture_invalid") from None
        self.pending += incoming
        if len(self.pending) > 16384:
            raise self.failure("serial_line_limit")
        while b"\n" in self.pending:
            raw, self.pending = self.pending.split(b"\n", 1)
            line = clean_line(raw)
            if self.capture_guard:
                if line.startswith(b"APP_ID"):
                    raise self.failure("serial_capture_unexpected_app")
                if line.startswith((b"CAPTURE_", b"PIX")):
                    if self.capture_decoder is None:
                        raise self.failure("serial_capture_boundary")
                    if capture_finished:
                        raise self.failure("serial_capture_invalid")
            # The capture decoder owns frame bytes. They must never enter the
            # marker history, public event cache or serial diagnostics.
            if self.capture_decoder is None:
                self.lines.append(line)
                if len(self.lines) > 4096:
                    raise self.failure("serial_marker_limit")
            # Only exact allowlisted markers leave the reader. Raw lines and
            # unrecognized noisy/credential-bearing data are never cached or saved.
            if event := KNOWN.get(line):
                self.recognized_markers += 1
                self.emit(event)
        return True

    def command(
        self, key: bytes, marker: bytes, *, timeout: float = 12, step: str = "command"
    ) -> list[bytes]:
        self.step = step if step in DeviceOperationFailure.STEPS else "command"
        self.expected_marker = {
            rb"HOME_READY": "HOME_READY",
            rb"CATEGORY \d+": "CATEGORY",
            rb"APP \d+": "APP_ROW",
            rb"(?:HELLO|KASANE)_FRAME_PRESENTED": "FRAME_PRESENTED",
            rb"HELLO_COUNT 1": "HELLO_COUNT_ONE",
        }.get(marker)
        capture_escape = key == b"\x1b" and marker == rb"HOME_READY" and step == "capture_home"
        if key not in (b"q", b"a", b"u", b"e") and not capture_escape:
            raise self.failure("command_not_allowlisted")
        # Drain already-buffered data through the same reader, preserving fault
        # detection. Never use reset_input_buffer to silently discard evidence.
        quiet_by = min(self.clock() + 1, self.deadline)
        while self.read_once():
            if self.clock() >= quiet_by:
                raise self.failure("serial_not_quiet_before_command")
        start = len(self.lines)
        # An old partial line cannot be accepted as the new command's acknowledgement.
        stale_partial = bool(self.pending)
        try:
            written = self.port.write(key)
        except Exception:
            raise self.failure("serial_write_failed") from None
        if written != len(key):
            raise self.failure("incomplete_serial_write")
        self.emit("serial_wait_" + self.step)
        stop = min(self.clock() + timeout, self.deadline)
        examined = start
        pattern = re.compile(marker)
        while self.clock() < stop:
            self.read_once()
            while examined < len(self.lines):
                line = self.lines[examined]
                examined += 1
                if stale_partial:
                    stale_partial = False
                    start = examined
                    continue
                if pattern.fullmatch(line):
                    return self.lines[start:examined]
        raise self.failure("serial_marker_timeout")

    def observe(self, seconds: float) -> None:
        stop = min(self.clock() + seconds, self.deadline)
        while self.clock() < stop:
            self.read_once()

    def capture_quiet_boundary(self) -> None:
        """Drain through the sole reader, requiring a quiet and empty boundary."""
        quiet_by = min(self.clock() + 1, self.deadline)
        while self.read_once():
            if self.clock() >= quiet_by:
                raise self.failure("serial_capture_boundary")
        if self.pending:
            raise self.failure("serial_capture_boundary")


def capture_home(reader: Reader) -> CapturedImage:
    """One approved legacy HOME capture; no retry, navigation loop or replay.

    Firmware 22f6d54 main/main.c:211-225 treats q/s as text in an editor,
    but :214 and :361 map Esc to KEY_BACK. The operator must first verify HOME
    and refrain from physical input: legacy firmware has no atomic capture op.
    https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/22f6d54a5c2fad6f7f40a8d5aa7cea7d7f371c51/main/main.c#L211-L225
    https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/22f6d54a5c2fad6f7f40a8d5aa7cea7d7f371c51/main/main.c#L360-L362
    https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/22f6d54a5c2fad6f7f40a8d5aa7cea7d7f371c51/main/hal/board.c#L419-L439
    """
    reader.step = "capture_home"
    reader.expected_marker = "HOME_READY"
    reader.capture_guard = True
    try:
        reader.capture_quiet_boundary()
        # Esc is intentionally fixed, and used only for this exact HOME marker.
        # A modal/editor that does not reach HOME is a failure, never another Esc.
        reader.command(b"\x1b", rb"HOME_READY", step="capture_home")
        reader.capture_quiet_boundary()
        reader.capture_decoder = LegacyCaptureDecoder()
        reader.expected_marker = "CAPTURE_END"
        try:
            written = reader.port.write(b"s")
        except Exception:
            raise reader.failure("serial_write_failed") from None
        if written != 1:
            raise reader.failure("incomplete_serial_write")
        reader.emit("serial_wait_capture_home")
        while not reader.capture_decoder.complete:
            reader.read_once()
        # Includes bytes coalesced after END and one bounded quiet drain. A new
        # APP_ID, second frame, partial record or late fault cannot pass as success.
        reader.capture_quiet_boundary()
        try:
            return reader.capture_decoder.finish()
        except CaptureError:
            raise reader.failure("serial_capture_invalid") from None
    except SerialFailure as error:
        if error.code in ("serial_deadline", "serial_marker_timeout"):
            raise reader.failure("serial_capture_timeout") from None
        raise


def hello_cycle(reader: Reader) -> None:
    reader.command(b"q", rb"HOME_READY", step="initial_home")
    category = reader.command(b"a", rb"CATEGORY \d+", step="select_apps")
    if category[-1] != b"CATEGORY 0":
        raise reader.failure("wrong_category")
    previous: int | None = None
    for _ in range(14):
        row = reader.command(b"u", rb"APP \d+", step="select_hello")
        current = int(row[-1].split()[1])
        if current >= 14 or (previous is not None and current != max(0, previous - 1)):
            raise reader.failure("wrong_app_navigation")
        previous = current
    if previous != 0:
        raise reader.failure("hello_not_selected")
    launch = reader.command(
        b"e", rb"(?:HELLO|KASANE)_FRAME_PRESENTED", timeout=20, step="launch_hello"
    )
    if [line for line in launch if line.startswith(b"APP_ID")] != [b"APP_ID local.hello"]:
        raise reader.failure("wrong_app_identity")
    ready = [index for index, line in enumerate(launch) if line == b"HELLO_READY"]
    if len(ready) != 1 or launch.index(b"APP_ID local.hello") >= ready[0]:
        raise reader.failure("hello_not_ready_or_out_of_order")
    reader.command(b"e", rb"HELLO_COUNT 1", step="count_hello")
    stop_start = len(reader.lines)
    reader.command(b"q", rb"HOME_READY", step="stop_hello")
    reader.step = "settle"
    reader.expected_marker = "TEARDOWN"
    reader.observe(0.3)
    stopped = reader.lines[stop_start:]
    memories = [
        (index, FINAL_MEMORY.fullmatch(line))
        for index, line in enumerate(stopped)
        if line.startswith(b"MEM ")
    ]
    stops = [index for index, line in enumerate(stopped) if line == b"APP_STOPPED"]
    homes = [index for index, line in enumerate(stopped) if line == b"HOME_READY"]
    if len(memories) != 1 or len(stops) != 1 or len(homes) != 1:
        raise reader.failure("teardown_sequence_missing")
    index, match = memories[0]
    if match is None or not index < stops[0] < homes[0]:
        raise reader.failure("teardown_sequence_invalid")
    free, largest, js, frames = map(int, match.groups())
    if not 0 < largest <= free or js != 0 or frames < 1:
        raise reader.failure("teardown_memory_invalid")
    if ANSI.sub(b"", reader.pending).strip():
        raise reader.failure("incomplete_final_line")
    identities = [line for line in reader.lines if line.startswith(b"APP_ID")]
    if identities != [b"APP_ID local.hello"]:
        raise reader.failure("unexpected_app_launch")


class SerialBackend:
    name = "serial"
    device = "configured-cardputer"

    def __init__(
        self,
        config: SerialSettings,
        *,
        inventory: Callable[[], Iterable[PortInfo]] = enumerate_ports,
        factory: Callable[[], SerialPort] = make_serial,
        clock: Callable[[], float] = time.monotonic,
    ) -> None:
        self.config, self.inventory, self.factory, self.clock = config, inventory, factory, clock
        self.active = self.max_active = self.calls = 0
        self.hardware_connected = False
        self.ownership_uncertain = False
        self._unclosed_port: SerialPort | None = None

    def prepare(self, test: TestName) -> dict[str, Any]:
        if test not in (TestName.OBSERVE, TestName.HELLO, TestName.CAPTURE):
            raise ValueError("test_not_available_for_backend")
        if (
            test in (TestName.HELLO, TestName.CAPTURE)
            and self.config.expected_firmware_sha256 is None
        ):
            raise ValueError("expected_firmware_required")
        port = resolve_port(self.config.selector, self.inventory())
        effects = [
            "Opens and closes USB serial; drivers may glitch control lines or reset device",
            "Exits the current app, selects HELLO, launches once, presses Enter and exits"
            if test == TestName.HELLO
            else "Receives serial bytes without sending commands",
            "No reset command, firmware flash, upload, GRID run or screenshot",
        ]
        if test == TestName.CAPTURE:
            effects = [
                "Operator must verify device is already HOME and firmware is correct; "
                "do not use physical inputs until this job finishes",
                "Opens and closes USB serial; drivers may glitch control lines or reset device",
                "Sends one fixed Esc, requires fresh HOME_READY, then sends one s; "
                "a wrong initial screen can exit an app/editor and lose unsaved state",
                "Forces HOME redraw and transmits rendered pixels, which may contain private data",
                "One frame only, 18-second reader budget, no automatic retry",
                "Render-buffer capture does not prove LCD transfer or coherent snapshot",
                "No reset command, firmware flash, upload or GRID run",
            ]
        return {
            "stages": ["serial_open", test.value, "serial_close"],
            "port": port.port,
            "device_fingerprint": fingerprint(port),
            "protocol": "pocketjs-legacy-capture-v1"
            if test == TestName.CAPTURE
            else self.config.protocol,
            "expected_firmware_sha256": self.config.expected_firmware_sha256,
            "firmware_verification": "operator_attestation_only",
            "observe_seconds": self.config.observe_seconds if test == TestName.OBSERVE else None,
            "effects": effects,
        }

    async def execute(
        self, plan: dict[str, Any], stage: Callable[[str], None]
    ) -> str | BackendResult:
        if self.active:
            raise SerialFailure("multiple_device_owners")
        self.active += 1
        self.calls += 1
        self.max_active = max(self.max_active, self.active)
        loop = asyncio.get_running_loop()

        def emit(value: str) -> None:
            loop.call_soon_threadsafe(stage, value)

        worker = loop.run_in_executor(None, self._execute_sync, plan, emit)
        interrupted = False
        try:
            # asyncio cancellation cannot stop an OS serial read/thread. Wait for
            # close to finish before returning, even when the caller is cancelled.
            while not worker.done():
                try:
                    await asyncio.shield(worker)
                except asyncio.CancelledError:
                    interrupted = True
            result = worker.result()
            if interrupted:
                raise SerialFailure("operation_interrupted_review_required")
            return result
        finally:
            if not self.ownership_uncertain:
                self.active -= 1

    def _execute_sync(
        self, plan: dict[str, Any], emit: Callable[[str], None]
    ) -> str | BackendResult:
        test = TestName(plan["test"])
        current = self.prepare(test)
        if any(plan.get(key) != value for key, value in current.items()):
            raise SerialFailure("device_or_plan_changed")
        port = self.factory()
        try:
            port.dtr = False
            port.rts = False
            port.port = current["port"]
            emit("serial_open")
            try:
                port.open()
            except Exception:
                raise SerialFailure("serial_open_failed", step="open_serial") from None
            self.hardware_connected = True
            # Narrow the enumeration/open race. USB identity is not cryptographic.
            try:
                identity = resolve_port(self.config.selector, self.inventory())
            except ValueError:
                raise SerialFailure("device_identity_changed", step="validate_identity") from None
            if fingerprint(identity) != current["device_fingerprint"]:
                raise SerialFailure("device_identity_changed", step="validate_identity")
            reader = Reader(
                port, emit, self.clock, self.clock() + (18 if test == TestName.CAPTURE else 90)
            )
            emit(test.value)
            if test == TestName.OBSERVE:
                reader.step = "passive_observe"
                reader.observe(self.config.observe_seconds)
                return "serial_observation_completed_no_commands"
            if test == TestName.CAPTURE:
                image = capture_home(reader)
                # Python completes finally before returning this result. The
                # broker never receives an image if closing the port fails.
                return BackendResult("render_buffer_captured_lcd_unverified", image)
            hello_cycle(reader)
            return "hello_markers_passed_physical_checks_not_assessed"
        except SerialFailure:
            raise
        except Exception:
            raise SerialFailure("serial_operation_uncertain") from None
        finally:
            # Exactly this worker owns close. No other consumer opens a second port.
            try:
                port.close()
                if port.is_open:
                    raise SerialFailure("serial_close_unconfirmed", step="close_serial")
            except Exception:
                self.ownership_uncertain = True
                self._unclosed_port = port
                self.hardware_connected = True
                emit("serial_close_unconfirmed")
                raise SerialFailure("serial_close_unconfirmed", step="close_serial") from None
            else:
                self.hardware_connected = False
                emit("serial_close")
