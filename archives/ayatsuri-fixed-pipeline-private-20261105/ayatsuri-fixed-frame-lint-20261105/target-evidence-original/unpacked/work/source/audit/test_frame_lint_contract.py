#!/usr/bin/env python3
"""Reproduce pinned upstream behavior using only synthetic disassembly and mocks.

PASS means the observed contract/limitation reproduced, NOT that the scanner is
sound. No assembler, object file, firmware, renderer, hardware, or real objdump
is invoked. Upstream files are only read. Run with PYTHONDONTWRITEBYTECODE=1.
"""
import contextlib
import hashlib
import importlib.util
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("pinned_frame_lint", ROOT / "upstream/tools/frame_lint.py")
FL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(FL)


def assembly(body, name="fixture", frame=1200):
    lines = [f"00000000 <{name}>:"]
    instructions = ([f"entry a1, {frame}"] if frame is not None else []) + body
    lines += [f" {3 * i:x}: {insn}" for i, insn in enumerate(instructions)]
    return "\n".join(lines)


def row(body, **kwargs):
    return list(FL.scan(assembly(body, **kwargs).splitlines(), "synthetic.o"))[0]


def cli(args, texts=None, *, returncode=0, stderr="", paths=None, objdump="synthetic-objdump"):
    """Invoke main in-process; every external disassembly call is intercepted."""
    out, err = io.StringIO(), io.StringIO()
    texts = texts or {}
    paths = list(texts) if paths is None else paths
    def synthetic_run(argv, **kwargs):
        assert argv[:3] == [objdump, "-d", "--no-show-raw-insn"], argv
        return subprocess.CompletedProcess(argv, returncode, texts.get(argv[-1], ""), stderr)
    with mock.patch.object(sys, "argv", ["frame_lint.py", "synthetic-input", *args]), \
         mock.patch.object(FL, "find_objdump", return_value=objdump), \
         mock.patch.object(FL, "inputs", return_value=iter(paths)), \
         mock.patch.object(FL.subprocess, "run", side_effect=synthetic_run) as run, \
         contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
        rc = FL.main()
    return rc, out.getvalue(), err.getvalue(), run.call_count


