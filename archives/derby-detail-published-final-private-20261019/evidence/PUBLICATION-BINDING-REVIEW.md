# Publication binding — independent review addendum

Reviewed UTC: 2026-10-19T21:57:38.424329+00:00

**PASS: all three published commit objects contain exactly the previously reviewed trees.** The clean-exit source review and its source-bound host/compiler evidence carry forward unchanged. No tests were rerun and no repository, hardware, MCP, source, build or flash action was performed.

| Draft PR / variant | Published exact head | Reviewed candidate | Unchanged tree |
|---|---|---|---|
| 21 / baseline | `9b9e9ae46c08a6597f871419b280874d5e09033c` | `64a13d3eda0b205cd560f4791c8211b2c458de01` | `fe90d7e2e78e680423f40131830071af99944225` |
| 22 / native | `0e3a457f0bd1897ff147954104735a20b7735e52` | `2b82842efd6762130a920600f3fb7f67aa57fd9a` | `6648060e994f1f240a15db8a1f7e8fae1286bbf8` |
| 23 / batch | `efb9aa4ee71970ded23c80f8a4bc3eb375ea84fb` | `8b4923614bc0d57909fcc32e225997de1cce628b` | `020c8b038f7876adc458715f18552e065acc1dbc` |

Independent checks confirmed clean local feature checkouts at those exact published IDs; all 12 follow-up file SHA256 values match both the earlier final review and CLEAN-EXIT-PUBLISHED.json. Full tree identities match, all original comparison bases remain ancestors, and checkpoint branches still name the three local candidate commits.

Each unsigned commit was independently reconstructed from the saved GitHub API author/committer/time/parent/tree/message fields, retaining the original +0900 timezone offsets from the raw commit because API dates are normalized to UTC. Its Git object SHA1 matches the published ID; reconstructed bytes equal local cat-file output and the retained raw-commit SHA256. This verifies content binding to the supplied publication receipt; no fresh remote ref query was made here.

The prior automatic-approval publication denial is **resolved**, according to the parent's direct-user-approval and successful-publication evidence. The earlier review/manifest preserve the historical denial and are superseded on that status by this addendum. CI is reported running by the parent; no CI PASS or actual new target proof is claimed here.

The original baseline device capture remains **FAIL**, unchanged. Source/flash remain on hold for the parent's cache preflight/authorization work (parent currently reports 13/16 slots). No next fetch or flash was attempted. See CLEAN-EXIT-REVIEW.md for the source review, CLEAN-EXIT/HOST-TEST-MANIFEST.json for prior host evidence, and PUBLICATION-BINDING-REVIEW.json for structured binding results.
