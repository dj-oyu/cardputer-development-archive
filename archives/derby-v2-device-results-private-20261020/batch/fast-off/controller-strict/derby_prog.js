'use strict';
// [LIGHT, MID, HEAVY]: stand tiers, crowd rows, dots per bay, roof arc
// segments, rail post and turf stripe spacing (m), the crowd's head and body
// patterns; then the crowd's skin, cloths, row shift, empty, cells a m.
const KN = [[3, 2, 3, 3, 8, 10, 263170, 921095], [4, 3, 4, 5, 5, 7, 1083458, 3792103],
  [5, 4, 6, 8, 4, 5, 2236962, 7829367], [0xf5d3, 0xc228, 0x3a7a, 7, -1, 2.5],
  // The dust and the band (docs/apps/derby-finish-fx.md; sizes and colours
  // are the dust, bokeh and band plans' first lines). 0..6 FINISH, 7..13
  // HEAD ON: the dust's area (x from, x to, y from, height), the dust's and
  // the bokeh's slot px (0: off), the band's strokes a side. 14 the dust's
  // rise px a frame (FINISH), 15, 16 the dust's and the bokeh's parallax (1:
  // the track at 16 m), 17 the drift px a frame a unit of parallax, 18 t a
  // frame, 19 frames a band redraw. (20..22: the cut's frame, cx and camera,
  // appended by paint().)
  [20, 220, 50, 72, 20, 60, 3, 60, 180, 30, 50, 14, 0, 0, .24, 1, 1, .15, .003, 3]];
let tier = 1;
// The close-up horse: 6 gallop frames of one polyline (typed points, half
// pixels), fixed on screen with the hip at HX,HY and 4 px per unit.
const HX = 92, HY = 88, HS = 4, bob = k => .35 * sin(2 * PI * k / 3);
// Units, y down, hip at 0,0; a pair 20+o,l is a leg of phase o and
// segment length l from the point before it (knee, hoof, back up).
const BODY = [-2.4, 3.2, -1.6, 1.4, -.6, 0, .3, -.4, 3.8, .3, 7, -.9, 8.3, -3.1, 9.9, -5, 9.8, -6, 10.5, -4.9,
  12.7, -2.3, 12.5, -1.6, 10.4, -2.4, 9.3, -2, 8.6, .8, 7.4, 2.2, 23.14, 1.9, 23.64, 1.9, 4, 2.7, 1.2, 2, 20, 2,
  20.5, 2, -.5, 1.2, -.6, 0];
let F = null;
// HEAD ON's fixed set (rails, finish line, stands, the screen edge on) as
// one polyline; points from the camera in README.
const HD = [[120, -155, 120, 425, 120, -155, -63, 323, 425, 120, 85, 159, 120, 100, 142, 120, 184, 166, 166, 166, 156, 156, 166, 166, 184, 184, 189, 189, 196, 196, 204, 204, 214, 214, 227, 227, 240, 227, 227, 240, 227, 227, 120, 184],
  [50, 105, 50, 105, 50, 160, 123, 123, 160, 50, 64, 64, 50, 58, 58, 50, 56, 56, 40, 14, 21, 42, 40, 56, 56, 19, 17, 56, 57, 14, 10, 58, 59, 5, -1, 60, 61, 60, -1, -8, -1, 60, 50, 19]];
const PAD = ['turf', 'rail', 'stands', 'silk', 'g0', 'g1', 'g2', 'g3', 'g4', 'g5', 'crowd', 'pole'],
  RUN = ['gate', 'r0', 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7', 'map', 'vis', 'fr', 'hd', 'prail', 't0', 't1', 'hl', 'dust', 'bokeh'];
