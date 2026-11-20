#!/usr/bin/env python3
"""Convert an already color-managed 240x135 PNG to raw RGB565 LE; optionally preview the quantized result."""
import argparse
from pathlib import Path
import struct
from PIL import Image

WIDTH, HEIGHT = 240, 135
SIZE = WIDTH * HEIGHT * 2

def encode(source):
    with Image.open(source) as im:
        if im.format != 'PNG' or im.size != (WIDTH, HEIGHT):
            raise ValueError(f'Expected {WIDTH}x{HEIGHT} PNG; got {im.format} {im.size}')
        rgba = im.convert('RGBA')
        if rgba.getchannel('A').getextrema() != (255,255):
            raise ValueError('Transparent pixels: export the composed opaque background first')
        rgb = rgba.convert('RGB').tobytes()
    raw = bytearray(SIZE)
    for i, (r,g,b) in enumerate(zip(rgb[::3], rgb[1::3], rgb[2::3])):
        struct.pack_into('<H',raw,2*i,((r>>3)<<11)|((g>>2)<<5)|(b>>3))
    return bytes(raw)

def preview(raw):
    if len(raw)!=SIZE: raise ValueError('Bad raw RGB565 length')
    rgb = bytearray()
    for (w,) in struct.iter_unpack('<H',raw):
        r,g,b=(w>>11)&31,(w>>5)&63,w&31
        rgb.extend(((r<<3)|(r>>2),(g<<2)|(g>>4),(b<<3)|(b>>2)))
    return Image.frombytes('RGB',(WIDTH,HEIGHT),bytes(rgb))

def header(raw):
    words = [w for (w,) in struct.iter_unpack('<H',raw)]
    if len(raw)!=SIZE: raise ValueError('Bad raw RGB565 length')
    lines = ['/* Generated from an opaque 240x135 PNG. */', '#pragma once', '#include <stdint.h>',
             f'#define AY_RASTER_WIDTH {WIDTH}', f'#define AY_RASTER_HEIGHT {HEIGHT}',
             'static const uint16_t ay_raster_pixels[AY_RASTER_WIDTH * AY_RASTER_HEIGHT] = {']
    for i in range(0,len(words),12):
        lines.append('    ' + ', '.join(f'0x{w:04x}' for w in words[i:i+12]) + ',')
    return '\n'.join(lines+['};',''])

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('png',type=Path)
    p.add_argument('rgb565',type=Path)
    p.add_argument('--preview',type=Path,help='Optional local RGB888 round-trip PNG')
    p.add_argument('--header',type=Path,help='Optional #135 compatible C framebuffer array')
    a=p.parse_args()
    out=[p.resolve() for p in [a.rgb565,a.preview,a.header] if p]
    if len(set(out+[a.png.resolve()])) != len(out)+1 or any(p.exists() for p in out):
        p.error('choose new, distinct output path(s)')
    try: raw=encode(a.png)
    except (ValueError,OSError) as e: p.error(str(e))
    with a.rgb565.open('xb') as f: f.write(raw)
    if a.preview:
        with a.preview.open('xb') as f: preview(raw).save(f,format='PNG')
    if a.header:
        with a.header.open('x',encoding='ascii',newline='\n') as f: f.write(header(raw))
    print(f'{len(raw)} bytes ({WIDTH}×{HEIGHT}, RGB565 LE)')
if __name__=='__main__': main()
