# Complete private code handoff: a426f7a to 4a4d4cf

Public base: a426f7a356c2d84074c3d546a3bfc7e73faa21ee
Verified equal-tree local base: f7d7fe6c5c7588ac7e1a8a4afa0fec6e8525ed85
Base tree: d9a11757fc232a4251627e6a540146baa9faaedf
Final head: 4a4d4cf77f6c336971eb271324b34a32b4c2aa01
Final tree: 94e067daa97a3301f7dc9166242b63b41980cdad
Intermediate: d3fdb7789691b89419fe1918f9f68e5f8cf38e71

This replaces the delta-only handoff as a new Library version. It contains
ALL 25 changed source/test/document files and a complete combined patch.
Library versions0/1 remain historical; they are NOT needed to apply this ZIP.
No git metadata, source models, exported fox data, images, raw render buffers,
compiled binary, credentials or environment-specific absolute paths are included.

## Restore

Start from an existing checkout of the public base above (dependencies as
recorded in that checkout). Do not apply this patch on top of d3f or4a4d.

```sh
git rev-parse HEAD^{tree}
# Must be d9a11757fc232a4251627e6a540146baa9faaedf before applying.
git apply --check /path/to/unpacked/a426f7a-to-4a4d4cf.patch
git apply /path/to/unpacked/a426f7a-to-4a4d4cf.patch
```

files/ contains final sources for auditing/overlay, with SHA256SUMS and
MANIFEST.json. The full patch was applied to a separate index initialized
from the base and reproduced final tree 94e067daa97a3301f7dc9166242b63b41980cdad exactly.
The original working checkout remained clean at4a4d.

## Dependencies and representation

Included: GLB importer + synthetic import tests; side-aware static batching +
tests; compile_static adapter; pack_model; model evaluation/depth view helper;
compact codec; depth raster; both managed submit/proc adapters; all added
synthetic contracts and runner. Unchanged C/QuickJS/hostshim/test infrastructure
comes from the exact base, not an unrelated main checkout.

There is NO reducer module in4a4d. compile_static explicitly performs exact
static IR->bounded partitions->AYNM, without reduction. Its only local module
dependencies are included batch_static.cjs and pack_model.cjs. Non-destructive
Blender reduction used to obtain fixed evaluation geometry is an upstream
private evaluation step, not implemented in this head. This ZIP cannot recreate
that original/private geometry and does not silently substitute another reducer.

The depth adapter must use one ksn_mesh_append_sided(snapshot, view.patch,
view.depth, view.back_colors, view.back_faces, node_id) per kind5 mesh.
Do not restore the obsolete per-side-run depth loop. Painter fallback retains
ordered runs. Mode2 carries per-face side bits and front/back A/B palettes;
old single asset bytes and encoding remain unchanged. No quota increase.

## Host synthetic build/test

Requires existing Python3, Node, C compiler with ASan/UBSan, and tracked
QuickJS sources from the base. These commands download nothing:

```sh
python3 tools/ayatsuri/model/run_sidedness.py --opt 0 --baseline-ref a426f7a356c2d84074c3d546a3bfc7e73faa21ee
python3 tools/ayatsuri/model/run_sidedness.py --opt 2 --baseline-ref a426f7a356c2d84074c3d546a3bfc7e73faa21ee
python3 tools/kasane_contract/run_pocket_proc_qjs.py --gouraud-only --opt 0
```

Use the full public SHA above: the runner default is the equivalent local
base commit, which may not exist in the receiver's git object database.
Earlier O0/O2 ASan/UBSan synthetic and Gouraud regression passed. Optional
--legacy-input uses caller-owned existing data and is not required. The private
Blender comparison runner and private assets are outside this code handoff.

## Firmware build (instructions only, not run for this handoff)

Use the existing ESP-IDF6.0.1 environment and pinned dependencies described by
base docs/platform/clean-checkout-dependencies.md and build-environment.md.
Do not install or fetch anything automatically as part of applying this ZIP.
With prerequisites already prepared:

```sh
idf.py -B build build
idf.py -B build size
idf.py -B build size-components
```

No flash, deployment, public push or PR command is included. Host tests do not
establish firmware/device RAM or performance. Parent independently reported
fixed private evaluation94 records/max25064 B, unlit missing pixels7->0/5->0,
20negative PASS and48-buffer equality. Reproduction60% remains unmet; do not
infer it from synthetic tests. No new rendering or source changes in this task.
