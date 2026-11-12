#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
python tests/prepare.py
cc -O2 -std=c11 -Wall -Wextra -Werror -shared -fPIC -Icode -Iprivate code/integer_output.c code/block_cache.c tests/bridge.c -lm -o private/test.so
OPENBLAS_NUM_THREADS=1 python tests/validate.py > private/validation.log
cc -O1 -g -std=c11 -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer -Icode -Iprivate code/integer_output.c code/block_cache.c tests/contracts.c -lm -o private/contracts
ASAN_OPTIONS=detect_leaks=0 private/contracts > private/sanitizers.log
cc -O2 -std=c11 -Wall -Wextra -Werror -Icode -c code/integer_output.c -o private/integer_output.o
nm -u private/integer_output.o > private/integer_output.undefined.txt
