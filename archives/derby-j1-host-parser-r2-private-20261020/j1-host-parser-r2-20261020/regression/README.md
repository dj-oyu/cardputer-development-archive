Fixed 99-case regression from the first independent review. The case names, order,
and expected acceptance values are pinned in `fixed-cases.json` and verified by
its canonical SHA256. Additional cases belong in a separate set.

Run in a fresh process, passing local paths:

```sh
python3 -B run_regression.py --parser-dir PARSER_DIR --fixture-root FIXTURE_ROOT --out NEW_REPORT_JSON --reference-review PRIOR_REVIEW_JSON
```

`--reference-review` optionally verifies the fixed list against the first review.
All three primary path arguments are required. The report must be a new file
outside the parser and fixture directories, with an existing parent directory.

The harness reads source fixtures without copying them and makes all raw and JSON
mutations in memory. Bytecode writes are disabled. It evaluates only
`verify_recorded_trial`; `prove` is an unused import stub that raises if called.
Actual BIN/ELF proof and the CLI are not evaluated. No device, network, API,
prepare/execute, ON rerun, OFF action, or physical acceptance is involved.

No private raw body, actual job ID, actual artifact hash, or absolute fixture
path is embedded in these harness files. Reports include local input hashes and
must remain private when run against private fixtures. Publish synthetic fixtures
only.
