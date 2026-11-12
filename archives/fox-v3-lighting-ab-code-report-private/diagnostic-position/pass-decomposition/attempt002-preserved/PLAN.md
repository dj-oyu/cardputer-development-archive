# Fixed same-render pass decomposition

Diagnostic only, originaloracle/ref/masks/thresholds/default unchanged. Same8conditions: seeds11/29 ×baseline/direction×front/oblique; same actual1166geometry+SNORM and originalrich scene reconstruction. Extract functions from frozen priororacle code, not a modified scene/geometry. Original source files never saved. Enable read-only viewlayer passes only; compositor remains off, denoiseOFF, originaladaptive/clamp0direct10indirect/AgX/exposure/gamma/dither1/filter fixed.

First require scene-linear Combined reconstruction from (DiffDir+DiffInd)*DiffCol + (GlossDir+GlossInd)*GlossCol + (TransDir+TransInd)*TransCol + VolumeDir+VolumeInd+Emit+Env. Official Cycles4.3.2 passes divide by respectiveColor using safe_divide_even_color, include exposure, and record already-clamped contributions. Set predeclared percomponent residual bound2e-5+5e-6*abs(Combined), report max/RMSE and reject on exceedance without clamping residual. Verify no shadowcatcher/AO/compositor special contributions in the scene. Alpha must equal1 everywhere; otherwise stop rather than silently premultiply/unpremultiply.

Then require Combined AgX PNG8 decodedpixels exact vs priororacle, ignoring only predeclared volatilePNG metadata. Also require the EXR-read Combined through Blender's original display transform reproduces this PNG8 exactly before accepting altered outputs. Multi-layer EXR32 uncompressed NONE is only an intermediate, not a different radiance/profile. Reader supports only single-part scanline float32 nonsubsampled channels and rejects unsupported/malformed layouts. Knownfloat synthetic roundtrip through Blender required.

Exactly3predeclared comparisons, same8cases and allpixels:
1 Profile only: same Combined linear radiance through existingnative clamp-to1/float sRGB encode, exportedPNG8. No additional565quantization, to isolate profile while allarms remainPNG8. Compare against originalAgX control. Nativecode's numerical encode is used, not an approximate AgX recreation.
2 Directspecular contribution removal: Combined−GlossDir*GlossCol separately for eachbaseline anddirection, then originalAgX.
3 Indirectdiffuse contribution removal: Combined−DiffInd*DiffCol separately for eachbaseline anddirection, then originalAgX.

These are post-render contribution analyses of already-clamped paths, not physically rerendering a world without thecomponent. They cannot recover unclamped radiance or isolate interactions of AgX/transport. Report negative reducedRGB counts/minima; never silently floor them to pass controls. Fail if anycomponent below−(2e-5+5e-6*abs(Combined)); preserve small negative values throughAgX and document them. Profilecontrol requires nonnegative Combined consistent with nativeencoder domain.

Keep allother emission/environment/transmission/volume/glossyindirect/diffusedirect contributions. Report actualcomponent statistics and albedo multiplication, no tuned coefficients. Eachseed compared separately to existingv3mean/stable/uncertain domains using integerPNG8oracle metric. Same-seed differences remain descriptive.2seed agreement is not stability proof, no bestarm/seed selection or overall60%claim. Save only code/tests/pins/numericalreports privately, not images/EXR/assets/geometry/rawbuffers.

PNG output stage: nativeC encodedfloat is saved through Blender Raw view (lookNone/exposure0/gamma1), using the samePNG8/RGBA/dither1 stage as AgX. Rawpass-through synthetic verifies no second sRGB transform. Both profile branches retain the common Blender quantizer; no hand-written round-only PNG for the nativeprofile. EXRdecoder total allocation is capped16MiB before allocating arrays.

Pre-render guard correction: original3LIGHT objects expose is_shadow_catcher=True, meaning participation in catcher illumination, not catchergeometry. No geometry object has thatflag. ExcludeLIGHT from the geometrycatcher guard without changing anyscene flag. Attempt001 stopped before rendering and is retained.
