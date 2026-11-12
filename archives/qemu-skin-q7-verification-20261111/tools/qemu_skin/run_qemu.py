"""Run an already built image only in bounded, socket-free QEMU (never flash hardware)."""
import argparse,subprocess,time,json,hashlib
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--qemu',required=True);p.add_argument('--build',type=Path,required=True);p.add_argument('--seconds',type=int,default=180);a=p.parse_args();b=a.build.resolve()
flash=b/'virtual-flash.bin';log=b/'uart.log';err=b/'qemu-stderr.log'
subprocess.run(['python','-m','esptool','--chip','esp32s3','merge-bin','--fill-flash-size','8MB','-o',str(flash),'@flash_args'],cwd=b,check=True)
command=[a.qemu,'-machine','esp32s3','-display','none','-monitor','none','-nic','none','-snapshot','-drive',f'file={flash},if=mtd,format=raw','-serial',f'file:{log}','-icount','shift=2']
log.write_bytes(b'')
start=time.monotonic();reason='timeout'
with err.open('wb') as e:
 proc=subprocess.Popen(command,stdout=e,stderr=e)
 try:
  while time.monotonic()-start<a.seconds:
   s=log.read_text(errors='replace') if log.exists() else ''
   if 'QSKIN_DONE' in s:reason='completed';break
   if any(x in s for x in ['Guru Meditation','abort() was called','QSCENE_ERROR','assert failed']):reason='guest_failure';break
   if proc.poll() is not None:reason='process_exit';break
   time.sleep(.25)
 finally:
  if proc.poll() is None:
   proc.terminate()
   try:proc.wait(timeout=5)
   except subprocess.TimeoutExpired:proc.kill();proc.wait()
metadata={'command':command,'qemu_version':subprocess.check_output([a.qemu,'--version'],text=True),'reason':reason,'elapsed_host_seconds':time.monotonic()-start,'returncode':proc.returncode,'sha256':{x.name:hashlib.sha256(x.read_bytes()).hexdigest() for x in [flash,b/'qemu_scene.elf',b/'sdkconfig',log] if x.exists()}}
(b/'run-metadata.json').write_text(json.dumps(metadata,indent=2)+'\n');print(json.dumps(metadata,indent=2))
raise SystemExit(0 if reason=='completed' else 1)