class ScannerContract(unittest.TestCase):
    def test_supported_two_accesses_share_setup(self):
        r = row(["movi a9, 1024", "add a9, a1, a9", "l32i a2, a9, 0", "s32i a2, a9, 4"])
        self.assertEqual((r.accesses, r.computes, r.extra, r.worst), (2, 1, 2, 1028))

    def test_effective_address_can_be_near_but_counted_far(self):
        r = row(["addmi a9, a1, 1024", "addi a9, a9, -128", "l32i a2, a9, 0"])
        self.assertEqual((r.accesses, r.worst), (1, 896))  # Actual offset is 896 <= 1020.

    def test_call0_does_not_invalidate_register(self):
        # A call0 callee is allowed to overwrite a2; scanner does not inspect it.
        r = row(["addmi a2, a1, 1024", "call0 30 <callee>", "l32i a3, a2, 0"])
        self.assertEqual(r.accesses, 1)

    def test_call8_return_register_is_still_considered_far(self):
        # In windowed ABI, caller a10 receives callee a2 return value.
        r = row(["addmi a10, a1, 1024", "call8 30 <callee>", "l32i a3, a10, 0"])
        self.assertEqual(r.accesses, 1)

    def test_callx8_does_not_invalidate_register(self):
        r = row(["addmi a10, a1, 1024", "callx8 a8", "l32i a3, a10, 0"])
        self.assertEqual(r.accesses, 1)

    def test_full_call0_counterexample_with_callee_overwrite(self):
        text = assembly(["addmi a2, a1, 1024", "call0 30 <callee>", "l32i a3, a2, 0"], frame=None)
        text += "\n00000030 <callee>:\n 30: movi a2, 0\n 33: ret.n\n"
        rows = list(FL.scan(text.splitlines(), "synthetic.o"))
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0].accesses, 1)  # On return the base is zero, not a1+1024.

    def test_regular_explicit_clobber_is_handled(self):
        r = row(["addmi a9, a1, 1024", "movi a9, 0", "l32i a2, a9, 0"])
        self.assertEqual(r.accesses, 0)

    def test_stack_pointer_change_leaves_stale_relative_offset(self):
        r = row(["addmi a9, a1, 1024", "addi a1, a1, 32", "l32i a2, a9, 0"])
        self.assertEqual((r.accesses, r.worst), (1, 1024))  # Actual current-a1 offset is 992.

    def test_symbolic_branch_target_forgets_valid_far_pointer(self):
        text = """00000000 <fixture>:
 0: entry a1, 1200
 3: addmi a9, a1, 1024
 6: beqz a2, c <fixture+0xc>
 9: nop
 c: l32i a3, a9, 0
"""
        self.assertEqual(list(FL.scan(text.splitlines(), "synthetic.o"))[0].accesses, 0)

    def test_bare_address_branch_target_is_not_recognized(self):
        # Branch can skip setup, but target regex requires a symbolic annotation.
        text = """00000000 <fixture>:
 0: entry a1, 1200
 3: beqz a2, 9
 6: addmi a9, a1, 1024
 9: l32i a3, a9, 0
"""
        self.assertEqual(list(FL.scan(text.splitlines(), "synthetic.o"))[0].accesses, 1)

    def test_near_base_plus_displacement_can_cross_limit_unseen(self):
        r = row(["addmi a9, a1, 768", "l32i a2, a9, 256"])
        self.assertEqual(r.accesses, 0)  # Effective offset 1024.

    def test_register_move_alias_is_not_tracked(self):
        r = row(["addmi a9, a1, 1024", "mov.n a10, a9", "l32i a2, a10, 0"])
        self.assertEqual(r.accesses, 0)

    def test_addmi_from_derived_base_is_not_tracked(self):
        r = row(["addmi a9, a1, 1024", "addmi a10, a9, 256", "l32i a2, a10, 0"])
        self.assertEqual(r.accesses, 0)

    def test_loaded_literal_constant_is_not_tracked(self):
        r = row(["l32r a9, 90 <literal_1024>", "add a9, a9, a1", "l32i a2, a9, 0"])
        self.assertEqual(r.accesses, 0)

    def test_halfword_reach_is_not_the_default_word_reach(self):
        r = row(["addmi a9, a1, 512", "l16ui a2, a9, 0"])
        self.assertEqual(r.accesses, 0)  # Halfword immediate maximum is 510, not 1020.

    def test_byte_reach_is_not_the_default_word_reach(self):
        r = row(["addmi a9, a1, 256", "l8ui a2, a9, 0"])
        self.assertEqual(r.accesses, 0)  # Byte immediate maximum is 255.

    def test_deepest_is_start_offset_not_highest_touched_byte(self):
        r = row(["addmi a9, a1, 1024", "l32i a2, a9, 0"])
        self.assertEqual(r.worst, 1024)  # Four-byte load occupies offsets 1024..1027.

    def test_dead_setup_counts_as_extra_with_no_accesses(self):
        r = row(["movi a9, 1024", "add a10, a1, a9", "movi a10, 0"])
        self.assertEqual((r.accesses, r.computes, r.extra), (0, 1, 2))

    def test_reused_movi_is_double_counted_as_extra(self):
        r = row(["movi a9, 1024", "add a10, a1, a9", "add a11, a1, a9", "l32i a2, a10, 0", "l32i a3, a11, 0"])
        self.assertEqual((r.accesses, r.computes, r.extra), (2, 2, 4))  # Only 3 actual setup instructions.

    def test_derived_addi_does_not_increase_extra(self):
        r = row(["addmi a9, a1, 1024", "addi a9, a9, 4", "l32i a2, a9, 0"])
        self.assertEqual((r.accesses, r.extra, r.worst), (1, 1, 1028))

    def test_frame_is_largest_entry_immediate_only(self):
        r = row(["addi a1, a1, -128"], frame=1200)
        self.assertEqual(r.frame, 1200)  # Does not add later stack movement.

    def test_far_site_can_be_emitted_with_no_entry_frame(self):
        r = row(["addmi a9, a1, 1024", "l32i a2, a9, 0"], frame=None)
        self.assertEqual((r.frame, r.accesses), (0, 1))


