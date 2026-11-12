from pathlib import Path
import hashlib,json,shutil,subprocess
P=Path(__file__).resolve().parent;src=Path('/usr/share/blender/datafiles/colormanagement');dst=P/'official-colormanagement';shutil.copytree(src,dst,dirs_exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
files={str(x.relative_to(src)):sha(x) for x in sorted(src.rglob('*')) if x.is_file()}
for name in ['copyright']:shutil.copy2('/usr/share/doc/blender/'+name,P/('installed-blender-'+name+'.txt'))
manifest=dict(installed_config=str(src/'config.ocio'),config_sha256=sha(src/'config.ocio'),all_dependency_sha256=files,blender_path='/usr/bin/blender',blender_sha256=sha(Path('/usr/bin/blender')),blender_version=subprocess.check_output(['/usr/bin/blender','--version'],text=True),source_settings_sha256=sha(P.parent.parent/'fox-reference-uncertainty-v3/input/source-settings.json'),license=dict(referenced='ocio-license.txt',status='MISSING in installed distribution; publication not cleared',available_generic_documents=['/usr/share/doc/blender/copyright','/usr/share/doc/blender/license'],no_license_inferred=True),generation='Blender generated float image Linear Rec.709 -> image.save_render PNG16; synthetic pixels only; scene sRGB/AgX/Medium High Contrast, exposure0 gamma1 dither0',e_gamut_negative_lattice='Not applicable: lattice is nonnegative scene-linear Rec709, no inverse gamut transform used. No generator clipping of negative lattice nodes is possible because there are none.',private_only=True)
(P/'provenance.json').write_text(json.dumps(manifest,indent=2))
(P/'sha256-manifest.json').write_text(json.dumps({str(x.relative_to(P)):sha(x) for x in sorted(P.rglob('*')) if x.is_file() and x.name!='sha256-manifest.json'},indent=2))
