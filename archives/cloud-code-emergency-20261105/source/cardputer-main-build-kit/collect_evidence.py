"""Build-only evidence checks. Standard library; no device or network access."""
import argparse
import os
import csv
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys
import subprocess


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def record(path):
    require(path.is_file(), f"Missing artifact: {path}")
    return {"path": str(path), "bytes": path.stat().st_size,
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}


def build_path(build, value):
    require(isinstance(value, str) and bool(value), "Missing artifact path")
    path = (build / value).resolve()
    require(path.is_relative_to(build), f"Artifact escapes build directory: {value}")
    return path


def config_values(path):
    result = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.fullmatch(r"(CONFIG_\w+)=(.*)", line)
        if m:
            result[m[1]] = m[2]
        m = re.fullmatch(r"# (CONFIG_\w+) is not set", line)
        if m:
            result[m[1]] = "n"
    return result


def check_configuration(worktree, build):
    project = read_json(build / "project_description.json")
    require(project.get("target") == "esp32s3", "Project target must be esp32s3")
    require(project.get("git_revision") == "v6.0.1", "Project IDF revision must be exact v6.0.1")
    require(project.get("project_name") == "cardputer_pocketjs", "Unexpected project name")
    for key, expected in (("project_path", worktree), ("build_dir", build),
                          ("config_file", build / "sdkconfig")):
        require(Path(project.get(key, "")).resolve() == expected, f"Unexpected project {key}")
    defaults = project.get("config_defaults")
    if isinstance(defaults, str):
        defaults = defaults.split(";")
    require(isinstance(defaults, list) and len(defaults) == 1 and
            Path(defaults[0]).resolve() == worktree / "sdkconfig.defaults",
            "Exactly this worktree's sdkconfig.defaults is required")
    require(not (worktree / "sdkconfig").exists(), "Root sdkconfig must not exist")
    config = config_values(build / "sdkconfig")
    expected = {"CONFIG_IDF_TARGET": '"esp32s3"', "CONFIG_ESPTOOLPY_FLASHSIZE_8MB": "y",
                "CONFIG_PARTITION_TABLE_CUSTOM": "y",
                "CONFIG_PARTITION_TABLE_CUSTOM_FILENAME": '"partitions.csv"'}
    for key, value in expected.items():
        require(config.get(key) == value, f"Unexpected {key}")
    # Every project-owned diagnostic boolean currently defaults to n.
    kconfig = (worktree / "main/Kconfig.projbuild").read_text(encoding="utf-8")
    for block in re.split(r"(?m)^\s*config\s+", kconfig)[1:]:
        name = block.split()[0]
        if re.search(r"(?m)^\s*bool\b", block) and re.search(r"(?m)^\s*default n\s*$", block):
            require(config.get("CONFIG_" + name, "n") == "n", f"Non-default diagnostic enabled: {name}")
    # Check the source's own CMake option defaults instead of copying another
    # branch's experimental settings into this build.
    cache = (build / "CMakeCache.txt").read_text(encoding="utf-8")
    cmake = (worktree / "main/CMakeLists.txt").read_text(encoding="utf-8")
    options = dict(re.findall(r'option\(\s*(\w+)\s+"[^"]*"\s+(ON|OFF)\s*\)', cmake))
    for name, value in options.items():
        require(re.search(rf"(?m)^{re.escape(name)}:BOOL={value}$", cache),
                f"CMake option does not match source default: {name}")
    return {"target": project["target"], "idfRevision": project["git_revision"],
            "sdkconfig": record(build / "sdkconfig"), "cmakeOptionDefaults": options}, project, config


def number(value):
    value = value.strip()
    if value[-1:].upper() in ("K", "M"):
        return int(value[:-1], 0) * {"K": 1024, "M": 1048576}[value[-1].upper()]
    return int(value, 0)


def partitions(path):
    result = []
    type_ids = {"app": 0, "data": 1}
    subtype_ids = {"factory": 0, "ota": 0, "phy": 1, "nvs": 2}
    for row in csv.reader(path.read_text(encoding="utf-8-sig").splitlines()):
        if not row or row[0].lstrip().startswith("#"):
            continue
        require(len(row) >= 5, "Malformed partition row")
        name, kind, subtype, offset, size = [v.strip() for v in row[:5]]
        kind = type_ids[kind] if kind in type_ids else number(kind)
        subtype = subtype_ids[subtype] if subtype in subtype_ids else number(subtype)
        result.append({"name": name, "type": kind, "subtype": subtype,
                       "offset": number(offset), "size": number(size),
                       "flags": row[5].strip() if len(row) > 5 else ""})
    require(bool(result), "Empty partition table")
    previous_end = 0
    names = set()
    for entry in result:
        require(entry["name"] not in names, "Duplicate partition name")
        require(entry["offset"] >= previous_end and entry["size"] > 0, "Overlapping/empty partition")
        previous_end = entry["offset"] + entry["size"]
        require(previous_end <= 0x800000, "Partition exceeds physical 8 MiB flash")
        names.add(entry["name"])
    return result


