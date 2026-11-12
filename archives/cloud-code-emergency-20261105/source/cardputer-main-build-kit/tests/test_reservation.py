"""Real cross-platform exclusive mkdir/sentinel tests; no PowerShell claims."""
import importlib.util
from pathlib import Path
import tempfile
import os
import subprocess
import unittest

spec = importlib.util.spec_from_file_location("reservation", Path(__file__).resolve().parents[1] / "reserve_run.py")
reservation = importlib.util.module_from_spec(spec)
spec.loader.exec_module(reservation)


class ReservationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.parent = Path(self.temp.name)
        self.root = self.parent / "new-run"
        self.sha = "b" * 40

    def test_canonical_alias_nested_under_repo_is_rejected(self):
        repo = self.parent / "repo"
        repo.mkdir()
        alias = self.parent / "alias"
        alias.symlink_to(repo, target_is_directory=True)
        with self.assertRaises(ValueError):
            reservation.validate_paths(repo, alias / "new-run")
        self.assertEqual(list(repo.iterdir()), [])

    def test_path_plan_only_is_read_only(self):
        repo = self.parent / "repo"
        repo.mkdir()
        before = sorted(p.name for p in self.parent.iterdir())
        plan = reservation.validate_paths(repo, self.root)
        self.assertEqual(plan["canonicalRunRoot"], str(self.root))
        self.assertEqual(before, sorted(p.name for p in self.parent.iterdir()))

    def test_git_trace_config_cannot_create_or_append(self):
        config = self.parent / "global.gitconfig"
        trace = self.parent / "trace.json"
        config.write_text("[trace2]\n eventTarget = " + str(trace) + "\n")
        env = dict(os.environ, GIT_CONFIG_GLOBAL=str(config), GIT_CONFIG_NOSYSTEM="1",
                   GIT_TRACE2="0", GIT_TRACE2_EVENT="0", GIT_TRACE2_PERF="0",
                   GIT_NO_REPLACE_OBJECTS="1", GIT_NO_LAZY_FETCH="1")
        subprocess.run(["git", "--version"], env=env, check=True, capture_output=True)
        self.assertFalse(trace.exists())
        trace.write_bytes(b"existing owner log")
        subprocess.run(["git", "--version"], env=env, check=True, capture_output=True)
        self.assertEqual(trace.read_bytes(), b"existing owner log")

    def test_new_directory_and_sentinel(self):
        reservation.reserve(self.root, self.sha)
        self.assertTrue((self.root / ".build-kit-owner.json").is_file())

    def test_existing_empty_directory_is_preserved(self):
        self.root.mkdir()
        with self.assertRaises(FileExistsError):
            reservation.reserve(self.root, self.sha)
        self.assertEqual(list(self.root.iterdir()), [])

    def test_existing_sentinel_and_file_are_preserved(self):
        self.root.mkdir()
        sentinel = self.root / ".build-kit-owner.json"
        sentinel.write_bytes(b"other owner")
        (self.root / "valuable.txt").write_bytes(b"original")
        with self.assertRaises(FileExistsError):
            reservation.reserve(self.root, self.sha)
        self.assertEqual(sentinel.read_bytes(), b"other owner")
        self.assertEqual((self.root / "valuable.txt").read_bytes(), b"original")

    def test_missing_parent_no_side_effects(self):
        with self.assertRaises(ValueError):
            reservation.reserve(self.parent / "absent" / "run", self.sha)
        self.assertEqual(list(self.parent.iterdir()), [])

    def test_invalid_commit_no_side_effects(self):
        with self.assertRaises(ValueError):
            reservation.reserve(self.root, "short")
        self.assertEqual(list(self.parent.iterdir()), [])

    def test_duplicate_reservation_preserves_owner(self):
        reservation.reserve(self.root, self.sha)
        sentinel = (self.root / ".build-kit-owner.json").read_bytes()
        with self.assertRaises(FileExistsError):
            reservation.reserve(self.root, "c" * 40)
        self.assertEqual((self.root / ".build-kit-owner.json").read_bytes(), sentinel)


if __name__ == "__main__":
    unittest.main()
