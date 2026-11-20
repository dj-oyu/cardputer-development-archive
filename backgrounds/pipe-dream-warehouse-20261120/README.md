# Pipe Dream — warehouse roof

The open-ended instrument aisle retains the original eye-level camera and
all the regular percussion/organ bays. An elevated exposed deck adds steel
trusses, spiral HVAC ducts, red sprinkler lines and pendant practicals. No far
closing wall is added. The result is an opaque 240×135 static RGB backdrop.

Open `pipe-dream-warehouse.blend` and render in Cycles. To regenerate atop
the open hall base run `blender -b --python-exit-code 1 --python build_warehouse.py -- /path/to/pipe-dream-open-hall.blend`.
The base defaults to the [archived open hall](../three-depth-look-revisions-20261120/pipe-hall) in the same repository. Append `--draft` when
a quick preview is sufficient.
