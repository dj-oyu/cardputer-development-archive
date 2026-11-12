#!/bin/sh
set -eu
out=analysis/typed-stores
cc --version > "$out/compiler.txt"
for variant in bounded typed; do
    case "$variant" in bounded) src=candidate-bounded; typed=0;; typed) src=candidate-typed-stores; typed=1;; esac
    for unit in model pair; do
        case "$unit" in model) source="$src/main/ayatsuri/ayatsuri_model.c"; extra=;; pair) source="$out/shade_pair.c"; extra="-DSHARED=1 -DTYPED_STORES=$typed";; esac
        cc -std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -fno-fast-math \
            -fstack-usage -fdump-rtl-ira -fdump-rtl-reload -fira-verbose=10 -I"$src/main" $extra \
            -c "$source" -o "$out/${variant}_${unit}.o" > "$out/${variant}_${unit}.build.log" 2>&1
        cc -std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -fno-fast-math \
            -fverbose-asm -S -I"$src/main" $extra "$source" -o "$out/${variant}_${unit}.verbose.s"
        objdump -dr "$out/${variant}_${unit}.o" > "$out/${variant}_${unit}.asm"
        size "$out/${variant}_${unit}.o" > "$out/${variant}_${unit}.size"
        size -A "$out/${variant}_${unit}.o" >> "$out/${variant}_${unit}.size"
        nm -S --size-sort "$out/${variant}_${unit}.o" > "$out/${variant}_${unit}.nm"
    done
done
objcopy -O binary --only-section=.text analysis/host-assembly/bounded_model.o "$out/bounded_previous.text"
objcopy -O binary --only-section=.text "$out/bounded_model.o" "$out/bounded_fresh.text"
cmp "$out/bounded_previous.text" "$out/bounded_fresh.text"