class CliContract(unittest.TestCase):
    def test_no_objdump_check_fails(self):
        self.assertEqual(cli(["--check"], objdump=None)[0], 1)

    def test_no_objdump_report_only_succeeds_skipped(self):
        rc, out, _, _ = cli([], objdump=None)
        self.assertEqual(rc, 0)
        self.assertIn("SKIPPED", out)

    def test_failed_disassembly_check_passes(self):
        rc, out, err, count = cli(["--check"], paths=["missing.o"], returncode=1, stderr="synthetic failure")
        self.assertEqual((rc, count), (0, 1))
        self.assertIn("functions=0 far_accesses=0", out)
        self.assertIn("synthetic failure", err)

    def test_successful_but_empty_disassembly_check_passes(self):
        self.assertEqual(cli(["--check"], paths=["empty.o"])[0], 0)

    def test_nonmatching_disassembly_check_passes(self):
        self.assertEqual(cli(["--check"], {"bad.o": "unexpected objdump format\n"})[0], 0)

    def test_empty_input_set_check_passes(self):
        rc, out, _, count = cli(["--check"], paths=[])
        self.assertEqual((rc, count), (0, 0))
        self.assertIn("functions=0", out)

    def test_filter_can_skip_every_input_and_pass(self):
        rc, _, _, count = cli(["--check", "--filter", "nomatch"], {"a.o": assembly(["addmi a9, a1, 1024", "l32i a2, a9, 0"])})
        self.assertEqual((rc, count), (0, 0))

    def test_missing_requested_function_is_not_checked(self):
        with tempfile.TemporaryDirectory(dir=ROOT / "audit") as temp:
            base = Path(temp) / "baseline.txt"
            base.write_text("required_function 99\n")
            self.assertEqual(cli(["--check", "--baseline", str(base)], paths=[])[0], 0)

    def test_duplicate_function_names_break_baseline_roundtrip(self):
        texts = {
            "a.o": assembly(["addmi a9, a1, 1024", "l32i a2, a9, 0", "l32i a3, a9, 4"], name="same"),
            "b.o": assembly(["addmi a9, a1, 1024", "l32i a2, a9, 0"], name="same"),
        }
        with tempfile.TemporaryDirectory(dir=ROOT / "audit") as temp:
            base = Path(temp) / "baseline.txt"
            self.assertEqual(cli(["--write-baseline", str(base)], texts)[0], 0)
            self.assertIn("same 2\nsame 1\n", base.read_text())
            self.assertEqual(FL.load_baseline(base), {"same": 1})
            rc, out, _, _ = cli(["--baseline", str(base), "--check"], texts)
            self.assertEqual(rc, 1)
            self.assertIn("same: 2 far accesses (baseline 1)", out)

    def test_new_same_named_function_inherits_unrelated_allowance(self):
        with tempfile.TemporaryDirectory(dir=ROOT / "audit") as temp:
            base = Path(temp) / "baseline.txt"
            base.write_text("same 2\n")
            texts = {"new_translation_unit.o": assembly(["addmi a9, a1, 1024", "l32i a2, a9, 0"], name="same")}
            rc, out, _, _ = cli(["--baseline", str(base), "--check"], texts)
            self.assertEqual(rc, 0)
            self.assertNotIn("NEW", out)

    def test_frame_growth_alone_does_not_fail_check(self):
        rc, out, _, _ = cli(["--check"], {"big.o": assembly([], frame=3904)})
        self.assertEqual(rc, 0)
        self.assertIn("3904", out)

    def test_partial_disassembly_failure_can_still_pass(self):
        with mock.patch.object(FL, "disassemble", side_effect=[assembly([], frame=1200).splitlines(), []]):
            self.assertEqual(cli(["--check"], paths=["good.o", "failed.o"])[0], 0)

    def test_process_launch_error_is_not_silently_successful(self):
        with mock.patch.object(FL.subprocess, "run", side_effect=FileNotFoundError("synthetic launch failure")):
            with self.assertRaises(FileNotFoundError):
                FL.disassemble("missing-executable", "synthetic.o")


class SourceIntegrity(unittest.TestCase):
    def test_manifest_sources_remain_byte_exact(self):
        manifest = json.loads((ROOT / "SOURCE_MANIFEST.json").read_text())
        for relative, record in manifest["files"].items():
            data = (ROOT / "upstream" / relative).read_bytes()
            self.assertEqual(len(data), record["bytes"], relative)
            self.assertEqual(hashlib.sha256(data).hexdigest(), record["sha256"], relative)


if __name__ == "__main__":
    unittest.main(verbosity=2)
