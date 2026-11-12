"""Offline synthetic artifacts only. These tests never build or contact a device."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import shutil
import tempfile
import unittest

KIT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("evidence", KIT / "collect_evidence.py")
evidence = importlib.util.module_from_spec(spec)
spec.loader.exec_module(evidence)


class EvidenceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.wt = self.root / "wt-main"
        self.build = self.wt / "build_main"
        (self.wt / "main").mkdir(parents=True)
        self.git = Path(shutil.which("git"))
        subprocess.run([str(self.git), "init", str(self.wt)], check=True, capture_output=True)
        subprocess.run([str(self.git), "-C", str(self.wt), "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "commit", "--allow-empty", "-m", "offline fixture"], check=True, capture_output=True)
        self.commit = subprocess.run([str(self.git), "-C", str(self.wt), "rev-parse", "HEAD"], check=True, capture_output=True, text=True).stdout.strip()
        (self.build / "partition_table").mkdir(parents=True)
        (self.build / "bootloader").mkdir()
        self.csv = "# Name, Type, SubType, Offset, Size, Flags\nnvs,data,nvs,0x9000,0x6000,\nphy_init,data,phy,0xf000,0x1000,\nfactory,app,factory,0x10000,0x300000,\nskk_dict,data,0x40,0x310000,0x200000,\njp_font,data,0x41,0x510000,0x80000,\nstorage,data,0x42,0x590000,0x270000,\n"
        (self.wt / "partitions.csv").write_text(self.csv)
        self.generated = self.root / "generated.csv"
        self.generated.write_text(self.csv.replace("0x300000", "3M"))
        (self.wt / "sdkconfig.defaults").write_text('CONFIG_IDF_TARGET="esp32s3"\n')
        (self.wt / "dependencies.lock").write_text("version: 3.0.0\n")
        (self.wt / "main/Kconfig.projbuild").write_text('config POCKET_VM_OOMPROBE\n    bool "Diagnostic"\n    default n\n')
        (self.wt / "main/CMakeLists.txt").write_text('option(POCKET_PROBES "diagnostic" OFF)\n')
        self.config = 'CONFIG_IDF_TARGET="esp32s3"\nCONFIG_ESPTOOLPY_FLASHSIZE_8MB=y\nCONFIG_PARTITION_TABLE_CUSTOM=y\nCONFIG_PARTITION_TABLE_CUSTOM_FILENAME="partitions.csv"\nCONFIG_PARTITION_TABLE_OFFSET=0x8000\n# CONFIG_POCKET_VM_OOMPROBE is not set\n'
        (self.build / "sdkconfig").write_text(self.config)
        (self.build / "CMakeCache.txt").write_text("POCKET_PROBES:BOOL=OFF\n")
        self.project = {"target": "esp32s3", "git_revision": "v6.0.1", "project_name": "cardputer_pocketjs",
                        "project_path": str(self.wt), "build_dir": str(self.build),
                        "config_file": str(self.build / "sdkconfig"),
                        "config_defaults": str(self.wt / "sdkconfig.defaults"),
                        "app_bin": "cardputer_pocketjs.bin"}
        self.flasher = {"extra_esptool_args": {"chip": "esp32s3"},
                        "app": {"offset": "0x10000", "file": "cardputer_pocketjs.bin"},
                        "flash_files": {"0x0": "bootloader/bootloader.bin", "0x8000": "partition_table/partition-table.bin", "0x10000": "cardputer_pocketjs.bin"}}
        self.write_json("project_description.json", self.project)
        self.write_json("flasher_args.json", self.flasher)
        for name in ("cardputer_pocketjs.bin", "cardputer_pocketjs.elf", "cardputer_pocketjs.map", "compile_commands.json", "bootloader/bootloader.bin", "partition_table/partition-table.bin"):
            (self.build / name).write_bytes(b"synthetic fixture only\n")

    def write_json(self, name, value):
        (self.build / name).write_text(json.dumps(value))

    def collect(self):
        return evidence.collect(self.wt, self.build, self.commit, self.generated)

    def test_valid_and_hash(self):
        result = self.collect()
        self.assertEqual(result["app"]["offset"], 0x10000)
        self.assertEqual(result["app"]["bytes"], 23)
        self.assertEqual(result["idfRevision"], "v6.0.1")
        self.assertEqual(len(result["app"]["sha256"]), 64)
        self.assertEqual(len(result["partitions"]), 6)

    def test_bad_project_fields(self):
        for key, value in (("target", "esp32"), ("git_revision", "v6.0.2"),
                           ("config_file", str(self.wt / "sdkconfig")),
                           ("config_defaults", str(self.wt / "other.defaults")),
                           ("config_defaults", [str(self.wt / "sdkconfig.defaults"), "extra"]),
                           ("app_bin", "different.bin")):
            with self.subTest(key=key):
                changed = {**self.project, key: value}
                self.write_json("project_description.json", changed)
                with self.assertRaises(ValueError):
                    self.collect()
        self.write_json("project_description.json", self.project)

    def test_diagnostic_config_rejected(self):
        (self.build / "sdkconfig").write_text(self.config + "CONFIG_POCKET_VM_OOMPROBE=y\n")
        with self.assertRaises(ValueError):
            self.collect()

    def test_changed_cmake_default_rejected(self):
        (self.build / "CMakeCache.txt").write_text("POCKET_PROBES:BOOL=ON\n")
        with self.assertRaises(ValueError):
            self.collect()

    def test_root_sdkconfig_rejected(self):
        (self.wt / "sdkconfig").write_text("unexpected")
        with self.assertRaises(ValueError):
            self.collect()

    def test_wrong_app_offset(self):
        self.flasher["app"]["offset"] = "0x20000"
        self.write_json("flasher_args.json", self.flasher)
        with self.assertRaises(ValueError):
            self.collect()

    def test_wrong_flash_map_offset(self):
        self.flasher["flash_files"]["0x20000"] = self.flasher["flash_files"].pop("0x10000")
        self.write_json("flasher_args.json", self.flasher)
        with self.assertRaises(ValueError):
            self.collect()

    def test_partition_change(self):
        self.generated.write_text(self.csv.replace("0x300000", "0x200000"))
        with self.assertRaises(ValueError):
            self.collect()

    def test_path_escape(self):
        self.flasher["app"]["file"] = "../outside.bin"
        self.write_json("flasher_args.json", self.flasher)
        with self.assertRaises(ValueError):
            self.collect()

    def test_oversized_app(self):
        (self.build / "cardputer_pocketjs.bin").write_bytes(b"x" * (0x300000 + 1))
        with self.assertRaises(ValueError):
            self.collect()

    def test_missing_artifact(self):
        (self.build / "cardputer_pocketjs.elf").unlink()
        with self.assertRaises(ValueError):
            self.collect()

    def test_cli_success_then_refuses_overwrite(self):
        output = self.root / "evidence.json"
        command = [sys.executable, str(KIT / "collect_evidence.py"), "--commit", self.commit, "--git-path", str(self.git), "--worktree", str(self.wt), "--build", str(self.build), "--stage", "final", "--partitions", str(self.generated), "--output", str(output)]
        first = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(first.returncode, 0, first.stderr)
        self.assertTrue((self.root / "project_description.json").exists())
        original = output.read_bytes()
        second = subprocess.run(command, capture_output=True, text=True)
        self.assertNotEqual(second.returncode, 0)
        self.assertEqual(original, output.read_bytes())

    def test_late_copy_collision_preserves_everything(self):
        output = self.root / "evidence.json"
        sentinel = self.root / "source-dependencies.lock"
        sentinel.write_bytes(b"DO NOT CHANGE")
        before = {p.name: p.read_bytes() for p in self.root.iterdir() if p.is_file()}
        command = [sys.executable, str(KIT / "collect_evidence.py"), "--commit", self.commit,
                   "--git-path", str(self.git), "--worktree", str(self.wt), "--build", str(self.build),
                   "--stage", "final", "--partitions", str(self.generated), "--output", str(output)]
        result = subprocess.run(command, capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(before, {p.name: p.read_bytes() for p in self.root.iterdir() if p.is_file()})

    def test_dangling_destinations_make_no_writes(self):
        for destination_name in ("evidence.json", "source-dependencies.lock"):
            with self.subTest(destination=destination_name):
                destination = self.root / destination_name
                destination.symlink_to(self.root / "does-not-exist")
                before = sorted(p.name for p in self.root.iterdir())
                output = self.root / "evidence.json"
                command = [sys.executable, str(KIT / "collect_evidence.py"), "--commit", self.commit,
                           "--git-path", str(self.git), "--worktree", str(self.wt), "--build", str(self.build),
                           "--stage", "final", "--partitions", str(self.generated), "--output", str(output)]
                result = subprocess.run(command, capture_output=True, text=True)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(before, sorted(p.name for p in self.root.iterdir()))
                self.assertTrue(destination.is_symlink())
                destination.unlink()

    def test_wrong_source_commit(self):
        output = self.root / "evidence.json"
        result = subprocess.run([sys.executable, str(KIT / "collect_evidence.py"), "--commit", "a" * 40,
                   "--git-path", str(self.git), "--worktree", str(self.wt), "--build", str(self.build),
                   "--stage", "configure", "--output", str(output)], capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(output.exists())

    def test_configure_only(self):
        result = evidence.collect(self.wt, self.build, self.commit)
        self.assertNotIn("app", result)

    def test_static_entrypoint_contract(self):
        script = (KIT / "Build-Main.ps1").read_text()
        for required in ("--no-write-fetch-head", "--no-auto-maintenance", "'--detach'", "'reconfigure'", "'build'", "-DSDKCONFIG=$Build/sdkconfig", "-DSDKCONFIG_DEFAULTS=$Worktree/sdkconfig.defaults", "Scripts/python.exe", "if (!$Execute) { return }", "Tee-Object -FilePath $Log -ErrorAction Stop"):
            self.assertIn(required, script)
        for forbidden in ("'flash'", "'erase-flash'", "'monitor'", "'reset'", "'push'", "'merge'", "Remove-Item", "POCKET_VM_TYPED_PUT_INT_FAST", "POCKET_APP_PRECOMPILE_EXPERIMENT"):
            self.assertNotIn(forbidden, script)
        self.assertNotIn("$Profile", script)
        self.assertNotIn("Mandatory=$true", script)
        self.assertNotIn("ls-remote", script)
        self.assertNotIn("Assert-RemoteMain", script)
        self.assertNotIn("Microsoft.v6.0.1", script)
        before_execute = script[:script.index("if (!$Execute) { return }")]
        for action in ("New-Item -ItemType", "& $PythonPath -I -B -S $ReservationHelper --run-root", "'fetch','--no-tags'"):
            self.assertNotIn(action, before_execute)
        self.assertIn("$PSBoundParameters.ContainsKey('Config')", before_execute)
        self.assertIn("PythonPath must match the already active", before_execute)
        self.assertIn("IDF_PATH must already equal", before_execute)
        self.assertIn("RunRoot parent must already exist", before_execute)
        self.assertIn("if (!$CommitPresent -and $Fetch)", script)
        self.assertIn("$RemoteUrl,$Commit", script)
        self.assertIn("--no-lazy-fetch", before_execute)
        self.assertIn("GIT_(TRACE.*|EXTERNAL_DIFF", before_execute)
        self.assertIn("Explicit RemoteUrl does not exactly match", before_execute)
        self.assertIn("IDF_TOOLS_PATH must already equal", before_execute)
        self.assertIn("custom idf_component_manager.yml exists", before_execute)
        self.assertIn("GIT_TRACE2_EVENT='0'", before_execute)
        self.assertIn("$PriorReadOnlyGitEnvironment.Keys", script)
        self.assertIn("IDF_COMPONENT_CACHE_PATH=$ComponentCache", before_execute)


if __name__ == "__main__":
    unittest.main()
