"""Run the private body guest in bounded socket-free QEMU, never physical hardware."""
import argparse,hashlib,json,subprocess,time
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('--build',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--qemu',type=Path,required=True)
p.add_argument('--seconds',type=int,default=300)
a=p.parse_args();b=a.build.resolve();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
files=json.loads((b/'flasher_args.json').read_text())['flash_files']
flash=bytearray(b'\xff'*(8*1024*1024));hashes={}
for offset,name in files.items():
 data=(b/name).read_bytes();start=int(offset,0)
 assert 0<=start<=len(flash)-len(data)
 flash[start:start+len(data)]=data;hashes[name]=hashlib.sha256(data).hexdigest()
image=out/'virtual-flash.bin';image.write_bytes(flash);log=out/'uart.log';stderr=out/'qemu-stderr.log'
command=[str(a.qemu.resolve()),'-machine','esp32s3','-display','none','-monitor','none','-nic','none','-snapshot','-drive',f'file={image},if=mtd,format=raw','-serial',f'file:{log}','-icount','shift=2']
started=time.monotonic();reason='timeout'
with stderr.open('wb') as stream:
 proc=subprocess.Popen(command,stdout=stream,stderr=stream)
 try:
  while time.monotonic()-started<a.seconds:
   text=log.read_text(errors='replace') if log.exists() else ''
   if 'FOX_BODY_QEMU_DONE' in text:reason='completed';break
   if any(x in text for x in ['Guru Meditation','abort() was called','assert failed','FOX_BODY_ERROR']):reason='guest_failure';break
   if proc.poll() is not None:reason='process_exit';break
   time.sleep(.25)
 finally:
  if proc.poll() is None:
   proc.terminate()
   try:proc.wait(timeout=5)
   except subprocess.TimeoutExpired:proc.kill();proc.wait()
meta={'command':command,'reason':reason,'timeout_seconds':a.seconds,'elapsed_host_seconds':time.monotonic()-started,'returncode_after_stop':proc.returncode,'physical_device':False,'profile':'private_2kv2_body_native_raster_only','qemu_version':subprocess.check_output([str(a.qemu),'--version'],text=True),'build_segments_sha256':hashes,'sha256':{x.name:hashlib.sha256(x.read_bytes()).hexdigest() for x in [image,log,b/'fox_body_qemu.elf',b/'sdkconfig'] if x.exists()}}
(out/'run-metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(json.dumps(meta,indent=2));raise SystemExit(0 if reason=='completed' else 1)
