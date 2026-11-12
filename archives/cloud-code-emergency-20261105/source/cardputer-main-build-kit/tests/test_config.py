"""TOML compatibility/reference tests + static PS contracts, not PS runtime tests."""
import re
import sys
import unittest
from pathlib import Path
import tomllib

sys.path.insert(0, str(Path(__file__).resolve().parent))
from config_cases import BASE, VALID, INVALID, KIT

SCHEMA = {"schema": str, "source.repo": str, "source.commit": str, "source.remote_url": str,
          "output.run_root": str, "idf.path": str, "idf.python_path": str,
          "idf.tools_path_mode": str, "idf.tools_path_value": str,
          **{f"tools.{tool}.{field}": str for tool in ("git", "node", "cmake", "ninja", "compiler") for field in ("mode", "value")},
          "actions.fetch_source": bool, "actions.prepare_dependencies": bool}
TABLES = {"source", "output", "idf", "actions", *[f"tools.{tool}" for tool in ("git", "node", "cmake", "ninja", "compiler")]}


def reference_parse(text):
    """Executable specification of the documented subset; not the PS parser."""
    if len(text.encode("utf-8")) > 65536:
        raise ValueError("size")
    if text.startswith("\ufeff"):
        text = text[1:]
    if re.search(r"[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]|\r(?!\n)", text):
        raise ValueError("control")
    table = ""
    tables, values = set(), {}
    for line in re.split(r"\r?\n", text):
        if re.fullmatch(r"[ \t]*(?:#.*)?", line):
            continue
        match = re.fullmatch(r"[ \t]*\[([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*)\][ \t]*(?:#.*)?", line)
        if match:
            table = match[1]
            if table not in TABLES or table in tables:
                raise ValueError("table")
            tables.add(table)
            continue
        match = re.fullmatch(r"[ \t]*([A-Za-z_][A-Za-z0-9_]*)[ \t]*=[ \t]*(.*?)[ \t]*", line)
        if not match:
            raise ValueError("syntax")
        key = f"{table}.{match[1]}" if table else match[1]
        if key not in SCHEMA or key in values:
            raise ValueError("key")
        string = re.fullmatch(r"'([^'\x00-\x08\x0a-\x1f\x7f]*)'[ \t]*(?:#.*)?", match[2])
        boolean = re.fullmatch(r"(true|false)[ \t]*(?:#.*)?", match[2])
        if string:
            value = string[1]
            if SCHEMA[key] is not str or not value.strip():
                raise ValueError("string")
        elif boolean:
            if SCHEMA[key] is not bool:
                raise ValueError("bool")
            value = boolean[1] == "true"
        else:
            raise ValueError("value")
        values[key] = value
    if values.keys() != SCHEMA.keys() or values["schema"] != "cardputer-build-v3":
        raise ValueError("schema")
    if not re.fullmatch(r"[0-9a-fA-F]{40}", values["source.commit"]):
        raise ValueError("commit")
    if values["idf.tools_path_mode"] not in ("path", "environment"):
        raise ValueError("environment mode")
    if values["idf.tools_path_mode"] == "environment" and values["idf.tools_path_value"] != "IDF_TOOLS_PATH":
        raise ValueError("environment selector")
    for tool in ("git", "node", "cmake", "ninja", "compiler"):
        mode = values[f"tools.{tool}.mode"]
        if mode not in ("path", "command"):
            raise ValueError("tool mode")
        if mode == "command" and not re.fullmatch(r"[A-Za-z0-9_.+-]+", values[f"tools.{tool}.value"]):
            raise ValueError("command selector")
    return values


class ConfigTests(unittest.TestCase):
    def test_shipped_config_is_standard_toml_with_observed_paths(self):
        config = tomllib.loads(BASE)
        self.assertEqual(config["source"]["repo"], r"C:\devs\m5stack\cardputer-adv-pocketjs")
        self.assertEqual(config["idf"]["path"], r"C:\esp\v6.0.1\esp-idf")
        self.assertEqual(config["idf"]["python_path"], r"C:\Espressif\tools\python\v6.0.1\venv\Scripts\python.exe")
        self.assertEqual(config["idf"]["tools_path_value"], "IDF_TOOLS_PATH")
        self.assertFalse(config["actions"]["fetch_source"])
        self.assertTrue(config["actions"]["prepare_dependencies"])
        for tool in ("git", "cmake", "ninja"):
            self.assertEqual(config["tools"][tool], {"mode": "command", "value": tool})
        self.assertEqual(config["tools"]["node"], {"mode": "path", "value": r"C:\Program Files\nodejs\node.exe"})

    def test_reference_valid_cases(self):
        for name, text in VALID.items():
            with self.subTest(case=name):
                parsed = reference_parse(text)
                if name == "literal_hash":
                    self.assertEqual(parsed["output.run_root"], r"C:\literal#folder\$env:HOME\$(touch)")
                # These are valid TOML, apart from the permitted optional UTF-8 BOM.
                tomllib.loads(text.removeprefix("\ufeff"))

    def test_reference_reject_cases(self):
        for name, text in INVALID.items():
            with self.subTest(case=name):
                with self.assertRaises(ValueError):
                    reference_parse(text)

    def test_reference_size_limit(self):
        with self.assertRaises(ValueError):
            reference_parse(BASE + "#" + "a" * 65536)

    def test_ps_schema_exactly_matches_reference(self):
        script = (KIT / "Read-BuildConfig.ps1").read_text()
        keys = dict(re.findall(r"'([^']+)'='(string|bool)'", script))
        self.assertEqual(keys, {key: "string" if value is str else "bool" for key, value in SCHEMA.items()})
        self.assertIn("[StringComparer]::Ordinal", script)
        self.assertIn("[Text.UTF8Encoding]::new($false, $true)", script)
        self.assertNotIn(r"\s", script)
        self.assertNotIn("Invoke-Expression", script)
        self.assertNotIn("ExpandString", script)
        self.assertIn("Duplicate table", script)
        self.assertIn("-cmatch", script)
        self.assertIn("-ccontains", script)

    def test_entrypoint_parses_before_tool_execution_and_has_only_two_parameters(self):
        script = (KIT / "Build-Main.ps1").read_text()
        parameters = script[script.index("param("):script.index(")\nSet-StrictMode")]
        self.assertEqual(re.findall(r"\$(\w+)", parameters), ["Config", "Execute"])
        self.assertLess(script.index("Read-BuildConfiguration -Path $Config"), script.index("Resolve-ConfiguredTool $Configuration"))
        self.assertLess(script.index("Read-BuildConfiguration -Path $Config"), script.index("Git-Text @"))
        self.assertIn("Configuration changed during preflight", script)
        self.assertNotIn("Microsoft.v6.0.1", script)
        self.assertNotIn("C:\\devs", script)
        self.assertNotIn("C:\\Espressif", script)


if __name__ == "__main__":
    unittest.main()
