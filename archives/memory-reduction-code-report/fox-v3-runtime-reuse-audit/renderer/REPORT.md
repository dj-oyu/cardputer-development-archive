# Renderer runtime reuse audit: negative finding

Read-only audit of completed `fox-v3-visibility-lifetime-reduction`. No source edits, builds, rendering, device actions, SDK work, or publication. This report persists previously collected findings; no new analysis was performed for this save.

## Decision

No proven substantial renderer allocation can be replaced with the inspected firmware resources while preserving ownership and failure behavior. Do not consume the single trial on framebuffer reuse, snapshot relocation, or storage splitting. Firmware resource findings are maintained separately by the firmware reviewer.

## Current named host ledger

Render peak is 373,552 bytes: visibility 106,104; AA workspace 72,512; private RGB565 64,800; transport 28,592; center-depth strip and pending row 8,640; background 976; profile cache 3,224; main compiler frame 83,760; named child frame 4,944. This is named payload/compiler-stack accounting, not whole-process or device fit. Largest product allocation is 72,512 bytes. Model and copied geometry/build inputs have already been released before rendering.

## Lifetime and failure evidence

Paths below are relative to `fox-v3-visibility-lifetime-reduction`.

- `harness/native_render_row.c:113-114` holds a 65,536-byte snapshot in the main frame. Actual snapshots in retained frame reports are 64,208 bytes: only 1,328 bytes capacity slack. Moving this allocation from stack to heap saves no payload. Right-sizing alone is not worth the single trial.
- `code/ksn_bounded_ring_helpers.inc:23-24,55-63` retains packet views and decodes snapshot geometry through quarter passes. `harness/row_transport_bridge.c:239-248` checks source/snapshot hashes after rendering. Snapshot bytes remain immutable and live; they cannot be overwritten by the RGB candidate.
- `harness/native_render_row.c:209` allocates private RGB565. `code/ksn_bounded_hdr.h:7-9` explicitly allows partial private candidates on failure. Bridge post-render checks at `harness/row_transport_bridge.c:258-261`, and native prediction/count/completion checks at `harness/native_render_row.c:236-249`, can reject after pixels were written. Current API therefore cannot render into a visible/committed framebuffer while preserving its old image on failure. A separate preserved old image would cancel the proposed framebuffer payload saving. LCD streaming before these checks also does not preserve accepted-output atomicity. Existing output-file publication is not an atomic multi-file commit.
- Admission freezes the original depth descriptor before callbacks (`code/ksn_stream_depth_impl.inc:51-55`; `harness/row_transport_bridge.c:250-254`). Input and backing storage must remain owned/live and unmodified by callbacks through return. Borrowing any firmware allocation requires verified exclusive ownership, extent/alignment, no concurrent DMA/display use, safe failure cleanup, and retained original handles. No such larger spare allocation was established by this renderer inspection.

## Already-used and rejected reuse

`code/ksn_bounded_ring.h:7-14` already overlays the 10,560-byte center pending-HDR/ID arm with the 13,440-byte quarter winner arm. Center depth remains concurrently live with the center arm through `code/ksn_stream_depth_impl.inc:62-76`; quarter winners start at lines79-81. Folding the 8,640-byte center depth into the center arm requires a 19,200-byte arm, giving only 2,880 bytes net saving and increasing the AA allocation from72,512 to78,272 bytes. This arithmetic is not a tested layout/API/guard proof. Do not recommend this trial.

Historical `fox-v3-aa-storage-audit/SPLIT_OPTION.md` and `fox-v3-rgb-memory-audit/REPORT.md` show that segmentation saves no payload and adds ownership/validation overhead. Historical guard estimates are not a current fresh bound. Smaller strip heights change scheduling and previously exceeded the unchanged scheduling cap. Do not revive these as effective-RAM or proven-fit proposals.

## Scope of conclusion

The result is not that all possible memory optimization is impossible. It is that no substantial runtime-reuse plan is justified by these inspected live resources and current failure contract. Unmeasured caller restructuring, representation changes, or broader rendering redesign are separate proposals, not established savings.
