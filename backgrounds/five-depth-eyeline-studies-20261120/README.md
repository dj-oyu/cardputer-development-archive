# Five Cardputer backdrop revisions: depth and matching eye lines

Opaque static 240×135 RGB565 backgrounds, with independently rendered Cloud.
The five perspective cameras have a projected horizontal eye line near the
Cloud's eye level, at 66.53–67.50 px from the top. The Cloud camera, scale
and original monochrome Macintosh backdrop are unchanged.

| Scene | Close / middle / far |
| --- | --- |
| Child's room | Defocused picture books / teddy, cabinet and bed / a recessed lit hall |
| Beach | Defocused corner grass / beach umbrella, surf and sunlight flare / horizon |
| Dinosaur forest | Lens-close fronds / dinosaur and pools / multiple forests through light and mist |
| Pipe Dream-inspired room | Defocused tubes / polished pneumatic instrument and chrome balls / receding feeds and observation glass |
| Vaporwave Temple | Defocused fragments / fluted columns and reflective floor / a hazy ruined Greek temple near the striped sunset |

For Pipe Dream we reduced roughness on metals/lacquer and lit them with
narrow bands for hard, white specular highlights; clear shadows and saturated
gloss are an original interpretation, not a copied frame. The other sets use
real Blender optical DOF to separate camera-near silhouettes and staging.
The closest object and light effects are still baked into one background;
this cannot occlude the native character in front at runtime.

The native preview reuses the same foreground and PR #135 renderer. Its
checks compare the C framebuffer to the foreground/background inputs in
four fixed sample poses, not a claim about all animation or real hardware.
Preview media are not archived. For the RGB565 conversion and host harness,
see [dusk bay](../dusk-bay-pathtraced-01).

## Rebuild the stills

Run from the respective scene folder in Blender 4.3+:
- beach: follow its README
- room: follow its README
- dino: `blender -b --python-exit-code 1 --python generate.py`
- pipe: `blender -b --python-exit-code 1 --python build_pipe_depth.py -- pipe`
- temple: `blender -b --python-exit-code 1 --python build.py`
