#!/usr/bin/env python3
"""Inventory already completed outputs; this is a freeze, never an admission result.

The caller must retain the printed SHA256 outside the inventoried run and supply
it to strict_scene_score.py. This helper cannot bless incomplete or wrong data.
"""
import argparse
import json
from pathlib import Path
from strict_scene_score import HERE, require, contained, sha, read_json, index_frames, ARM_DIR


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--workspace', type=Path, default=HERE.parents[1])
    p.add_argument('--root', type=Path, required=True)
    p.add_argument('--arms', nargs='+', choices=['off', 'on', 'background'], required=True)
    p.add_argument('--audit-code', type=Path)
    p.add_argument('--encoder', type=Path)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    workspace, root, output = a.workspace.resolve(), a.root.resolve(), a.output.resolve()
    require(root.is_relative_to(workspace), 'root must be inside workspace')
    require(output.is_relative_to(HERE) and not output.exists(), 'fresh output under analysis-code required')
    arms = set(a.arms) | {'off'}
    files = {}
    def pin(path):
        name = str(path.resolve().relative_to(workspace))
        path = contained(workspace, name)
        files[name] = sha(path)
        return name
    for arm in sorted(arms):
        folder = root / ARM_DIR[arm]
        require(not (folder / 'FAILED.json').exists() and not (folder / 'REJECTED.json').exists(), 'failed/rejected arm')
        done = read_json(folder / 'COMPLETED.json')
        require(done['status'] == 'ALL20_ACTUAL_COMPLETE' and done['arm'] == arm, 'incomplete arm')
        pin(folder / 'COMPLETED.json')
        for row in index_frames(done['frames']).values():
            for ext in row['files']:
                pin(contained(folder, row['prefix'] + ext))
        if arm != 'off':
            pin(folder / 'COMPOSITION_AUDIT.json')
    result = {'version': 'camera-background-completed-output-pins-v1', 'files': files,
              'scope': 'External output inventory only, not a claim of admission or quality', 'arms': sorted(arms)}
    if arms != {'off'}:
        require(a.audit_code is not None and a.encoder is not None, 'composition audit source and encoder required')
        result['compositionAuditCode'] = pin(a.audit_code.resolve())
        result['compositionEncoder'] = pin(a.encoder.resolve())
    output.write_text(json.dumps(result, indent=2) + '\n')
    print(sha(output), str(output))


if __name__ == '__main__':
    main()
