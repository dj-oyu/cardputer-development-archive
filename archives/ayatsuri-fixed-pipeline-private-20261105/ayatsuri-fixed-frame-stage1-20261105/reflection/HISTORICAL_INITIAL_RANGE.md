# Initial narrow-cross implementation (superseded)

This is an exact retained excerpt of the initial tool-output transcript, not a rerun or final artifact binding. The initial version attempted to narrow v=cross(n,u) to signed16 before combining direction coefficients. It rejected15 actual inputs because quantized near-unit vectors can yield a component just above32767. The final version preserves v in signed32, with explicit magnitude bound32772; no clipping or extra normalization.

Initial output:

```
actual normals=7678 ok=7662 ambiguous=1 failure=15 source_basis_changes=0 unflagged_changes=0 widths_mismatch=0
actual_all_candidates n=122608 angle_deg_max=0.00689222572122 rms=0.00207947717514 p95=0.0035009345538 p99=0.00425191779076
```

The next wide-v implementation's files are retained separately under historical-wide-normalized-axis. That version still selected the basis from the normalized integer vector and used a two-code ambiguity heuristic. Final code instead chooses basis from raw input codes and flags exact minimum ties, with the explicitly bounded provenance argument in README.
