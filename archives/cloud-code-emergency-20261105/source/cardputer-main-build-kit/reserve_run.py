"""Atomically claim a NEW run directory and preserve every collision/failure."""
import argparse
import json
import os
from pathlib import Path
import re
import sys


def validate_paths(repo, root):
    repo, root = Path(repo), Path(root)
    if not repo.is_absolute() or not root.is_absolute() or not root.parent.is_dir():
        raise ValueError("Absolute Repo/RunRoot and an existing RunRoot parent are required")
    canonical_repo = repo.resolve(strict=True)
    canonical_root = root.parent.resolve(strict=True) / root.name
    if (canonical_repo == canonical_root or canonical_repo in canonical_root.parents
            or canonical_root in canonical_repo.parents):
        raise ValueError("Canonical Repo and RunRoot must be separate, non-nested directories")
    if os.path.lexists(root):
        raise FileExistsError("RunRoot or a filesystem alias already exists")
    return {"suppliedRepo": str(repo), "suppliedRunRoot": str(root),
            "canonicalRepo": str(canonical_repo), "canonicalRunRoot": str(canonical_root)}


def reserve(root, commit):
    root = Path(root)
    if not root.is_absolute() or not root.parent.is_dir():
        raise ValueError("RunRoot must be absolute and its parent must already exist")
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise ValueError("Commit must be a full lowercase SHA")
    # os.mkdir uses CreateDirectoryW on Windows; an existing directory is an
    # error even if another process won the race after PowerShell's preflight.
    os.mkdir(root)
    with (root / ".build-kit-owner.json").open("x", encoding="utf-8") as stream:
        json.dump({"commit": commit, "pid": os.getpid(), "purpose": "explicit-build-only"}, stream)
        stream.write("\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--repo", type=Path)
    parser.add_argument("--plan-paths", action="store_true")
    args = parser.parse_args()
    if args.plan_paths:
        if args.repo is None:
            raise ValueError("--plan-paths requires --repo")
        print(json.dumps(validate_paths(args.repo, args.run_root)))
        return
    reserve(args.run_root, args.commit)
    print(f"Exclusively reserved: {args.run_root}")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError) as error:
        print(f"RESERVATION FAILED: {error}", file=sys.stderr)
        sys.exit(1)
