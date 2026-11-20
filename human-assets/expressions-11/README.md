# Human character: independent face expressions 11

This proof uses neck-10, the same face geometry and fixed UV, and the unchanged authored rig. The neutral eye art is enlarged 16% around its original upper edge without moving the brows, nose or mouth. The exact original approved face is still separately packed. Eye closure and open smile marks are both new generated graphics, registered to the reserved slots rather than hand redrawn.

In Blender, select the original armature object and open Object Properties → Custom Properties. Change **Face Blink** and **Face Smile** from 0 to 1 independently. 0 keeps the neutral slot; 1 swaps that slot, and both may be 1 simultaneously. These are discrete atlas-like switches, not eyelid mesh animation. Choose Constant interpolation if keyframing the switches at frames. The eyebrow area is a separate untouched region; new eyebrow artwork would be needed for an active brow expression.

Rebuild the exact nodes using the prepared PNGs below; the generated original concept sheet is not required or included:

    blender -b -t 4 --python-exit-code 2 --python ./expression_nodes.py -- ../neck-10/human-face-hair-neck-10.blend ./expression-neutral.png ./expression-blink.png ./expression-smile.png ./human-expressions-11.blend
    blender -b -t 4 --python-exit-code 2 --python ./verify_expressions.py -- ../neck-10/human-face-hair-neck-10.blend ./human-expressions-11.blend ./expression-blink.png ./expression-smile.png
    blender -b -t 8 --python-exit-code 2 --python ./render_expressions.py -- ./human-expressions-11.blend ./local-review

The two 1024² replacement PNGs are intentionally sparse authoring layers; actual embedded-device use could export just the eyes/mouth rectangles or an atlas after testing. The proof has no device export, on-device texture sampling, timings or real hardware validation.
