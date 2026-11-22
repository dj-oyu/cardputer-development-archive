# Six Cardputer raster backdrop studies

These six editable Blender scenes share a 240×135 opaque static raster
contract, with the center kept mostly clear of strong edges for an independently
rendered foreground character. No Cloud character is baked into these assets.

| Scene | Source |
| --- | --- |
| Child's room | `rooms-beach/room.blend` |
| Beach | `rooms-beach/beach.blend` |
| Forest with dinosaurs | `dino/dinosaur-forest.blend` |
| Pipe Dream-inspired 90s CG room | `retro-mac/pipe-dream-room-v2.blend` |
| Early Macintosh-inspired desktop | `retro-mac/early-mac-desktop.blend` |
| Vaporwave Temple | `temple/temple.blend` |

The foreground and background were combined by the native C model renderer
and RGB565 background compositor from firmware PR #135, exact revision
`fea78dce956a75d027b6fb24f3d89bd345e74f1c`, on the same 1,775-triangle Cloud
pose, camera, and dimensions. Rendering the background in Cycles does not
add ray tracing or volume work to the Cardputer. This is host validation,
not hardware speed, LCD or DMA evidence.

For export and the native harness see [dusk-bay-pathtraced-01](../dusk-bay-pathtraced-01).
Background, framebuffer, and review images can be regenerated and are not archived.
