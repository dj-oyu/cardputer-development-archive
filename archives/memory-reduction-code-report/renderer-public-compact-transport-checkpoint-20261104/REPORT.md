# Compact transport export assessment

Status: **NOT EXPORTABLE WITHIN THE CURRENT NARROW SCOPE**. Preparation only; no public write, no release candidate, no new implementation. Keep the existing private Space persistence. This assessment and its local metadata are not release files.

## Verified public baseline

Repository `dj-oyu/cardputer-adv-pocketjs`, branch `work/renderer-host-kernels-20261104`, assessed pinned commit `aba669858ab8b813b67ce5831f5d86086b3e0ca3`, tree `be79d462d61ab2be7aa7ba1117276d4a9f3da729`.

A read-only GitHub recursive tree query returned `truncated=false`. It contains the published `tools/renderer_experiments/indexed_visibility` module, but no `bounce.c`, `bounce.h`, or `fox_disk_lighting` module. This is evidence for the pinned baseline, not a fresh branch-head verification.

## Dependency and privacy boundary

The verified compact interning implementation resides inside `fox-v3-compact-transport/private-build/transport/bounce.c` and `bounce.h`. These files are not a standalone compact pool: they include legacy transport, direct disk lighting, ground emission/reflection, floor/world terminal evaluation, budgets, generation bindings, and ownership logic.

The header directly requires `../visibility/visibility.h` and `../physical/fox_disk_lighting.h`. Visibility is published at a different directory location; physical lighting is not published. A buildable whole-module export therefore requires at least the two transport files and both physical lighting files (52,555 source bytes total), plus include-path adaptation, fresh synthetic tests, and review of the broader previously unpublished module. Pixel transport, background, model assets, and the private harness are not needed for this minimum C linkage, and must not be copied merely to make it build.

More decisively, `bounce.h` exposes workload-derived constants `BOUNCE_FLOOR_MAX_SHADERS=17241`, `BOUNCE_FLOOR_MAX_HITS=71667`, and `BOUNCE_FLOOR_WORK_CAP=875970912`. The floor/world work cap is also algebraically derived from those values. These are active validation/budget constraints, not removable comments. The first two values match private actual-run workload counts in the existing local records. The current task explicitly excludes private asset/workload constants from a public export.

Removing, changing, or parameterizing these limits, or extracting only the interning portion, would alter the verified implementation and require a separately scoped refactor and validation. A generic replacement or substitute implementation was not created.

## Licensing

The published visibility export carries the repository's existing MIT license (public LICENSE blob `aa38507a02aeb24890163120f2469d93c704bea9`). That establishes the public baseline license, but does not independently establish provenance or a new license grant for every unpublished transport/lighting source. No license was invented or copied onto a new export.

## Tests and deliverables

- No export code or synthetic tests generated because the feasibility gate failed.
- No O2 or ASan/UBSan export tests run; there is no export to test.
- Existing private independent synthetic test evidence is at `fox-v3-compact-transport/test-independent/RESULTS.json`; it reports O2 and O2 ASan/UBSan PASS, 1116 checks and 157 parity pairs per arm, with LeakSanitizer disabled. This assessment does not re-run or upgrade that evidence into public-export validation.
- No asset tests, renders, device operations, PR, merge, or network writes performed.
- `LOCAL_PROVENANCE.json` records current source SHA-256 hashes and sizes.
- `PUBLIC_ALLOWLIST.json` is deliberately empty. Do not publish this assessment or local metadata as a substitute for a tested code export.

Parent confirmed the stop decision: retain private Space saving and do not refactor verified code solely for publication. Existing private archive identity/content was not independently checked or changed by this worker. No actual-renderer integration or device-fit claim is made.
