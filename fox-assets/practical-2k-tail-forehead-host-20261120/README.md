# Fox v5 tail and forehead baked shadows

This host trial keeps the weak cheek and chest bake and adds a warm shadow under the orange tail and two subtle patches on the upper outer forehead. The forehead center, cream tail tip, eyes, legs, mesh and animation remain unchanged. The underside reads clearly at −35°; at +35° the unchanged camera and geometry hide most of the tail.

## Reproduce

Use the exact original v5 model and idle host delivery listed in the prior cheek/chest trial, the prior shadow delivery, and a firmware checkout containing `5a3dedcba86f46bf74567fc07c42a85e7bb3e25f`. Python 3, Pillow and a sanitizer-capable C compiler are required.

```sh
sh verify.sh /path/to/firmware /path/to/idle-host-delivery /path/to/cheek-chest-delivery /path/to/fox-host-v5.aynm /path/to/new-output
```

Bake only: `python3 bake.py /path/to/weak.aynm /path/to/output`. Input SHA‑256: `27cbd094a019667a31ba77ed8ff438d63ba135e6235bf8f7a8dfa97a49d49981`. Output SHA‑256: `d0313b7d47486c58e92086e3890e8b7a5f4d9074ce55d901689e2e9470e7a375`. Both contain 122,024 bytes; 723 bytes differ, exclusively existing B colors and masks within the two intended orange-fur groups. Identical local positions within each group use the same mask to avoid new seams at packet boundaries.

## Host verification

Combined and isolated tail and forehead variants each passed ASan/UBSan for 12 forward/reverse samples at both anchors. The combined pixel delta is exactly the disjoint union of the two isolated deltas; the nonzero footprint is byte-exact in every frame relative to the weak cheek/chest baseline. The forehead changes 104–124 pixels, all at or above y=42 in this camera. The tail changes 246 pixels at −35° and 26–27 at +35°.

Peak snapshot usage increases from 46,428 to 50,620 bytes (+4,192), within the 65,536-byte host capacity. Model size, work counter, packet count, and actor arena are unchanged. The renderer uses the existing draw pass, with no extra texture or device network call; no real hardware speed or memory measurement was made.
