#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
O=../../ayatsuri-fixed-integer-output-20261105
for opt in 0 2; do
 cc -O$opt -std=c11 -g -fsanitize=address,undefined -fno-omit-frame-pointer code/radiance_bridge.c tests/test_bridge.c -o private/bridge-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/bridge-O$opt > private/bridge-O$opt.log
 cc -O$opt -std=c11 -g -fsanitize=address,undefined -fno-omit-frame-pointer code/radiance_bridge.c tests/test_order.c ../aa/code/integer_aa.c ../aa/code/profile_adapter.c "$O/code/integer_output.c" "$O/code/block_cache.c" "$O/private/adapter.c" -o private/order-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/order-O$opt > private/order-O$opt.log
done
cmp private/bridge-O0.log private/bridge-O2.log
cmp private/order-O0.log private/order-O2.log
cc -O2 -std=c11 -Wall -Wextra -Werror -c code/radiance_bridge.c -o private/radiance_bridge.o
nm -u private/radiance_bridge.o > private/undefined-symbols.txt
