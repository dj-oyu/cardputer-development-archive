# Existing firmware buffer reuse audit

## Result
No effective RAM saving is proven against the 373,552-byte named host peak. Do not deduct an assumed 64,800-byte existing framebuffer or the 65,536-byte snapshot.

## Current source correction and pins
Connected GitHub read-only queries on 2026-11-04 resolved current main to 51f5febb753e3f0d0950043af0b579119d6fa0f0. Three complete main-file reads were verified by matching Git blob IDs from subsequent exact-commit reads. See SOURCE_PINS.json. This establishes source, not a currently flashed image or effective SDK configuration.

Current board.c has ONE TX strip, not the two TX strips in the older clean local detached checkout 1b4524e3db8524365f58e8c7fb56531c31b55e22. The older result is superseded for current main. Both versions have one shared drawing strip, not a full-screen framebuffer.

- main/hal/board.h:5-7: LCD_W=240, LCD_H=135, STRIP_H=8.
- main/hal/board.c:27-38: single UI owner and shared uint16_t[240*8], 3,840 bytes.
- board.c:61-67: one separate TX uint16_t[240*8], another 3,840 bytes. Current total named pixel-strip storage is 7,680 bytes, not 11,520.
- board.c:104-146: retain DMA payload/descriptor until exact descriptor is returned; ESP_OK without the expected descriptor is normalized to error.
- board.c:529-574: reap before writing the sole TX payload, copy/swap, queue, track in-flight ownership.
- board.c:158-160: invalidating addressing does not release descriptor or acknowledge DMA.
- board.c:689-700: finish drains timeouts and submit preserves errors.

## Failure and presentation
main/ui/kasane/ksn_render.c:2092 onward obtains the shared strip and loops over bands. Lines2361-2368 present each completed band and mark failure on error. Lines2376-2395 add a completion barrier even for provider failure after an earlier band, and never acknowledge success on completion failure. These are ownership and repair semantics, not full-frame rollback: earlier successful LCD writes remain visible.

Thus progressive use of the existing strip would expose output before the current host renderer's later failures and final validation have completed. No proven safe fullframe replacement exists. Borrowing the shared strip for small scratch might be a future integration design with explicit ownership/lifetimes, but no current caller contract, tested implementation, or effective-peak reduction establishes such a saving. The TX strip is not free general-purpose storage.

## Current host input/output constraints
Paths below are relative to fox-v3-visibility-lifetime-reduction:
- code/ksn_stream_depth_impl.inc:19 requires rgbn==64800; lines62-85 run the complete center pass, then final AA over all bands, with frame-relative RGB indexing.
- harness/native_render_row.c:113-114 declares the 65,536-byte owned snapshot payload. It is already charged in the main stack.
- code/ksn_stream_depth_impl.inc:68,81 and code/ksn_bounded_ring_helpers.inc:55-78 retain/revisit snapshot-backed geometry during center and final AA. Snapshot is not dead scratch or a reusable framebuffer.
- harness/native_render_row.c:209 allocates private RGB; lines234-249 render and validate; lines256-259 publish final pixels only after success.
- Native caller SHA256 f0f689433136ca625d2543c10750bdc9e4faa7757917bb2f2c1cf767209d8007.
- Stream-depth implementation SHA256 19f9f2acd32db739117c30cb78005136b473170f0cca1b8b95ba15dbb487b881.

## Exact remaining provenance blocker
Existing formal build archive source-provenance.json pins old build 4a4d4cf77f6c336971eb271324b34a32b4c2aa01, tree94e067daa97a3301f7dc9166242b63b41980cdad. Archive contains build/config evidence, not board source. Connected GitHub fetch_file for that exact ref/main/hal/board.c returned HTTP404: No commit found for the ref. Local GIT_NO_LAZY_FETCH inspection also could not provide its board.c. Therefore this report does not assert the old formal build's buffer layout or treat its capacity as current main's.

No new firmware build, SDK/dependency installation, git fetch, code edits, device operations or architecture prototype. Report and source-pin files only were written. Historical free36,872/largest23,552 bytes are distinct old measurements, not current available capacity.
