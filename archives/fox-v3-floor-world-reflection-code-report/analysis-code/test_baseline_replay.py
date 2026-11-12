"""Read-only replay of completed prior floor-ON scores; not new experiment scoring."""
import sys
sys.dont_write_bytecode = True
import json
from pathlib import Path
import score_world as N

pins = N.Pins()
prior = N.prior_admission(pins)
a = N.O.Admission(N.W, N.D.OLD / 'TRUST_INPUTS.json', N.D.OLD_TRUST_SHA,
                  N.D.OLD / 'ALL_OUTPUT_PINS.json', N.D.OLD_OUTPUT_SHA)
s, ref = N.O.load_formal(a)
domains, summary = N.O.fixed_domains(a, ref)
N.require(summary == N.read_json(N.PRIOR_ANALYSIS / 'FIXED_DOMAINS.json'), 'prior fixed-domain parity')
rows = N.D.ten_rows(N.read_json(N.PRIOR / 'composed-on/COMPLETED.json')['frames'])
frames = {}
for (v, c), row in rows.items():
    frames[(v, c)] = {'rgb': N.O.read_rgb(N.PRIOR / 'composed-on' / row['outputs']['agx']['path']),
                      'depth': N.O.read_depth(Path(row['characterDepthPath'])),
                      'row': {'view': v, 'case': c, 'metadata': {'oldBaselineReplayOnly': True}}}
manifest = {'schemaVersion': 'prior-complete-only-replay-test', 'candidate': {'label': 'prior-floor-ON-only-replay'}, 'frames': [f['row'] for f in frames.values()]}
formal, _ = s.score(ref, {'frames': frames, 'manifest': manifest,
                        'manifestSHA256': N.O.sha_bytes(N.O.canonical(manifest))})
N.require(N.numeric(formal) == N.numeric(prior['FORMAL_ON.json']), 'prior formal numeric parity failed')
a.recheck()
pins.recheck()
print('PRIOR_ONLY_ALL10_FORMAL_AND_FIXED_DOMAIN_REPLAY_PASS; no new experiment scoring or rendering')
