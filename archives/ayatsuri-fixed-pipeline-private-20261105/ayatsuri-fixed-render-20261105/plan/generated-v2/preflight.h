#ifndef AA_PREFLIGHT_GENERATED_H
#define AA_PREFLIGHT_GENERATED_H
#include <stdint.h>
typedef struct {uint64_t snapshot;uint16_t hits[4];} aa_preflight_entry;
static const aa_preflight_entry aa_preflight_rows[20]={
{UINT64_C(0x017e6671f56c3bd8),{1922,1920,1933,1903}},
{UINT64_C(0xfcd030d99428ed59),{1922,1920,1933,1903}},
{UINT64_C(0x46470de7377f825d),{1922,1920,1933,1903}},
};
static const uint16_t aa_preflight_targets[20]={2385,2385,2385};
_Static_assert(sizeof aa_preflight_rows+sizeof aa_preflight_targets==360,"preflight RO accounting");
static const aa_preflight_entry *aa_preflight_lookup(uint64_t hash){for(unsigned i=0;i<20;i++)if(aa_preflight_rows[i].snapshot==hash)return aa_preflight_rows+i;return 0;}
static int aa_preflight_actual_matches(const aa_preflight_entry*p,const uint64_t hits[4],uint64_t targets){if(!p)return 0;unsigned i=(unsigned)(p-aa_preflight_rows);if(i>=20||targets!=aa_preflight_targets[i])return 0;for(unsigned j=0;j<4;j++)if(hits[j]!=p->hits[j])return 0;return 1;}
#endif
