#!/usr/bin/env bash
set -u
source /workspace/.setup/activate.sh
source /workspace/.setup/esp-idf/export.sh
export IDF_COMPONENT_MANAGER=0
r=/workspace/private-q7-certified-full-s3-20261106
for arm in no-prepared edge4; do
 p=ON;e=OFF
 if [ "$arm" = no-prepared ];then p=OFF;else e=ON;fi
 b="$r/invalid-$arm"
 args=(idf.py -C "$r/source" -B "$b" -D "SDKCONFIG=$b/sdkconfig" -D PROJECT_VER=q7-cert-e488ab1e -D KASANE_MESH_Q7_CERTIFIED_PROTOTYPE=ON -D "KASANE_MESH_PREPARED_PROTOTYPE=$p" -D "KASANE_MESH_EDGE4_PROTOTYPE=$e" reconfigure)
 printf '%q ' "${args[@]}" > "$r/invalid-$arm.command.txt"
 "${args[@]}" > "$r/invalid-$arm.log" 2>&1
 echo "$?" > "$r/invalid-$arm.exit.txt"
done
