/* Exact source float socket values; immutable workload binding, no image values. */
#ifndef FLOOR_INPUT_H
#define FLOOR_INPUT_H
typedef struct {uint64_t snapshot; unsigned case_index; uint64_t shaders,hits;} floor_input_row;
static const double floor_rho[5][3]={
{0x1.ae147a0000000p-1,0x1.8f5c280000000p-1,0x1.4ccccc0000000p-1},
{0x1.ae147a0000000p-1,0x1.8f5c280000000p-1,0x1.4ccccc0000000p-1},
{0x1.ae147a0000000p-1,0x1.8f5c280000000p-1,0x1.4ccccc0000000p-1},
{0x1.ae147a0000000p-1,0x1.8f5c280000000p-1,0x1.4ccccc0000000p-1},
{0x1.020c4a0000000p-1,0x1.df3b640000000p-2,0x1.8f5c280000000p-2},
};
static const floor_input_row floor_input_rows[20]={
{UINT64_C(0x017e6671f56c3bd8),0,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0xfcd030d99428ed59),0,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0x46470de7377f825d),0,UINT64_C(17070),UINT64_C(70341)},
};
static const floor_input_row *floor_input_lookup(uint64_t hash){for(unsigned i=0;i<20;i++)if(floor_input_rows[i].snapshot==hash)return floor_input_rows+i;return NULL;}
#endif
