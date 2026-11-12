#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
python "$ROOT/code/test_evaluator.py"
python "$ROOT/code/test_pack_validation.py"
blender -b -t 8 --python "$ROOT/code/render_reference.py" -- "$ROOT" > "$ROOT/render.log" 2>&1
python "$ROOT/code/evaluate_pack.py" "$ROOT"
