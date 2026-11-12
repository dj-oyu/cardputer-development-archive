# Fixed four-HDR, 2x2 display/filter interaction diagnostic

Purpose fixed before scoring: measure interaction of two already implemented components, not add prior A/B gains or select reference/threshold changes. Four actual ONE_BOUNCE001 shader captures: front/oblique x baseline/direction. Capture final-winner linear combined RGB after shader return and before clamp/encode. Control requires all8 old RGB/depth files exact before postprocessing. One process per frame; observer777600B is host-only and not snapshot payload.

The four arms share identical raw RGB, native coverage and black background:
1. point + old clamp/sRGB565
2. point + validated official AgX profile +565
3. fixed grid3 HDR mean + old clamp/sRGB565
4. fixed grid3 HDR mean + AgX +565

Grid3 means integer9-neighbor filter, not new subpixel sampling. Use the existing aa_math.py BH weights at offsets[-1,0,1], separable outer product, same fixed summation order. Uncovered and outside-image samples are black but retain their weights; no covered-only renormalization. Filtering precedes display transform. Profile output is quantized565 once. Point/OFF must reproduce actual bounce001 byte-exact. Filter support is the union of shifted native depth masks, not RGB>0. Outside support remains black. Original depth coverage and filter support are separately reported; no geometry improvement is claimed from expanded support.

Reuse the current verified65^3 official-config-derived AgX LUT with dependencies/settings hashes fixed. No source-image fit, new LUT generation or threshold/weight adjustment. Fresh C build profile_buffer against current shade functions; pin C/header/LUT/config dependencies/binary/foreground before and after. Domain-clamp counts included; unsupported negative/nonfinite rejects. RO3295500B and extra HDR/filter buffers are host diagnostic costs, not product fit.

Score decoded565 float64 directly against all8 seeds of unchanged v3 PNG references, fixed reference-only stable/uncertain domains; preserve inactive false positives, missing native foreground and unsupported/unmeasured outcomes. Four colors and two direction responses per arm only. Main purpose is interaction; any chosen combination requires independent full5-condition evaluation before a broader conclusion. No global60% claim from this diagnostic.

World visibility, one bounce and direct visibility are unchanged at outer16/inner16/DISK16. No ground geometry/emission/reflection, specular, higher GI, new shading-normal correction, geometry changes or dynamic product lifecycle integration. Original rich source/materials/AgX remain untouched. No public upload, PR, device/flash or default adoption.
