"""Local OS-user approval boundary. Deliberately not exposed as an MCP tool."""

import json
from collections.abc import Callable
from pathlib import Path
from typing import Any

from filelock import FileLock, Timeout
from pydantic import TypeAdapter

from .broker import digest_plan
from .models import Digest, Identifier
from .store import Store


def approve_plan(
    state_dir: Path, digest: str, confirm: Callable[[str], str] = input
) -> dict[str, Any]:
    TypeAdapter(Digest).validate_python(digest)
    database = state_dir / "history.sqlite3"
    if not database.is_file():
        raise ValueError("broker_state_not_found")
    store = Store(database)
    try:
        plan = store.plan(digest)
        if plan is None or digest_plan(plan) != digest:
            raise ValueError("plan_not_found_or_changed")
        if plan.get("backend") not in ("mock", "serial"):
            raise ValueError("unsupported_backend")
        if plan.get("backend") == "serial":
            if plan.get("test") not in ("passive_observe", "hello"):
                raise ValueError("unsupported_serial_action")
            if plan.get("test") == "hello":
                attestation = confirm(
                    "HELLO exits the current app and sends q/a/u/e navigation keys. "
                    "Device opening/closing may reset it due to driver control-line glitches. "
                    "Verify the configured firmware is running and other serial tools are closed. "
                    "Type DEVICE FREE AND FIRMWARE VERIFIED to attest: "
                )
                if attestation.strip() != "DEVICE FREE AND FIRMWARE VERIFIED":
                    raise ValueError("device_attestation_required")
        summary = json.dumps(plan, indent=2, sort_keys=True)
        answer = confirm(f"{summary}\nPlan SHA-256: {digest}\nType APPROVE {digest} to approve: ")
        if answer.strip() != f"APPROVE {digest}":
            raise ValueError("approval_not_granted")
        store.approve(digest)
        return {"approved": True, "plan_hash": digest}
    finally:
        store.close()


def acknowledge_recovery(
    state_dir: Path, job_id: str, confirm: Callable[[str], str] = input
) -> dict[str, Any]:
    TypeAdapter(Identifier).validate_python(job_id)
    if not (state_dir / "history.sqlite3").is_file():
        raise ValueError("broker_state_not_found")
    lock = FileLock(str(state_dir / "broker.lockfile"), timeout=0)
    try:
        lock.acquire()
    except Timeout as exc:
        raise ValueError("stop_broker_before_recovery_review") from exc
    try:
        store = Store(state_dir / "history.sqlite3")
        try:
            job = store.job(job_id)
            if not job or job["state"] != "needs_review":
                raise ValueError("job_does_not_need_review")
            answer = confirm(
                f"{json.dumps(job, indent=2)}\nInspect the result first. "
                f"This will NOT retry anything. Type REVIEW {job_id}: "
            )
            if answer.strip() != f"REVIEW {job_id}":
                raise ValueError("review_not_acknowledged")
            store.db.execute("UPDATE jobs SET reviewed=1 WHERE id=?", (job_id,))
            store.db.commit()
            return {"reviewed": True, "job_id": job_id, "replayed": False}
        finally:
            store.close()
    finally:
        lock.release()


def acknowledge_device_request_recovery(
    state_dir: Path, request_id: str, confirm: Callable[[str], str] = input
) -> dict[str, Any]:
    """Offline explicit review of restart-invalidated physical ownership/waiting."""
    TypeAdapter(Identifier).validate_python(request_id)
    if not (state_dir / "history.sqlite3").is_file():
        raise ValueError("broker_state_not_found")
    lock = FileLock(str(state_dir / "broker.lockfile"), timeout=0)
    try:
        lock.acquire()
    except Timeout as exc:
        raise ValueError("stop_broker_before_recovery_review") from exc
    try:
        store = Store(state_dir / "history.sqlite3")
        try:
            request = store.request(request_id)
            if not request or request["state"] != "needs_review" or request["reviewed"]:
                raise ValueError("device_request_does_not_need_review")
            answer = confirm(
                f"{json.dumps(request, indent=2)}\nInspect the device and prior job first. "
                "This invalidated session cannot resume and nothing will be replayed. "
                f"Type REVIEW REQUEST {request_id}: "
            )
            if answer.strip() != f"REVIEW REQUEST {request_id}":
                raise ValueError("review_not_acknowledged")
            store.review_request(request_id)
            return {"reviewed": True, "request_id": request_id, "replayed": False}
        finally:
            store.close()
    finally:
        lock.release()
