# Dinosaur forest

An original long-necked dinosaur on the right of a layered tropical forest.
Cycles renders volumetric mist and oblique shafts; the central foreground
character is separate and is not baked into the scenery.

From this source folder:
```sh
blender -b --python-exit-code 1 --python generate.py
```

Exports a 240×135 opaque RGB PNG. The compressed Blender scene is reopened
before rendering; comparison outputs are not versioned.
