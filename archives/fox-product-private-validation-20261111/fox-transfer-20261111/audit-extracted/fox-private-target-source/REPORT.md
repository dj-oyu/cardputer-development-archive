# Private target handoff preparation

## Scope
This is a portable callback **measurement entry point**, not device integration or a target-fit result. It reuses the frozen coherent head-only rig and full1982triangle diagnostic scene_prepare/scene_band. Original material IDs/topology are retained; source BSDF, eye transparency/depth and facial morph animation are not reproduced. This lower-level entry does not include Kasane UI/core; the previously verified actual Kasane completion seam is separate evidence.

The host campaign excludes30warmups and measures120frames, exactly eight sampled head poses × three cameras × five cycles. Authoritative total is callback monotonic elapsed from before prepare through the final successful completion. The existing internal scene_times uses C clock() CPU timing and is not reinterpreted as target elapsed. Individual prepare/raster/submit/drain and total statistics are in harness/O2.log. These are host mock results, not real SPI or20fps evidence.

## Portable owner contract
The owner holds two projected snapshots/bins, one serially reused rig/raster workspace and two four-row halves. Immutable cold geometry and weights outlive both snapshots. Successful candidate promotion occurs only after the port positively confirms final completion of all accepted transfers. An unsuccessful stage aborts the measured run, retaining the old ready snapshot; already transferred pixels are not rolled back. Any uncertain borrow quarantines the owner. Recovery only proves input release/unpins, not panel repair; a real transport/repair adapter remains to be implemented and reviewed.

The runtime entry contains no full panel/framebuffer, image oracle, test witness or statistics sample array. These belong only to host tests. The final private source bundle is for authorized private target integration; it contains private derived model arrays and must not be committed/pushed to a public repository.

## Memory and target gates
No readonly-to-flash placement is assumed. Report all source/controls as RAM until an actualtargetELF proves otherwise. Hostsizeof/symbols/compilerstack measure this host build only. Runtime sections must be checked against the actual target linker map, DMA-capable placement and heaplargest/taskstackHWM. Do not add an unrelated synthetic firmware's182004BDIRAM to this ledger or infer fit by subtraction.

The earlier full-core owner ledger152903B included55266Bimmutable source as RAM. Its workspace14512B plus measuredstack9608B =24120B, not16KiB. A smaller new lower-level linkedprobe is not an apples-to-apples optimization of that owner: it omitsKasanecore/UI and removes unusedtest/oracle paths with linkerGC.

See TARGET_CHECKLIST.md for callback integration, finalACK semantics, target stage clock conversion, actualmap/stack/heap requirements, PIEOFF baseline and50ms whole-frame criterion. The target adapter/toolchain/runtime port is unfinished; no targetbuild/flash/device operations occurred here.

## Provenance and reproduction
`verify_sources.py` validates the frozen source manifests and publiccheckout cleanliness. `harness/run.py` compiles/runs host correctness+30/120timing tests. Source dependency list and minimalruntime linkprobe accompany the harness. The top-level hashmanifest records all final artifacts; bundlemanifest records private sources only. Do not include hostsanitizer executables, Blenderreference JSON/images or gianttestarrays in firmware.
