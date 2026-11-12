#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
O=../../ayatsuri-fixed-integer-output-20261105
OPENBLAS_NUM_THREADS=1 python tests/prepare.py > private/preparation.log
for opt in 0 2; do
 cc -O$opt -std=c11 -ffp-contract=off -fno-fast-math -g -fsanitize=address,undefined -fno-omit-frame-pointer -I"$O/code" -I"$O/private" code/integer_aa.c code/profile_adapter.c tests/saved_records.c "$O/code/integer_output.c" "$O/code/block_cache.c" "$O/private/adapter.c" -lm -o private/records-O$opt
 for corpus in verified_aa final_hdr_only; do
 ASAN_OPTIONS=detect_leaks=0 private/records-O$opt private/$corpus.bin private/$corpus-O$opt.csv > private/$corpus-O$opt.log
 done
 cc -O$opt -g -fsanitize=address,undefined -fno-omit-frame-pointer code/integer_aa.c tests/contracts.c -o private/contracts-O$opt
 ASAN_OPTIONS=detect_leaks=0 private/contracts-O$opt > private/contracts-O$opt.log
done
for corpus in verified_aa final_hdr_only; do cmp private/$corpus-O0.csv private/$corpus-O2.csv;cmp private/$corpus-O0.log private/$corpus-O2.log;done

cc -O2 -g -fsanitize=address,undefined -fno-omit-frame-pointer code/integer_aa.c code/profile_adapter.c tests/profile_contracts.c "$O/code/integer_output.c" "$O/code/block_cache.c" "$O/private/adapter.c" -o private/profile-contracts
ASAN_OPTIONS=detect_leaks=0 private/profile-contracts > private/profile-contracts.log
OPENBLAS_NUM_THREADS=1 python tests/summarize.py > private/summary.log
cc -O2 -std=c11 -c code/integer_aa.c -o private/integer_aa.o
nm -u private/integer_aa.o > private/integer_aa-undefined.txt
