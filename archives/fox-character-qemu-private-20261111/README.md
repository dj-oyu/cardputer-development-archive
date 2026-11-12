# Private character rendering progress — 2026-11-11

Two separate pipelines now produce actual ESP32-S3 QEMU images. They must not be conflated into a completed full-character app.

1. Recovered full 2k-v2 fox: 1,982 triangles, 74 objects, head/body rig, frozen streaming renderer and two-snapshot owner. Six images (neutral and two head-control extremes, front/oblique) exactly match host. Two lifecycle/reverse passes, 12 frames and612 borrowed-buffer checks pass. It is opaque diagnostic material-ID color with neutral face, not original eyes/materials or facial morphs. No QuickJS/AYNM/high-level Kasane compositor in this path.
2. New body AYNM integration: 454 triangles/229 original vertices; DQ, original-topology smooth normals, material-preserving partitions, explicit Blender/native coordinate-basis and winding mapping, native model overrides and production mesh raster. Host2views×64poses, reverse/pause, O2 andASan/UBSan pass. Same-renderer Blender-input oracle differs by only2pixels across128images, not an artistic acceptance. Target24logged selected/replay visits plus8pause renders and6captures match host exactly, with arena release restoring initial heap.

The original fox-cardputer-2k-v2.blend SHA256384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8 was unchanged. This is a diagnostic derivative of fox-bubble-bold, not the approved high-resolution original. Recovered source manifests match their archives; exact mapping to historical unpublished commit52b119ca is unproven.

No production repo edits, Git push, PR merge, physical device access, firmware flash, broker action or parallel QuickJS branch change occurred. QEMU timings are not device FPS. Memory figures describe isolated test guests, not full firmware fit. Original eye transparency/BSDF, morph/brows, unified high-level character integration and physical20fps remain open.

## Contents
- whole-fox-qemu-contact.png: six actual full diagnostic target images.
- fox-body-qemu-contact.png: six actual body-only target images.
- fox-whole-qemu-private-evidence.zip: full recovered whole-fox source/host/target evidence and instructions.
- body-source/: new private harness, compact fixtures, reports, all host raw candidate/oracle outputs and target reproduction project/evidence.
- frozen-inputs/: original recovered source and copybridge archives, unchanged.

Body recompile needs public repo dj-oyu/cardputer-adv-pocketjs at828baa3af69c55e7884c53557ea39f91190010a0. The package includes its needed source snapshot under body-source/qemu-render-20261111, and the provisional DQ/normal headers. CMake uses relative sibling layout; ESP-IDF6.0.1 andGCC15.2.0 should be set up separately. Generated fixtures are ready; regenerating them needs the original private inputs named by generate.py, which are not included here.

Private derived source arrays are included for reproducibility. Do not push this bundle or its data to a public repository. Files are for the user's own Space only.
