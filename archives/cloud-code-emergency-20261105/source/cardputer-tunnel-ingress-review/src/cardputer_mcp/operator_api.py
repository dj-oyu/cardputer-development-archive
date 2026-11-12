"""Local operator control plane for the resident broker; never MCP tools."""

import json
from collections.abc import Callable
from typing import Any, Protocol

from pydantic import BaseModel, ConfigDict, Field
from starlette.types import ASGIApp, Receive, Scope, Send

from .broker import Broker, BrokerError
from .models import Digest, Identifier, Origin

_MAX_BODY = 2048


class OperatorPrincipal(Protocol):
    @property
    def origin(self) -> Origin: ...

    @property
    def scopes(self) -> frozenset[str]: ...


class CancelWait(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True)
    request_id: Identifier


class ReorderWait(CancelWait):
    position: int = Field(ge=1, le=256)
    expected_revision: Digest


class ReleaseIdle(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True)
    lease_id: Identifier


def _unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise ValueError("duplicate_json_key")
        result[key] = value
    return result


class OperatorAPI:
    """Shares the MCP app's lifespan and broker, inside its loopback guard."""

    def __init__(
        self,
        app: ASGIApp,
        broker: Broker,
        authenticate: Callable[[str | None], OperatorPrincipal | None],
        *,
        diagnostics: Callable[[], dict[str, Any]] | None = None,
    ) -> None:
        self.app = app
        self.broker = broker
        self.authenticate = authenticate
        self.diagnostics = diagnostics

    @staticmethod
    async def _respond(send: Send, status: int, payload: dict[str, Any]) -> None:
        body = json.dumps(payload, separators=(",", ":")).encode("utf-8")
        await send(
            {
                "type": "http.response.start",
                "status": status,
                "headers": [
                    (b"content-type", b"application/json"),
                    (b"cache-control", b"no-store"),
                    (b"content-length", str(len(body)).encode("ascii")),
                ],
            }
        )
        await send({"type": "http.response.body", "body": body})

    async def __call__(self, scope: Scope, receive: Receive, send: Send) -> None:
        path = scope.get("path", "")
        if scope["type"] != "http" or not (path == "/operator" or path.startswith("/operator/")):
            await self.app(scope, receive, send)
            return
        headers = {key.lower(): value for key, value in scope["headers"]}
        try:
            raw_header = headers.get(b"authorization")
            header = raw_header.decode("ascii") if raw_header is not None else None
        except UnicodeError:
            header = None
        principal = self.authenticate(header)
        if principal is None:
            await self._respond(send, 401, {"ok": False, "error": "authentication_required"})
            return
        if principal.origin != Origin.LOCAL or "control" not in principal.scopes:
            await self._respond(send, 403, {"ok": False, "error": "local_operator_required"})
            return
        if scope.get("query_string"):
            await self._respond(send, 400, {"ok": False, "error": "invalid_request"})
            return
        routes = {
            "/operator/state": "GET",
            "/operator/cancel": "POST",
            "/operator/reorder": "POST",
            "/operator/release": "POST",
        }
        if self.diagnostics is not None:
            routes["/operator/http-diagnostics"] = "GET"
        if path not in routes:
            await self._respond(send, 404, {"ok": False, "error": "not_found"})
            return
        if scope["method"] != routes[path]:
            await self._respond(send, 405, {"ok": False, "error": "method_not_allowed"})
            return
        payload: Any = None
        if scope["method"] == "POST":
            if headers.get(b"content-type", b"").split(b";", 1)[0] != b"application/json":
                await self._respond(send, 400, {"ok": False, "error": "invalid_request"})
                return
            body = bytearray()
            while True:
                message = await receive()
                if message["type"] == "http.disconnect":
                    return
                chunk = message.get("body", b"")
                if len(body) + len(chunk) > _MAX_BODY:
                    await self._respond(send, 413, {"ok": False, "error": "request_too_large"})
                    return
                body.extend(chunk)
                if not message.get("more_body", False):
                    break
            try:
                payload = json.loads(body, object_pairs_hook=_unique_object)
            except (ValueError, UnicodeError, RecursionError):
                await self._respond(send, 400, {"ok": False, "error": "invalid_request"})
                return
        try:
            if path == "/operator/http-diagnostics" and self.diagnostics is not None:
                result = self.diagnostics()
            elif path == "/operator/state":
                result = self.broker.operator_snapshot()
            elif path == "/operator/cancel":
                cancel = CancelWait.model_validate(payload)
                result = self.broker.operator_cancel_wait(cancel.request_id)
            elif path == "/operator/reorder":
                reorder = ReorderWait.model_validate(payload)
                result = self.broker.operator_reorder_wait(
                    reorder.request_id,
                    reorder.position,
                    expected_revision=reorder.expected_revision,
                )
            else:
                release = ReleaseIdle.model_validate(payload)
                result = self.broker.operator_release_idle(release.lease_id)
        except BrokerError as error:
            await self._respond(send, 200, {"ok": False, "error": str(error)})
        except ValueError:
            await self._respond(send, 400, {"ok": False, "error": "invalid_request"})
        else:
            await self._respond(send, 200, {"ok": True, **result})
