"""Single resident owner: independent of MCP connections and client lifetimes."""

import asyncio
import hashlib
import json
import os
import secrets
import tempfile
import time
from collections.abc import Callable
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any
from uuid import uuid4

from filelock import FileLock, Timeout

from .backend import Backend, DeviceDisconnected, DeviceOperationFailure, MockBackend
from .config import Settings
from .logs import Event, LogBook
from .models import (
    AcquireRequest,
    CancelDeviceRequest,
    CancelRequest,
    CloseWorkSessionRequest,
    CreateWorkSessionRequest,
    ExecuteRequest,
    LeaseRequest,
    LogRequest,
    PrepareRequest,
    RenewRequest,
    RequestDeviceRequest,
    ResumeWorkSessionRequest,
)
from .store import Store


class BrokerError(ValueError):
    """Public, fixed-string errors. Do not include exceptions or request content."""


@dataclass
class Session:
    capability: str = field(repr=False)
    id: str
    owner: str
    deadline: float
    principal_id: str | None = None
    work_session_id: str | None = None
    request_id: str | None = None


@dataclass
class WorkSession:
    resume_token: str = field(repr=False)
    id: str
    owner: str
    principal_id: str
    scopes: frozenset[str]
    deadline: float
    state: str = "open"
    request_id: str | None = None


@dataclass
class DeviceWait:
    id: str
    session_id: str
    lease_seconds: int
    deadline: float
    state: str = "waiting"
    lease_id: str | None = None


def digest_plan(payload: dict[str, Any]) -> str:
    canonical = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(canonical).hexdigest()


def device_lock_path(backend: str = "mock") -> Path:
    # Stable across state directories, worktrees and localhost ports for this OS user.
    # There is ONE synthetic device. A real backend will need a physical-identity key.
    if hasattr(os, "getuid"):
        identity = str(os.getuid())
    else:  # Windows: query the OS, not mutable USERNAME/HOME environment variables.
        import ctypes
        from ctypes import wintypes

        size = wintypes.DWORD(257)
        buffer = ctypes.create_unicode_buffer(size.value)
        windows_api = ctypes.windll  # type: ignore[attr-defined]
        if not windows_api.advapi32.GetUserNameW(buffer, ctypes.byref(size)):
            raise BrokerError("cannot_resolve_os_user")
        identity = buffer.value
    user_key = hashlib.sha256(identity.encode()).hexdigest()[:16]
    directory = Path(tempfile.gettempdir()) / f"cardputer-mcp-{user_key}"
    directory.mkdir(mode=0o700, exist_ok=True)
    if directory.is_symlink():
        raise BrokerError("unsafe_lock_directory")
    return directory / f"{backend}-device.lockfile"


