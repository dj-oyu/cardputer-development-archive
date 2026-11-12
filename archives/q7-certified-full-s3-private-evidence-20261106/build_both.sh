#!/usr/bin/env bash
set -u
source /workspace/.setup/activate.sh
source /workspace/.setup/esp-idf/export.sh
export IDF_COMPONENT_MANAGER=0
r=/workspace/private-q7-certified-full-s3-20261106
for arm in off on; do
 build_dir="$r/build-$arm"
 mkdir -p "$build_dir"
 flags=(-D KASANE_MESH_Q7_CERTIFIED_PROTOTYPE=OFF)
 if [ "$arm" = on ]; then flags=(-D KASANE_MESH_Q7_CERTIFIED_PROTOTYPE=ON -D KASANE_MESH_PREPARED_PROTOTYPE=ON -D KASANE_MESH_EDGE4_PROTOTYPE=OFF); fi
 args=(idf.py -C "$r/source" -B "$build_dir" -D "SDKCONFIG=$build_dir/sdkconfig" -D PROJECT_VER=q7-cert-e488ab1e "${flags[@]}" build size)
 printf '%q ' "${args[@]}" > "$r/build-$arm.command.txt"
 printf '\n' >> "$r/build-$arm.command.txt"
 "${args[@]}" > "$r/build-$arm.log" 2>&1
 result=$?
 printf '%s\n' "$result" > "$r/build-$arm.exit.txt"
 printf 'BUILD_%s_EXIT=%s\n' "$arm" "$result"
 if [ "$result" -ne 0 ]; then tail -n 65 "$r/build-$arm.log"; exit "$result"; fi
 python "$r/source/tools/memlog.py" --map "$build_dir/cardputer_pocketjs.map" --check > "$r/memcheck-$arm.log" 2>&1
 printf '%s\n' "$?" > "$r/memcheck-$arm.exit.txt"
done
