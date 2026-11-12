#!/bin/sh
# Run from the experiment root. All outputs stay under analysis/early-snorm.
set -eu
out=analysis/early-snorm
cc --version > "$out/compiler.txt"
for variant in bounded early; do
    case "$variant" in
        bounded) src=candidate-bounded ;;
        early) src=candidate-early-snorm ;;
    esac
    cc -std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -fno-fast-math \
        -fstack-usage -fdump-rtl-ira -fira-verbose=10 -I"$src/main" \
        -c "$src/main/ayatsuri/ayatsuri_model.c" -o "$out/${variant}_model.o" \
        > "$out/${variant}_model.build.log" 2>&1
    objdump -dr "$out/${variant}_model.o" > "$out/${variant}_model.asm"
    size "$out/${variant}_model.o" > "$out/${variant}_model.size"
    size -A "$out/${variant}_model.o" >> "$out/${variant}_model.size"
    nm -S --size-sort "$out/${variant}_model.o" > "$out/${variant}_model.nm"
done
for variant in bounded early; do
    case "$variant" in bounded) src=candidate-bounded ;; early) src=candidate-early-snorm ;; esac
    cc -std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -fno-fast-math \
        -fverbose-asm -S -I"$src/main" "$src/main/ayatsuri/ayatsuri_model.c" \
        -o "$out/${variant}_model.verbose.s"
done
python3 - <<'PY'
from pathlib import Path
import re
for v in ['bounded', 'early']:
    p=Path('analysis/early-snorm')
    text=(p/f'{v}_model.asm').read_text()
    part=re.search(r'^[0-9a-f]+ <mesh_packet>:\n.*?(?=^[0-9a-f]+ <|\Z)', text, re.M|re.S)
    (p/f'{v}_mesh.asm').write_text(part[0])
PY
objcopy -O binary --only-section=.text analysis/host-assembly/bounded_model.o "$out/bounded_previous.text"
objcopy -O binary --only-section=.text "$out/bounded_model.o" "$out/bounded_fresh.text"
cmp "$out/bounded_previous.text" "$out/bounded_fresh.text"