class Broker:
    def __init__(
        self,
        settings: Settings,
        *,
        backend: Backend | None = None,
        clock: Callable[[], float] = time.monotonic,
        lock_path: Path | None = None,
        serial_enabled: bool = False,
        principal_valid: Callable[[str, str, frozenset[str]], bool] | None = None,
    ) -> None:
        self.settings = settings
        if settings.backend == "serial" and not serial_enabled:
            raise BrokerError("serial_runtime_opt_in_required")
        if backend is not None:
            self.backend = backend
        elif settings.backend == "serial":
            from .serial_backend import SerialBackend

            assert settings.serial is not None
            self.backend = SerialBackend(settings.serial)
        else:
            self.backend = MockBackend(settings.mock_stage_seconds)
        if self.backend.name != settings.backend:
            raise BrokerError("backend_configuration_mismatch")
        self.clock = clock
        self.epoch = uuid4().hex
        self.session: Session | None = None
        self.principal_valid = principal_valid
        self.work_sessions: dict[str, WorkSession] = {}
        self.device_requests: dict[str, DeviceWait] = {}
        self.waiters: list[str] = []
        self._queue_sequence = 0
        self.maintenance: asyncio.Task[None] | None = None
        self.active_job: str | None = None
        self.logs = LogBook(settings.log_capacity)
        self.queue: asyncio.Queue[str | None] = asyncio.Queue(settings.max_queue)
        self.worker: asyncio.Task[None] | None = None
        self.store: Store | None = None
        self.closing = False
        self._device_lock = FileLock(
            str(lock_path or device_lock_path(settings.backend)), timeout=0
        )
        self._state_lock = FileLock(str(settings.state_dir / "broker.lockfile"), timeout=0)

    def _store(self) -> Store:
        if self.store is None:
            raise BrokerError("broker_not_running")
        return self.store

    async def start(self) -> None:
        self.settings.state_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
        try:
            self._device_lock.acquire()
            self._state_lock.acquire()
        except Timeout as exc:
            self._device_lock.release()
            raise BrokerError("broker_already_running") from exc
        try:
            self.store = Store(self.settings.state_dir / "history.sqlite3")
            if os.name != "nt":
                os.chmod(self.settings.state_dir / "history.sqlite3", 0o600)
            self.store.recover()
            self.logs.append(Event.STARTED)
            self.worker = asyncio.create_task(self._work(), name="single-device-worker")
            self.maintenance = asyncio.create_task(
                self._maintain(), name="single-device-maintenance"
            )
        except BaseException:
            if self.store:
                self.store.close()
                self.store = None
            self._state_lock.release()
            self._device_lock.release()
            raise

    async def close(self) -> None:
        if self.store is None:
            return
        self.closing = True
        if self.maintenance:
            self.maintenance.cancel()
            try:
                await self.maintenance
            except asyncio.CancelledError:
                pass
            self.maintenance = None
        for request_id in tuple(self.waiters):
            self._end_wait(self.device_requests[request_id], "cancelled", "broker_shutdown")
        self._cancel_queued("broker_shutdown")
        if self.worker:
            # Never cancel the device task or release its lock during an active workflow.
            await self.queue.put(None)
            await asyncio.shield(self.worker)
        if self._physical_busy():
            # An unconfirmed serial close must not advertise a free device or
            # release the broker lock. Only OS process teardown ends this hold.
            raise BrokerError("device_close_unconfirmed")
        if self.session:
            self._end_ownership("released", "broker_shutdown")
        for work in self.work_sessions.values():
            if work.state == "open":
                work.state = "closed"
                self._store().set_work_session(work.id, "closed", "broker_shutdown")
        self.logs.append(Event.STOPPED)
        self.store.close()
        self.store = None
        self._state_lock.release()
        self._device_lock.release()

    def _cancel_queued(self, reason: str) -> None:
        store = self._store()
        stopping = False
        while not self.queue.empty():
            job_id = self.queue.get_nowait()
            self.queue.task_done()
            if job_id is None:
                stopping = True
            else:
                job = store.job(job_id)
                if job and job["state"] == "queued":
                    store.set_job(job_id, "cancelled", reason)
                    self.logs.append(Event.CANCELLED)
        if stopping:
            self.queue.put_nowait(None)

    def _physical_busy(self) -> bool:
        return bool(
            self.active_job is not None
            or self.backend.active
            or getattr(self.backend, "ownership_uncertain", False)
        )

    def _principal_live(self, work: WorkSession) -> bool:
        # Cached request authentication does not authorize a later FIFO grant.
        if self.principal_valid is None:
            return False
        try:
            return (
                self.principal_valid(work.principal_id, work.owner, frozenset({"read", "control"}))
                is True
            )
        except Exception:
            return False

    def _end_wait(self, request: DeviceWait, state: str, reason: str) -> None:
        self._store().set_request(request.id, state, reason)
        request.state = state
        if request.id in self.waiters:
            self.waiters.remove(request.id)
            self._queue_sequence += 1

    def _end_ownership(self, state: str, reason: str) -> None:
        session = self.session
        if session is None:
            return
        if self._physical_busy():
            raise BrokerError("active_job_cannot_release")
        if session.request_id is not None:
            self._store().set_request(session.request_id, state, reason)
            request = self.device_requests.get(session.request_id)
            if request is not None:
                request.state = state
        self.session = None
        self._queue_sequence += 1
        self.logs.append(Event.EXPIRED if state == "expired" else Event.RELEASED)

    def maintenance_tick(self) -> None:
        """Single-event-loop transition point. No awaits or hardware opens here."""
        if self.store is None:
            return
        now = self.clock()
        for work in self.work_sessions.values():
            if work.state == "open" and now >= work.deadline:
                self._store().set_work_session(work.id, "expired", "work_session_expired")
                work.state = "expired"
        for request_id in tuple(self.waiters):
            request = self.device_requests[request_id]
            work = self.work_sessions[request.session_id]
            if work.state != "open" or now >= request.deadline:
                self._end_wait(request, "expired", "wait_expired")
            elif not self._principal_live(work):
                self._end_wait(request, "cancelled", "principal_not_authorized")
        session = self.session
        if session is not None:
            owning_work = self.work_sessions.get(session.work_session_id or "")
            if owning_work is not None and (
                owning_work.state != "open" or not self._principal_live(owning_work)
            ):
                session.deadline = min(session.deadline, now)
            if now >= session.deadline:
                self._cancel_queued("lease_expired")
                if not self._physical_busy():
                    self._end_ownership("expired", "lease_expired")
        if (
            self.closing
            or self.session is not None
            or self._physical_busy()
            or self._store().needs_review()
            or not self.waiters
        ):
            return
        request = self.device_requests[self.waiters[0]]
        work = self.work_sessions[request.session_id]
        # Recheck directly before the durable transition; no token is cached.
        if not self._principal_live(work):
            self._end_wait(request, "cancelled", "principal_not_authorized")
            return
        grant_now = self.clock()
        if grant_now >= work.deadline or grant_now >= request.deadline:
            self._end_wait(request, "expired", "wait_expired")
            if grant_now >= work.deadline:
                self._store().set_work_session(work.id, "expired", "work_session_expired")
                work.state = "expired"
            return
        lease = Session(
            secrets.token_hex(32),
            uuid4().hex,
            work.owner,
            min(grant_now + request.lease_seconds, work.deadline),
            work.principal_id,
            work.id,
            request.id,
        )
        self._store().set_request(request.id, "owning", lease_id=lease.id)
        request.state = "owning"
        request.lease_id = lease.id
        self.waiters.pop(0)
        self.session = lease
        self._queue_sequence += 1
        self.logs.append(Event.ACQUIRED)

    async def _maintain(self) -> None:
        while not self.closing:
            await asyncio.sleep(0.25)
            self.maintenance_tick()

    def _expire(self) -> None:
        self.maintenance_tick()

    def _lease(self, capability: str) -> Session:
        self._expire()
        if self.closing:
            raise BrokerError("broker_closing")
        if self.session is None or not secrets.compare_digest(self.session.capability, capability):
            raise BrokerError("invalid_session")
        if self.clock() >= self.session.deadline:
            raise BrokerError("lease_expired_active_job_retains_ownership")
        return self.session

    def status(self) -> dict[str, Any]:
        self._expire()
        store = self._store()
        session = self.session
        return {
            "backend": self.backend.name,
            "hardware_connected": self.backend.hardware_connected,
            "ownership_uncertain": bool(getattr(self.backend, "ownership_uncertain", False)),
            "device": self.backend.device,
            "broker_epoch": self.epoch,
            "active_job": self.active_job,
            "owner": session.owner if session else None,
            "lease_remaining_seconds": max(0, round(session.deadline - self.clock(), 3))
            if session
            else 0,
            "queue_depth": self.queue.qsize(),
            "wait_queue_depth": len(self.waiters),
            "work_session_count": sum(w.state == "open" for w in self.work_sessions.values()),
            "history": store.counts(),
            "needs_review": store.needs_review(),
            "approval_policy": "operator_opted_in_to_mock"
            if self.settings.allow_mock_execution
            else "local_operator_per_plan",
            "hardware_backend": "serial_observe_hello_unvalidated"
            if self.backend.name == "serial"
            else "available_opt_in_only",
            "tunnel": "not_configured",
        }

    def acquire(
        self, request: AcquireRequest, *, principal_id: str | None = None
    ) -> dict[str, Any]:
        self._expire()
        if self.closing:
            raise BrokerError("broker_closing")
        if self._store().needs_review():
            raise BrokerError("recovery_review_required")
        if self.session or self.waiters or self._physical_busy():
            raise BrokerError("device_busy")
        if self._store().record_count("device_requests") >= 10000:
            raise BrokerError("history_full_archive_offline")
        lease = Session(
            secrets.token_hex(32),
            uuid4().hex,
            request.owner.value,
            self.clock() + request.lease_seconds,
            principal_id,
        )
        request_id = uuid4().hex
        self._store().put_request(
            request_id, None, request.lease_seconds, state="owning", lease_id=lease.id
        )
        lease.request_id = request_id
        self.session = lease
        self._queue_sequence += 1
        self.logs.append(Event.ACQUIRED)
        return {
            "session": self.session.capability,
            "lease_seconds": request.lease_seconds,
            "owner": request.owner.value,
        }

    def require_owner(
        self, capability: str, owner: str, *, principal_id: str | None = None
    ) -> None:
        session = self._lease(capability)
        if session.owner != owner or (
            principal_id is not None and session.principal_id != principal_id
        ):
            raise BrokerError("authenticated_owner_mismatch")

    def renew(self, request: RenewRequest) -> dict[str, Any]:
        session = self._lease(request.session)
        session.deadline = self.clock() + request.lease_seconds
        work = self.work_sessions.get(session.work_session_id or "")
        if work is not None:
            session.deadline = min(session.deadline, work.deadline)
        return {"renewed": True, "lease_seconds": request.lease_seconds}

    def release(self, request: LeaseRequest) -> dict[str, Any]:
        self._lease(request.session)
        if self._physical_busy():
            raise BrokerError("active_job_cannot_release")
        self._cancel_queued("session_released")
        self._end_ownership("released", "session_released")
        self.maintenance_tick()
        return {"released": True}

    @staticmethod
    def _valid_scopes(scopes: frozenset[str], required: str) -> None:
        if not isinstance(scopes, frozenset) or not scopes <= {"read", "control"}:
            raise BrokerError("invalid_session_scopes")
        if "read" not in scopes or required not in scopes:
            raise BrokerError("insufficient_scope")

    def _authorized_work(
        self,
        resume_token: str,
        principal_id: str,
        scopes: frozenset[str],
        *,
        required: str = "control",
        allow_terminal: bool = False,
    ) -> WorkSession:
        self._store()
        self.maintenance_tick()
        if self.closing:
            raise BrokerError("broker_closing")
        self._valid_scopes(scopes, required)
        work = next(
            (
                item
                for item in self.work_sessions.values()
                if secrets.compare_digest(item.resume_token, resume_token)
            ),
            None,
        )
        if work is None:
            raise BrokerError("invalid_work_session")
        if principal_id != work.principal_id:
            raise BrokerError("authenticated_owner_mismatch")
        if required not in work.scopes:
            raise BrokerError("insufficient_scope")
        if work.state != "open" and not allow_terminal:
            raise BrokerError("work_session_not_open")
        return work

    def _public_request(self, request: DeviceWait) -> dict[str, Any]:
        lease = self.session
        is_owner = lease is not None and lease.request_id == request.id
        return {
            "request_id": request.id,
            "session_id": request.session_id,
            "state": request.state,
            "position": self.waiters.index(request.id) + 1 if request.id in self.waiters else None,
            "lease_id": request.lease_id,
            "wait_remaining_seconds": max(0, round(request.deadline - self.clock(), 3))
            if request.state == "waiting"
            else 0,
            "lease_remaining_seconds": max(0, round(lease.deadline - self.clock(), 3))
            if is_owner and lease is not None
            else 0,
            "active_job": self.active_job if is_owner else None,
        }

    def _public_work(self, work: WorkSession) -> dict[str, Any]:
        return {
            "session_id": work.id,
            "owner": work.owner,
            "principal_id": work.principal_id,
            "scopes": sorted(work.scopes),
            "state": work.state,
            "expires_in_seconds": max(0, round(work.deadline - self.clock(), 3)),
            "request_id": work.request_id,
        }

    def _work_result(self, work: WorkSession, scopes: frozenset[str]) -> dict[str, Any]:
        public = self._public_work(work)
        public["work_session_id"] = public.pop("session_id")
        request = self.device_requests.get(work.request_id or "")
        lease = self.session
        lease_result = None
        if (
            lease is not None
            and lease.work_session_id == work.id
            and work.state == "open"
            and self.clock() < lease.deadline
            and "control" in scopes
            and "control" in work.scopes
        ):
            lease_result = {
                "session": lease.capability,
                "lease_id": lease.id,
                "lease_seconds": max(0, round(lease.deadline - self.clock(), 3)),
                "request_id": lease.request_id,
            }
        return {
            **public,
            "request": self._public_request(request) if request else None,
            "lease": lease_result,
        }

    def create_work_session(
        self,
        request: CreateWorkSessionRequest,
        *,
        principal_id: str,
        scopes: frozenset[str],
    ) -> dict[str, Any]:
        self._store()
        self.maintenance_tick()
        if self.closing:
            raise BrokerError("broker_closing")
        self._valid_scopes(scopes, "control")
        if type(principal_id) is not str or not 1 <= len(principal_id) <= 128:
            raise BrokerError("invalid_principal")
        if sum(w.state == "open" for w in self.work_sessions.values()) >= (
            self.settings.max_work_sessions
        ):
            raise BrokerError("work_session_limit")
        if self._store().record_count("work_sessions") >= 10000:
            raise BrokerError("history_full_archive_offline")
        work = WorkSession(
            secrets.token_hex(32),
            uuid4().hex,
            request.owner.value,
            principal_id,
            scopes,
            self.clock() + request.ttl_seconds,
        )
        self._store().put_work_session(work.id, self.epoch, work.owner, principal_id, scopes)
        self.work_sessions[work.id] = work
        return {**self._work_result(work, scopes), "resume_token": work.resume_token}

    def resume_work_session(
        self,
        request: ResumeWorkSessionRequest,
        *,
        principal_id: str,
        scopes: frozenset[str],
    ) -> dict[str, Any]:
        work = self._authorized_work(
            request.resume_token, principal_id, scopes, required="read", allow_terminal=True
        )
        return self._work_result(work, scopes)

    def request_device(
        self,
        request: RequestDeviceRequest,
        *,
        principal_id: str,
        scopes: frozenset[str],
    ) -> dict[str, Any]:
        work = self._authorized_work(request.resume_token, principal_id, scopes)
        current = self.device_requests.get(work.request_id or "")
        if current is not None and current.state in ("waiting", "owning"):
            return self._work_result(work, scopes)
        if not self._principal_live(work):
            raise BrokerError("principal_not_authorized")
        if self._store().needs_review():
            raise BrokerError("recovery_review_required")
        if len(self.waiters) >= self.settings.max_waiters:
            raise BrokerError("wait_queue_full")
        if self._store().record_count("device_requests") >= 10000:
            raise BrokerError("history_full_archive_offline")
        waiting = DeviceWait(
            uuid4().hex,
            work.id,
            request.lease_seconds,
            min(self.clock() + request.wait_seconds, work.deadline),
        )
        self._store().put_request(waiting.id, work.id, request.lease_seconds)
        self.device_requests[waiting.id] = waiting
        work.request_id = waiting.id
        self.waiters.append(waiting.id)
        self._queue_sequence += 1
        self.maintenance_tick()
        return self._work_result(work, scopes)

    def cancel_device_request(
        self,
        request: CancelDeviceRequest,
        *,
        principal_id: str,
        scopes: frozenset[str],
    ) -> dict[str, Any]:
        work = self._authorized_work(
            request.resume_token, principal_id, scopes, allow_terminal=True
        )
        waiting = self.device_requests.get(request.request_id)
        if waiting is None:
            raise BrokerError("request_not_found")
        if waiting.session_id != work.id:
            raise BrokerError("request_session_mismatch")
        if waiting.state == "cancelled":
            return {**self._work_result(work, scopes), "cancelled": True}
        if waiting.state != "waiting":
            raise BrokerError("only_waiting_requests_can_be_cancelled")
        self._end_wait(waiting, "cancelled", "client_cancelled_wait")
        self.maintenance_tick()
        return {**self._work_result(work, scopes), "cancelled": True}

    def close_work_session(
        self,
        request: CloseWorkSessionRequest,
        *,
        principal_id: str,
        scopes: frozenset[str],
    ) -> dict[str, Any]:
        work = self._authorized_work(
            request.resume_token, principal_id, scopes, allow_terminal=True
        )
        if self.session is not None and self.session.work_session_id == work.id:
            if self._physical_busy():
                raise BrokerError("active_job_cannot_release")
            self._cancel_queued("work_session_closed")
            self._end_ownership("released", "work_session_closed")
        waiting = self.device_requests.get(work.request_id or "")
        if waiting is not None and waiting.state == "waiting":
            self._end_wait(waiting, "cancelled", "work_session_closed")
        if work.state == "open":
            self._store().set_work_session(work.id, "closed", "client_closed_session")
            work.state = "closed"
        self.maintenance_tick()
        return {**self._work_result(work, scopes), "closed": True}

    def _queue_revision(self) -> str:
        return digest_plan({"broker_epoch": self.epoch, "sequence": self._queue_sequence})

    def operator_snapshot(self) -> dict[str, Any]:
        """Local operator view only. Public identifiers, never either capability."""
        self.maintenance_tick()
        store = self._store()
        lease = self.session
        owner = None
        if lease is not None:
            owner = {
                "lease_id": lease.id,
                "request_id": lease.request_id,
                "session_id": lease.work_session_id,
                "owner": lease.owner,
                "principal_id": lease.principal_id,
                "lease_remaining_seconds": max(0, round(lease.deadline - self.clock(), 3)),
                "release_blocked": self._physical_busy(),
            }
        # Keep every live session and an expired owner that is still physically
        # pinned. Historical rows remain durable but do not grow every GUI poll.
        current_owner = lease.work_session_id if lease is not None else None
        visible_ids = {
            work.id
            for work in self.work_sessions.values()
            if work.state == "open" or work.id == current_owner
        }
        recent_terminal = [
            work for work in reversed(self.work_sessions.values()) if work.id not in visible_ids
        ][:20]
        visible_ids.update(work.id for work in recent_terminal)
        visible_sessions = [
            self._public_work(work)
            for work in self.work_sessions.values()
            if work.id in visible_ids
        ]
        return {
            "broker_epoch": self.epoch,
            "backend": self.backend.name,
            "queue_revision": self._queue_revision(),
            "sessions": visible_sessions,
            "session_history_omitted": store.record_count("work_sessions") - len(visible_sessions),
            "waiters": [self._public_request(self.device_requests[r]) for r in self.waiters],
            "owner": owner,
            "active_job": self.active_job,
            "needs_review": store.needs_review(),
            "ownership_uncertain": bool(getattr(self.backend, "ownership_uncertain", False)),
            "recovery_requests": store.recovery_requests(),
        }

    def operator_cancel_wait(self, request_id: str) -> dict[str, Any]:
        self.maintenance_tick()
        waiting = self.device_requests.get(request_id)
        if waiting is None:
            raise BrokerError("request_not_found")
        if waiting.state != "waiting":
            raise BrokerError("only_waiting_requests_can_be_cancelled")
        self._end_wait(waiting, "cancelled", "operator_cancelled_wait")
        self.maintenance_tick()
        return {"cancelled": True, "request_id": request_id}

    def operator_reorder_wait(
        self,
        request_id: str,
        position: int,
        *,
        expected_revision: str,
    ) -> dict[str, Any]:
        self._store()
        self.maintenance_tick()
        if type(expected_revision) is not str or not secrets.compare_digest(
            expected_revision, self._queue_revision()
        ):
            raise BrokerError("stale_operator_snapshot")
        waiting = self.device_requests.get(request_id)
        if waiting is None:
            raise BrokerError("request_not_found")
        if waiting.state != "waiting":
            raise BrokerError("only_waiting_requests_can_be_reordered")
        if type(position) is not int or not 1 <= position <= len(self.waiters):
            raise BrokerError("invalid_wait_position")
        self.waiters.remove(request_id)
        self.waiters.insert(position - 1, request_id)
        self._queue_sequence += 1
        return {"reordered": True, "request_id": request_id, "position": position}

    def operator_release_idle(self, lease_id: str) -> dict[str, Any]:
        self.maintenance_tick()
        if self.session is None or self.session.id != lease_id:
            raise BrokerError("lease_not_found")
        if self._physical_busy():
            raise BrokerError("active_job_cannot_release")
        self._cancel_queued("operator_released_idle")
        self._end_ownership("released", "operator_released_idle")
        self.maintenance_tick()
        return {"released": True, "lease_id": lease_id}

    def prepare(self, request: PrepareRequest) -> dict[str, Any]:
        session = self._lease(request.session)
        store = self._store()
        if store.needs_review():
            raise BrokerError("recovery_review_required")
        try:
            details = self.backend.prepare(request.test)
        except ValueError as exc:
            raise BrokerError("backend_preflight_failed") from exc
        payload = {
            "version": 1,
            "broker_epoch": self.epoch,
            "session_id": session.id,
            "device": self.backend.device,
            "backend": self.backend.name,
            "job_id": request.job_id,
            "test": request.test.value,
            **details,
        }
        digest = digest_plan(payload)
        existing = store.job(request.job_id)
        if existing and existing["plan_hash"] != digest:
            raise BrokerError("job_id_conflict")
        if store.plan(digest) is None and store.record_count("plans") >= 10000:
            raise BrokerError("history_full_archive_offline")
        store.put_plan(digest, payload)
        return {
            "plan_hash": digest,
            "plan": payload,
            "approval_required": not self.settings.allow_mock_execution,
        }

    def execute(self, request: ExecuteRequest) -> dict[str, Any]:
        store = self._store()
        payload = store.plan(request.plan_hash)
        if payload is None or digest_plan(payload) != request.plan_hash:
            raise BrokerError("plan_not_found_or_changed")
        session = self._lease(request.session)
        if payload["broker_epoch"] != self.epoch or payload["session_id"] != session.id:
            raise BrokerError("plan_session_mismatch")
        if payload["backend"] != self.backend.name or payload["device"] != self.backend.device:
            raise BrokerError("plan_backend_mismatch")
        job_id = str(payload["job_id"])
        existing = store.job(job_id)
        if existing:
            if existing["plan_hash"] != request.plan_hash:
                raise BrokerError("job_id_conflict")
            return {**existing, "deduplicated": True}
        if store.needs_review():
            raise BrokerError("recovery_review_required")
        if self.queue.full():
            raise BrokerError("queue_full")
        if store.record_count("jobs") >= 10000:
            raise BrokerError("history_full_archive_offline")
        try:
            store.approved_enqueue(
                job_id,
                request.plan_hash,
                self.settings.backend == "mock" and self.settings.allow_mock_execution,
            )
        except ValueError as exc:
            raise BrokerError("operator_approval_required") from exc
        # No await between durable enqueue and queue insertion. Crash in between is
        # recovered to needs_review; it never causes replay.
        self.queue.put_nowait(job_id)
        self.logs.append(Event.QUEUED)
        return {**self.job(job_id), "deduplicated": False}

    def cancel(self, request: CancelRequest) -> dict[str, Any]:
        session = self._lease(request.session)
        job = self.job(request.job_id)
        plan = self._store().plan(job["plan_hash"])
        if not plan or plan["session_id"] != session.id:
            raise BrokerError("job_session_mismatch")
        if job["state"] != "queued":
            raise BrokerError("only_queued_jobs_can_be_cancelled")
        self._store().set_job(request.job_id, "cancelled", "client_cancelled_queued")
        self.logs.append(Event.CANCELLED)
        return self.job(request.job_id)

    def job(self, job_id: str) -> dict[str, Any]:
        job = self._store().job(job_id)
        if job is None:
            raise BrokerError("job_not_found")
        return job

    def read_logs(self, request: LogRequest) -> dict[str, Any]:
        return self.logs.read(request)

    async def _work(self) -> None:
        while True:
            job_id = await self.queue.get()
            try:
                if job_id is None:
                    return
                store = self._store()
                job = self.job(job_id)
                if job["state"] != "queued":
                    continue
                queued_lease = self.session.id if self.session is not None else None
                self._expire()
                if (
                    self.session is None
                    or self.session.id != queued_lease
                    or self.clock() >= self.session.deadline
                    or self.closing
                ):
                    store.set_job(job_id, "cancelled", "session_not_available")
                    continue
                plan = store.plan(job["plan_hash"])
                if plan is None or plan["session_id"] != self.session.id:
                    store.set_job(job_id, "needs_review", "plan_not_available")
                    self._cancel_queued("recovery_review_required")
                    continue
                self.active_job = job_id
                store.set_job(job_id, "running")
                try:

                    def on_stage(name: str, job: str = job_id, db: Store = store) -> None:
                        db.set_stage(job, name)
                        self.logs.append(Event.STAGE, stage=name)

                    result = await self.backend.execute(plan, on_stage)
                except DeviceOperationFailure as failure:
                    store.set_job(job_id, "needs_review", failure.code, failure.diagnostic)
                    self.logs.append(Event.REVIEW)
                    self._cancel_queued("recovery_review_required")
                except DeviceDisconnected:
                    store.set_job(job_id, "needs_review", "device_disconnected_no_retry")
                    self.logs.append(Event.REVIEW)
                    self._cancel_queued("recovery_review_required")
                except Exception:
                    # Never persist the exception string (may contain credentials).
                    store.set_job(job_id, "needs_review", "backend_error_no_retry")
                    self.logs.append(Event.REVIEW)
                    self._cancel_queued("recovery_review_required")
                else:
                    store.set_job(job_id, "succeeded", result)
                    self.logs.append(Event.PASSED)
                finally:
                    if not self.backend.active:
                        self.active_job = None
                    self._expire()
            finally:
                self.queue.task_done()
