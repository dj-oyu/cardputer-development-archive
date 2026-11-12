#!/bin/sh
set -eu
cd "$(dirname "$0")"
for mode in regular ubsan; do
 flags='-O2';[ "$mode" = regular ] || flags='-O1 -g -fsanitize=undefined -fno-sanitize-recover=all'
 cc -std=c11 $flags -Wall -Wextra -Werror -Wno-unused-function -Wno-misleading-indentation -fPIC -shared attribute_bridge.c -o attribute_bridge-$mode.so
 PYTHONDONTWRITEBYTECODE=1 python3 test_attributes.py attribute_bridge-$mode.so > attributes-$mode-results.json
done
nm -u attribute_bridge-regular.so > attributes-undefined-symbols.txt
