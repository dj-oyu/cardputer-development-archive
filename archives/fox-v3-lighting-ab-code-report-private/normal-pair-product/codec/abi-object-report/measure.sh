#!/bin/sh
set -eu
REPORT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
NEW=$(CDPATH= cd -- "$REPORT/.." && pwd)
OLD=${1:-"$NEW/../fox-v3-eye-evaluation/actual-eyeB"}
FLAGS='-std=c11 -O2 -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fexcess-precision=standard'
printf '%s\n' "$FLAGS" > "$REPORT/flags.txt"
cc --version > "$REPORT/compiler.txt"
for VARIANT in old new; do
 if [ "$VARIANT" = old ]; then SOURCE=$OLD; else SOURCE=$NEW; fi
 for SOURCE_FILE in ayatsuri/compact_opaque.c ui/kasane/ksn_mesh_depth.c; do
  NAME=$(basename "$SOURCE_FILE" .c)
  cc $FLAGS -fstack-usage -I "$SOURCE/product/main" -I "$SOURCE/physical" -c "$SOURCE/product/main/$SOURCE_FILE" -o "$REPORT/$VARIANT/$NAME.o"
  size -A "$REPORT/$VARIANT/$NAME.o" > "$REPORT/$VARIANT/$NAME.sections.txt"
  nm -S --size-sort "$REPORT/$VARIANT/$NAME.o" > "$REPORT/$VARIANT/$NAME.symbols.txt"
  nm -u "$REPORT/$VARIANT/$NAME.o" > "$REPORT/$VARIANT/$NAME.undefined.txt"
  objdump -dr "$REPORT/$VARIANT/$NAME.o" > "$REPORT/$VARIANT/$NAME.disassembly.txt"
 done
 cc $FLAGS -I "$SOURCE/product/main" -I "$SOURCE/physical" "$REPORT/abi_probe.c" -o "$REPORT/$VARIANT/abi-probe"
 "$REPORT/$VARIANT/abi-probe" > "$REPORT/$VARIANT/abi.txt"
done
cmp "$REPORT/old/abi.txt" "$REPORT/new/abi.txt"
