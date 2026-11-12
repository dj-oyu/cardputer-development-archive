"""Windows selection/cache reference model + static PS wiring; NOT PS runtime."""
import ntpath
from pathlib import Path
import re
import unittest

KIT = Path(__file__).resolve().parents[1]
NODE = r"C:\Program Files\nodejs\node.exe"
VOLTA = r"C:\Program Files\Volta\node.exe"


def ordered_paths(paths):
    result, seen = [], set()
    for path in paths:
        normalized = ntpath.normpath(path)
        key = ntpath.normcase(normalized)
        if key not in seen:
            result.append(normalized)
            seen.add(key)
    return result


def select(mode, value, candidates):
    if mode == "path":
        return value
    candidates = ordered_paths(candidates)
    if not candidates:
        raise ValueError("missing configured command")
    return candidates[0]


def assert_first(selected, candidates):
    if not candidates or ntpath.normcase(ntpath.normpath(selected)) != ntpath.normcase(candidates[0]):
        raise ValueError("first active tool differs")


def assert_cache(text, expected):
    actual = {}
    for line in text.splitlines():
        match = re.fullmatch(r"([^#/:=]+):([^:=]+)=(.*)", line)
        if match and match[1] in expected:
            key, value = match[1], match[3]
            if key in actual or not re.match(r"^[A-Za-z]:[\\/]", value) or re.search(r"[;\r\n]", value):
                raise ValueError("duplicate or non-absolute cache path")
            if ntpath.normcase(ntpath.normpath(value)) != ntpath.normcase(ntpath.normpath(expected[key])):
                raise ValueError("configured path differs")
            actual[key] = ntpath.normpath(value)
    if actual.keys() != expected.keys():
        raise ValueError("missing cache tool")
    return actual


class ToolSelectionTests(unittest.TestCase):
    def test_explicit_node_bypasses_multiple_candidates(self):
        self.assertEqual(select("path", NODE, [VOLTA, NODE]), NODE)
        self.assertEqual(select("path", NODE, [VOLTA]), NODE)
        self.assertEqual(select("path", NODE, []), NODE)

    def test_command_selects_first_without_sorting_or_fallback(self):
        first = r"C:\z-active\node.exe"
        later = r"C:\a-other\node.exe"
        self.assertEqual(select("command", "node", [first, later]), first)
        self.assertEqual(select("command", "node", [later, first]), later)
        with self.assertRaises(ValueError):
            select("command", "node", [])

    def test_duplicate_paths_are_case_insensitive_and_order_preserving(self):
        self.assertEqual(ordered_paths([VOLTA, VOLTA.lower(), VOLTA.replace("\\", "/"), NODE, NODE]), [VOLTA, NODE])

    def test_bare_descendant_accepts_first_with_later_installations(self):
        for tool in ("git", "cmake", "ninja", "xtensa-esp32s3-elf-gcc"):
            with self.subTest(tool=tool):
                first = rf"C:\active\{tool}.exe"
                other = rf"C:\other\{tool}.exe"
                assert_first(first.lower(), ordered_paths([first, other]))

    def test_bare_descendant_rejects_later_explicit_selection_or_missing_path(self):
        for tool in ("git", "cmake", "ninja", "xtensa-esp32s3-elf-gcc"):
            with self.subTest(tool=tool):
                first = rf"C:\active\{tool}.exe"
                other = rf"C:\other\{tool}.exe"
                for candidates in ([first, other], []):
                    with self.assertRaises(ValueError):
                        assert_first(other, ordered_paths(candidates))

    def test_cache_requires_exact_selected_tools(self):
        expected = {"POCKET_NODE": NODE, "CMAKE_COMMAND": r"C:\idf\cmake.exe", "CMAKE_MAKE_PROGRAM": r"C:\idf\ninja.exe", "PYTHON": r"C:\idf\python.exe"}
        text = "\n".join(f"{key}:FILEPATH={value.replace(chr(92), '/')}" for key, value in expected.items())
        self.assertEqual(assert_cache(text, expected), expected)
        for key in expected:
            with self.subTest(key=key):
                changed = dict(expected, **{key: r"C:\other\tool.exe"})
                with self.assertRaises(ValueError):
                    assert_cache(text, changed)
        for changed in (text.replace("POCKET_NODE:", "OTHER:"), text + f"\nPOCKET_NODE:FILEPATH={NODE}", text.replace(NODE.replace("\\", "/"), "node.exe"), text.replace(NODE.replace("\\", "/"), NODE + ";other")):
            with self.assertRaises(ValueError):
                assert_cache(changed, expected)

    def test_cache_variable_names_are_case_sensitive(self):
        with self.assertRaises(ValueError):
            assert_cache(f"pocket_node:FILEPATH={NODE}", {"POCKET_NODE": NODE})
        self.assertEqual(assert_cache(f"POCKET_NODE:FILEPATH={NODE.lower()}", {"POCKET_NODE": NODE})["POCKET_NODE"], NODE.lower())

    def test_static_selection_wiring_and_no_path_changes(self):
        parser = (KIT / "Read-BuildConfig.ps1").read_text()
        build = (KIT / "Build-Main.ps1").read_text()
        self.assertNotIn("Sort-Object", parser)
        self.assertIn("[StringComparer]::OrdinalIgnoreCase", parser)
        self.assertIn("(@($Expected.Keys) -ccontains $Matches[1])", parser)
        self.assertIn("Dictionary[string,string]]::new([StringComparer]::Ordinal)", parser)
        self.assertIn("GetFullPath($Project.c_compiler)", build)
        expected_cache = build[build.index("$ExpectedCMakeTools ="):build.index("$Plan =")]
        self.assertNotIn("CMAKE_C_COMPILER", expected_cache)
        self.assertIn("if ($seen.Add($path))", parser)
        self.assertIn("return $resolved[0]", parser)
        self.assertNotIn("$resolved.Count -ne 1", parser)
        self.assertNotIn("$matches.Count -ne 1", build)
        self.assertIn("node=(Assert-Executable 'node' $NodePath)", build)
        for tool, variable in (("git", "GitPath"), ("cmake", "CMakePath"), ("ninja", "NinjaPath")):
            self.assertIn(f"{tool}=(Assert-Executable '{tool}' ${variable} -RequirePathMatch)", build)
        self.assertIn("$CompilerPath -RequirePathMatch)", build)
        self.assertIn('"-DPOCKET_NODE=$NodePath"', build)
        self.assertIn("& $entry[1] --version", build)
        self.assertIn("Explicit Node must be version 16 or newer", build)
        self.assertIn("orderedPathCandidates=$candidates", build)
        for key in ("POCKET_NODE", "CMAKE_COMMAND", "CMAKE_MAKE_PROGRAM", "PYTHON"):
            self.assertRegex(build, rf"\b{key}=\$\w+")
        self.assertLess(build.index("$Manifest.configuredTools = Assert-CMakeToolPaths"), build.index("$Manifest.status='building'"))
        self.assertIn("$Manifest.finalConfiguredTools = Assert-CMakeToolPaths", build)
        self.assertIsNone(re.search(r"\$env:PATH\s*=|SetEnvironmentVariable\('PATH'", parser + build, re.I))


if __name__ == "__main__":
    unittest.main()
