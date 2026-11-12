"""Process-local denial counters; never retain HTTP input or response content."""

from enum import StrEnum
from threading import Lock
from typing import Any, Literal


class DenialReason(StrEnum):
    NON_ASCII_HEADERS = "non_ascii_headers"
    DUPLICATE_HEADERS = "duplicate_headers"
    NON_LOOPBACK_PEER = "non_loopback_peer"
    HOST_NOT_ALLOWED = "host_not_allowed"
    ORIGIN_NOT_ALLOWED = "origin_not_allowed"
    FORWARDING_HEADER_PRESENT = "forwarding_header_present"
    CONTENT_TYPE_NOT_JSON = "content_type_not_json"
    AUTHENTICATION_REQUIRED = "authentication_required"
    TUNNEL_ROUTE_REJECTED = "tunnel_route_rejected"
    TUNNEL_PRINCIPAL_REJECTED = "tunnel_principal_rejected"
    MCP_HTTP_REJECTION = "mcp_http_rejection"
    OPERATOR_HTTP_REJECTION = "operator_http_rejection"
    OTHER_HTTP_REJECTION = "other_http_rejection"


Route = Literal["mcp", "operator", "other"]
_MAX_COUNT = 2**63 - 1


def route_category(path: str) -> Route:
    if path in ("/mcp", "/mcp/"):
        return "mcp"
    if path == "/operator" or path.startswith("/operator/"):
        return "operator"
    return "other"


class HTTPDiagnostics:
    """A fixed-size snapshot, accessible only through the local operator API.

    Counts are cumulative for this broker process. The last denial is not an
    audit trail and has no request identity. Never inspect bodies, query strings,
    header values, peer addresses, principal IDs, or exception text here.
    """

    def __init__(self) -> None:
        self._lock = Lock()
        self._counts = {reason.value: 0 for reason in DenialReason}
        self._total = 0
        self._last: dict[str, Any] | None = None

    def record(self, reason: DenialReason, route: Route, status: int) -> None:
        # Defend the output contract even if a future caller ignores annotations.
        if not isinstance(reason, DenialReason) or route not in ("mcp", "operator", "other"):
            return
        if type(status) is not int or not 400 <= status <= 599:
            return
        layer = "guard"
        if reason in (DenialReason.AUTHENTICATION_REQUIRED, DenialReason.TUNNEL_PRINCIPAL_REJECTED):
            layer = "authentication"
        elif reason in (
            DenialReason.MCP_HTTP_REJECTION,
            DenialReason.OPERATOR_HTTP_REJECTION,
            DenialReason.OTHER_HTTP_REJECTION,
        ):
            layer = route
        with self._lock:
            self._counts[reason.value] = min(_MAX_COUNT, self._counts[reason.value] + 1)
            self._total = min(_MAX_COUNT, self._total + 1)
            self._last = {
                "reason": reason.value,
                "layer": layer,
                "route": route,
                "http_status": status,
            }

    def snapshot(self) -> dict[str, Any]:
        with self._lock:
            return {
                "schema_version": 1,
                "since": "broker_start",
                "total_denials": self._total,
                "counts": dict(self._counts),
                "last_denial": dict(self._last) if self._last is not None else None,
            }
