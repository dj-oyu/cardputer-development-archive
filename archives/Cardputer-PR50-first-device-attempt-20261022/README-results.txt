PR50 device attempt, 2026-10-22 UTC

Four broker-owned builds passed and matched generated diagnostic code, product
partition/security, IDF 6.0.1 and the common regenerated local component lock.
Baseline e0fe98a8c2a3de3b48c8d547c1ff3c8d99863267.
Candidate 1e68b268a4b91ec54e88f408118de3e39b8b6bc5.

Only oval A was flashed: pr50-oval-a1-flash-20261022.
Full segment readback and expected ELF-prefix boot checks succeeded.
The actual app raised InternalError: interrupted during the synchronous
unmeasured advance-to-390m loop. END status=app_error frames=0; EXIT running=0.
No valid performance timing/allocation/heap-minimum or A/B comparison exists.
Zero timings and 4294967295 heap-minimum sentinel are NOT performance values.
Warmup product frames=39; measured frames=0. B/straight were not flashed.
Retained boot capture: 10006 bytes, 142 complete lines, 29.916 s;
capture_gap=false, truncated=false, omitted_lines=0. All pages were saved.
Monitoring had a temporary renewal RPC timeout; no device operation was replayed.

The frozen original firmware receipt was restored by normal broker operation,
with full readback and boot confirmation. Original config restored byte-for-byte.
Only firmware segments were targeted; no data-partition/full-backup restore.
Possible cause: synchronous setup exceeds product watchdog. The stack proves
the failing loop; no explicit watchdog-reason event was emitted, so this cause
remains an inference. Proposed remedy: bound setup across normal owner turns,
retain production watchdog, rerun host equivalence/CI before another device run.
