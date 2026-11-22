# Procedural prehistoric forest

No Blender add-on is required. Three placement zones use Blender's built-in
[Distribute Points on Faces](https://docs.blender.org/manual/en/4.3/modeling/geometry_nodes/point/distribute_points_on_faces.html)
and [Instance on Points](https://docs.blender.org/manual/ja/4.3/modeling/geometry_nodes/instances/instance_on_points.html).
Density, seed, and scale range are editable per zone. The editable fern and
cycad prototypes contain curved leaflets and stems, rather than pasted textures.
Distinct large leaflets close to the lens remain legible under modest real
camera defocus. The same Cloud and perspective horizon are retained.

To rebuild, start with the
[eye-level dinosaur forest](https://github.com/dj-oyu/cardputer-development-archive/tree/488cc0a67c9d2a5002cf29c49023ec29bc81bf92/backgrounds/five-depth-eyeline-studies-20261120/dino)
asset and run `blender -b --python-exit-code 1 --python add_procedural_flora.py -- /path/to/dinosaur-forest-depth.blend`.
The archive stores editable sources and verification, not render media.
