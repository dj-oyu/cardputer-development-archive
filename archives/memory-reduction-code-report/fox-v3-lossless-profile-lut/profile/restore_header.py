"""Recreate only the private immutable data header from the saved encoded blob."""
from pathlib import Path
import argparse,hashlib,json
r=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--blob',type=Path,default=r.parent/'research/private/agx_cube4_rice.bin');p.add_argument('--output',type=Path,default=r/'private/profile_data.h');args=p.parse_args()
m=json.loads((r/'PROFILE_CONSTANTS.json').read_text());data=args.blob.read_bytes()
assert len(data)==m['encodedBlobBytes'] and hashlib.sha256(data).hexdigest()==m['encodedBlobSHA256']
constants=''.join('#define '+k+' '+v+'\n' for k,v in m['literalStrings'].items())
args.output.parent.mkdir(parents=True,exist_ok=True)
args.output.write_text(constants+'#include <stdint.h>\nstatic const uint8_t agx_encoded[]={\n'+''.join(','.join(map(str,data[i:i+32]))+',\n' for i in range(0,len(data),32))+'};\n')
print(args.output)
