# Isolated host compatibility candidate

Candidate only; original exact-J1 gate remains blocked and OFF is not started.

Two reviewable patches:
- parser-candidate/derby_fixed_completion.py.patch: anchored app/js timestamp prefixes for identity/READY while retaining marker order, uniqueness and fatal checks.
- parser-candidate/verify_derby_recorded_trial.py.patch: current expected_firmware_sha256 binding and full typed flash_receipt consistency.

Saved ON export passed the isolated metadata gate. Ten malformed-marker, late-fault and tampered-binding cases were rejected. Reproduce with parser-candidate/reproduce_host_candidate.py. The unused prove import is stubbed; existing provider-verified proof is supplied, and actual BIN/ELF proof was not independently recomputed. This host result does not upgrade original-J1 acceptance or authorize OFF.

No firmware source change, new firmware head, build, physical retry, API/device operation or settings change was made by this candidate. Original parser-reference/raw hashes remain unchanged.

