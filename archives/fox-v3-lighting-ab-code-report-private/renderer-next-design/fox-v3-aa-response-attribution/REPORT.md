# v32 fixed-output response attribution

Existing actual-lid8/v32 output analysis only. No renderer/model/lighting/reference/threshold changes, no new render, no fitted bins or sampling. OFF files are byte-compared to frozen lid8; ON files are checked against the externally pinned ACTUAL_OUTPUT_FREEZE. Existing official stable/uncertain masks and +/-2/255 decoded565 luma rules are unchanged.

## Direction response: full foreground, original center source-object attribution

|view/domain|active→inactive OFF→ON|complete sign reversal OFF→ON|stable inactive→active OFF→ON|
|---|---:|---:|---:|
|front fullFG|760→633|111→110|69→89|
|front covered boundary|282→216|54→51|30→35|
|front covered interior|256→256|57→57|39→39|
|front center missing|222→161|0→2|0→15|
|oblique fullFG|991→883|113→111|85→98|
|oblique covered boundary|276→218|67→62|66→67|
|oblique covered interior|416→416|46→46|19→19|
|oblique center missing|299→249|0→3|0→12|

The boundary/interior/missing domains partition foreground. Native missing geometry remains620/719 pixels, independent of AA support. Stable and uncertain responses, all eight case/view responses, all source parts and all alpha categories are retained in analysis.json. Uncertain729/698 for direction is never success. Native center labels are not an assertion that AA's four samples share the center material/object. Center-nohit uses explicit NO_CENTER_NATIVE and is not imputed from a neighbor.

ON direction active→inactive: front opaque401/partial232; oblique opaque533/partial350. Opaque-alpha covered interior alone contains232front/382oblique inactive responses. Thus the remaining defect is not entirely silhouette filtering or partial coverage. Native interior is only a4-neighbor source-ID concept: source filter can still mix surfaces, and same-object internal visibility edges can be missed.

## Material and part attribution

Use fixed compiler material IDs and original linear material trace, no brightness/color thresholds inferred from outputs. For ON direction, inactive counts front/oblique are:
- burnt tangerine material0:210/417 (OFF231/437).
- ivory material3:160/114 (OFF182/132).
- cocoa material1:61/77 (OFF74/85).
- no center surface:161/249 (OFF222/299).
Other materials remain in full tables. Conditional alpha/interior/boundary material tables are also included.

Largest named ON inactive parts: Anatomy129/241, sweeping Tail74/165, ivory Tail tip42/46. Front Cream swept cheek1 has35, Muzzle pad1 has26; oblique each Front paw−1/Rear paw−1/Cream swept cheek1 has18. Anatomy is a unified authored object, not a precise anatomical segmentation. These counts are magnitudes, not per-part rates or proof that the part is independently defective.

AA's extra inactive false positives mostly occur where center had no surface: front increase20=15missing+5boundary; oblique13=12missing+1boundary. No interior increase. This supports separating boundary composition from interior transport rather than treating all errors as one lighting problem.

## Background/alpha contract, not an unpremultiplication bug

All80 original rich color PNGs are RGBA8 with alpha255 at every pixel. Their source render has filmTransparent=false and the studio floor/background present. The source foreground alpha is a separate128-sample, seed0, adaptiveOFF render with ground hidden and filmTransparent=true (render_reference.py lines48–59). It is a selection/coverage mask, not the color PNG's alpha.

v32 averages four linear sample colors with nohit black and fixed denominator4, then encodes sRGB/RGB565. This is opaque black-background composition, not the original scene's floor/background composition. At alpha1, straight versus premultiplied RGB is numerically identical; dividing the original color by the separate mask alpha would be invalid. No correction, unpremultiplication or new score was performed.

This is a real composition-contract difference, but its contribution to each foreground response error is not isolated by these counts. Opaque mask alpha also does not guarantee that the separate color render has no cross-surface filtering. A future source-background arm must retain geometry missing and report partial/missing/opaque domains separately, not claim background filling repairs character geometry.

## Interior endpoint and transport diagnostics

For oblique opaque-covered-interior382inactive points (unchanged by AA),286 have exactly identical baseline/direction RGB565;17 are white565 in both frames. Existing actual-center HDR components show71 exactly zero combined response,183 exactly zero direct response, and only16 points with all3HDR channels>1 in both frames. World and primary groundLe response are exactly zero in all382 under the native equations. Front equivalent232points:160identical565,34white565,10zero combined,62zero direct,31all3HDR>1 in both frames.

These are endpoint/equality counts, not new acceptance thresholds, mutually exclusive causes or a causal proof. A nonzero HDR response can quantize to the same565 or stay below the existing response threshold; directΔ0 can coexist with nonzero bounce. Saturation, weak/absent transport response and receiver differences remain distinct. The data do not support explaining all interior loss as white clipping, all partial loss as lighting, or all indirect deficit as the floor.

## Bounded design implications

Two different implementation hypotheses are consistent with this census: source camera-ray floor/world composition for the boundary/nohit contract, and physically missing floor first-hit direct reflection for an interior transport hypothesis. The first has stronger specification evidence; the second's role in measured errors remains unproved. Neither should be sold as sufficient for60%, jointly adopted without attribution, or tuned by these pixels. Keep all existing fixed domains/cases and costs, including failures and regressions. Previously rejected BH position tuning, high-density loops and existing AgX re-AB are not proposed here.

## Persistence and reproduction
Run analyze.py, background_contract.py, interior_components.py with the pinned private input pack. Save these three scripts, aggregate JSONs, this report and hashes only. No images, raw winners, geometry, per-pixel masks or coordinates are included. Actual geometry/reference sources remain untouched. Initial analyze.py stopped on an OFF manifest key absent from the ON-only freeze; corrected admission explicitly compares OFF against original lid8 bytes. No partial result was used.

Independent final verification PASS:55,979 values matched, using a separate565 decoding/classification calculation and rederiving40reference masks from the8seed sources. All80opaque color images and ground-visible metadata agree. Direction-domain/component numbers above are independently confirmed. This is read-only numerical/source verification, not a new renderer execution. Evidence independent-review.json. Internal16fullFG partitions and112error-count additive identities also pass.
