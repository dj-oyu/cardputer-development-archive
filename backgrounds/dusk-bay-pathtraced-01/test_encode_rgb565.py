from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from PIL import Image
from encode_rgb565 import encode, preview

class Raw565Test(unittest.TestCase):
    def test_asymmetric_raster_and_color_boundaries(self):
        with TemporaryDirectory() as tmp:
            p=Path(tmp)/'input.png'
            im=Image.new('RGB',(240,135))
            cases={(0,0):((255,0,0),b'\x00\xf8'),(239,0):((0,255,0),b'\xe0\x07'),
                   (0,1):((0,0,255),b'\x1f\x00'),(239,134):((255,255,255),b'\xff\xff'),
                   (121,68):((8,4,8),b'\x21\x08'),(122,68):((7,3,7),b'\x00\x00')}
            for xy,(rgb,_) in cases.items(): im.putpixel(xy,rgb)
            im.save(p)
            raw=encode(p)
            self.assertEqual(len(raw),64800)
            for (x,y),(_,data) in cases.items():
                i=2*(y*240+x)
                self.assertEqual(raw[i:i+2],data)
            decoded=preview(raw)
            self.assertEqual(decoded.size,im.size)
            for xy in [(0,0),(239,0),(0,1),(239,134)]: self.assertEqual(decoded.getpixel(xy),im.getpixel(xy))
    def test_reject_alpha_and_wrong_dimensions(self):
        with TemporaryDirectory() as tmp:
            p=Path(tmp)/'input.png'
            im=Image.new('RGBA',(240,135),(0,0,0,255)); im.putpixel((239,134),(255,0,0,254));im.save(p)
            with self.assertRaisesRegex(ValueError,'Transparent'): encode(p)
            im.putpixel((239,134),(255,0,0,255));im.save(p)
            self.assertEqual(encode(p)[-2:],b'\x00\xf8')
            Image.new('RGB',(135,240)).save(p)
            with self.assertRaisesRegex(ValueError,'240x135'): encode(p)
if __name__=='__main__': unittest.main()
