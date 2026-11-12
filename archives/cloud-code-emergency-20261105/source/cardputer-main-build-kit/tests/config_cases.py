"""Shared offline fixture definitions. Python reference checks are not PS execution."""
from pathlib import Path

KIT = Path(__file__).resolve().parents[1]
BASE = (KIT / "cardputer-adv.local.toml").read_text(encoding="utf-8")
VALID = {
    "provided": BASE,
    "utf8_bom": "\ufeff" + BASE,
    "crlf": BASE.replace("\n", "\r\n"),
    "literal_hash": BASE.replace("value = 'git'", "value = 'git' # outside comment")
        .replace("run_root = 'C:\\devs\\m5stack\\pocketjs-main-validation\\1b4524e'", "run_root = 'C:\\literal#folder\\$env:HOME\\$(touch)'"),
}
INVALID = {
    "duplicate_key": BASE + "\nprepare_dependencies = false\n",
    "duplicate_table": BASE + "\n[source]\n",
    "unknown_key": BASE + "\nunknown = false\n",
    "wrongcase_key": BASE.replace("remote_url =", "REMOTE_URL ="),
    "wrongcase_table": BASE.replace("[source]", "[Source]"),
    "missing_key": BASE.replace("fetch_source = false\n", ""),
    "double_quote": BASE.replace("value = 'git'", 'value = "git"'),
    "multiline_literal": BASE.replace("value = 'git'", "value = '''git'''"),
    "array": BASE.replace("value = 'git'", "value = ['git']"),
    "inline_table": BASE.replace("value = 'git'", "value = { x = 'git' }"),
    "numeric": BASE.replace("value = 'git'", "value = 123"),
    "boolean_case": BASE.replace("fetch_source = false", "fetch_source = False"),
    "quoted_boolean": BASE.replace("fetch_source = false", "fetch_source = 'false'"),
    "boolean_string": BASE.replace("value = 'git'", "value = true"),
    "unicode_whitespace": BASE.replace("schema =", "schema\u00a0="),
    "control_in_comment": BASE + "\n# comment\x01\n",
    "bare_cr": BASE + "\r",
    "empty_string": BASE.replace("value = 'git'", "value = ''"),
    "unknown_mode": BASE.replace("mode = 'command'", "mode = 'fallback'", 1),
    "unknown_environment": BASE.replace("tools_path_value = 'IDF_TOOLS_PATH'", "tools_path_value = 'USERPROFILE'"),
    "command_arguments": BASE.replace("value = 'git'", "value = 'git --version'"),
    "short_commit": BASE.replace("1b4524e3db8524365f58e8c7fb56531c31b55e22", "1b4524e"),
    "unknown_schema": BASE.replace("cardputer-build-v3", "cardputer-build-v4"),
}
