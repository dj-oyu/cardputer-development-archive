# Fixed four-block cache trial

Started 2026-11-04 UTC under parent authorization. Independent profile-only host experiment; rejected owned-ray-context code and operations are excluded. No renderer integration or device tests.

Frozen input: exact 445248-byte cube4 profile blob and existing profile arithmetic. Compare raw uint16, compressed stateless baseline, previous best stateless gather, and one four-block cache. No profile, thresholds, images or geometry changes.

The conservative cache stores decoded RGB blocks and bounded encoded-record snapshots. It revalidates the header and selected offset pairs and compares selected cached record bytes before reuse. A live, readable, stable source buffer during each call is still a caller obligation; it cannot validate dangling pointers. Explicit rebind clears old entries even at the same address. Failed binding must not retain an old binding. Selected-block validation is not authentication or validation of all unselected contents.

Required gates: exact all LUT scalars, all existing synthetic and actual ordered profile inputs and retained RGB565; malformed, mutation, alias, lifecycle/rebind/failure output protection; independent review. Costs separately report blob/RO, text, caller-owned cache, stack, heap, and setup/reset time. Benchmark actual 40-frame input order with fixed trials; do not infer speed from prior modeled hit rates. Cache behavior and cold/reset policies must be fixed before timing.

All earlier evidence remains immutable. Private backups include only code/tests/aggregate reports and the previously saved generic blob, never fox images, geometry or raw HDR. Results remain unintegrated and real hardware unproven.
