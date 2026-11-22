# Hair v15: one chestnut pigment and local contact occlusion

The seven sculpted hair locks share a single chestnut pigment. The v14 light/dark regions, broad sweep and painted core have been removed. Short-range Blender shader AO (0.095 BU, without Only Local) darkens nearby physical overlaps, not the silhouette or a drawn band. The main fringe and temple pieces still read from actual form and directional light; the true rear cap has no physical major lock division. There is no baked brushwork or texture for hair; the four face maps remain exactly packed. All geometry, rig, actions, and original source scene lights remain unchanged.

The file stores the AO material, not the comparison lighting. The preview script injects an independent strong directional key and quiet fill for rendering, and changes only AO amount for the pair.

```sh
blender -b --python-exit-code 1 --python contact_light.py -- human-hair-14.blend human-hair-contact-15.blend
blender -b --python-exit-code 1 --python verify_ao.py -- human-hair-14.blend human-hair-contact-15.blend
blender -b --python-exit-code 1 --python preview_ao.py -- human-hair-contact-15.blend on on
blender -b --python-exit-code 1 --python preview_ao.py -- human-hair-contact-15.blend off off
python compare_ao.py
```

The applied Blender AO is not a firmware implementation. RGB565 comparisons are offline previews, not device color, geometry or FPS measurements.