def collect(worktree, build, commit, generated_partitions=None):
    worktree, build = worktree.resolve(), build.resolve()
    require(build.is_relative_to(worktree), "Build directory must be inside fresh worktree")
    result, project, config = check_configuration(worktree, build)
    require(re.fullmatch(r"[0-9a-f]{40}", commit), "Explicit full commit SHA required")
    result["sourceCommit"] = commit
    if generated_partitions is None:
        return result
    actual = partitions(generated_partitions)
    require(actual == partitions(worktree / "partitions.csv"), "Generated partition table differs from source")
    factory = [p for p in actual if p["type"] == 0 and p["subtype"] == 0]
    require(len(factory) == 1, "Expected one factory app partition")
    factory = factory[0]
    flasher = read_json(build / "flasher_args.json")
    require(flasher.get("extra_esptool_args", {}).get("chip") == "esp32s3", "Flasher target mismatch")
    app = flasher.get("app", {})
    require(number(app["offset"]) == factory["offset"], "App offset differs from generated factory partition")
    binary = build_path(build, app["file"])
    require(binary == build_path(build, project["app_bin"]), "Project/flasher app paths differ")
    files = flasher.get("flash_files", {})
    app_entries = [(number(off), build_path(build, path)) for off, path in files.items()
                   if build_path(build, path) == binary]
    require(app_entries == [(factory["offset"], binary)], "Flash file mapping does not identify factory app exactly once")
    app_record = record(binary)
    require(0 < app_record["bytes"] <= factory["size"], "App does not fit generated factory partition")
    partition_binary = build / "partition_table/partition-table.bin"
    partition_offset = number(config["CONFIG_PARTITION_TABLE_OFFSET"])
    require([(number(off), build_path(build, path)) for off, path in files.items()
             if build_path(build, path) == partition_binary] == [(partition_offset, partition_binary)],
            "Generated partition binary missing from flash mapping or offset mismatched")
    flash_records = [{"offset": number(off), **record(build_path(build, path))} for off, path in files.items()]
    result.update({"app": {**app_record, "offset": factory["offset"],
                           "partitionBytes": factory["size"], "spareBytes": factory["size"] - app_record["bytes"]},
                   "partitions": actual, "flashFiles": flash_records,
                   "artifacts": {name: record(build / name) for name in (
                       "project_description.json", "flasher_args.json", "sdkconfig", "CMakeCache.txt",
                       "compile_commands.json", "cardputer_pocketjs.elf", "cardputer_pocketjs.map",
                       "partition_table/partition-table.bin")},
                   "sourceDefaults": record(worktree / "sdkconfig.defaults"),
                   "dependencyLock": record(worktree / "dependencies.lock"),
                   "deviceStatus": "not run"})
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--git-path", type=Path, required=True)
    parser.add_argument("--worktree", type=Path, required=True)
    parser.add_argument("--build", type=Path, required=True)
    parser.add_argument("--stage", choices=("configure", "final"), required=True)
    parser.add_argument("--partitions", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    require(not os.path.lexists(args.output), "Evidence output already exists; refusing overwrite")
    require(args.stage != "final" or args.partitions is not None, "Final evidence requires generated partition CSV")
    require(args.git_path.is_absolute() and args.git_path.is_file(), "Explicit Git executable required")
    require(re.fullmatch(r"[0-9a-f]{40}", args.commit), "Explicit full commit SHA required")
    actual = subprocess.run([str(args.git_path), "--no-replace-objects", "--no-lazy-fetch", "--no-optional-locks", "-C", str(args.worktree),
                             "rev-parse", "HEAD"], check=True, capture_output=True, text=True).stdout.strip()
    require(actual == args.commit, "Worktree HEAD differs from supplied commit")
    result = collect(args.worktree, args.build, actual, args.partitions if args.stage == "final" else None)
    if args.stage == "final":
        copies = [(args.build / name, args.output.parent / name) for name in (
            "project_description.json", "flasher_args.json", "sdkconfig", "CMakeCache.txt")]
        copies += [(args.worktree / name, args.output.parent / ("source-" + name)) for name in (
            "sdkconfig.defaults", "partitions.csv", "dependencies.lock")]
        # Validate every destination before any copy. Exclusive creation also
        # refuses a collision that appears after this check; nothing is replaced.
        for source, destination in copies:
            require(source.is_file(), f"Missing evidence source: {source}")
            require(not os.path.lexists(destination), f"Evidence destination exists: {destination}")
        for source, destination in copies:
            with source.open("rb") as src, destination.open("xb") as dst:
                shutil.copyfileobj(src, dst)
    with args.output.open("x", encoding="utf-8") as stream:
        json.dump(result, stream, indent=2)
        stream.write("\n")
    print(f"{args.stage} evidence verified: {args.output}")
    if "app" in result:
        print(f"APP bytes={result['app']['bytes']} offset={result['app']['offset']:#x} sha256={result['app']['sha256']}")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError, OSError, TypeError, subprocess.CalledProcessError) as error:
        print(f"EVIDENCE FAILED: {error}", file=sys.stderr)
        sys.exit(1)
