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
{UINT64_C(0x5a13ce5ed58ad33e),0,UINT64_C(16930),UINT64_C(69822)},
{UINT64_C(0xca2671fb76b7a28c),0,UINT64_C(17001),UINT64_C(71667)},
{UINT64_C(0x16a5cafb1e38eb8a),0,UINT64_C(17241),UINT64_C(70443)},
{UINT64_C(0xe9b9aaa945a95ee1),1,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0xed2c24b19b7b760f),1,UINT64_C(16930),UINT64_C(69822)},
{UINT64_C(0x3f377d53c4178e6d),1,UINT64_C(17001),UINT64_C(71667)},
{UINT64_C(0xafc8510bf97b8917),1,UINT64_C(17241),UINT64_C(70443)},
{UINT64_C(0x750e5cf096aa40fd),2,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0x00593adac8e78aab),2,UINT64_C(16930),UINT64_C(69822)},
{UINT64_C(0xcb568337d9bcec59),2,UINT64_C(17001),UINT64_C(71667)},
{UINT64_C(0x4461ebdd1ccceb6b),2,UINT64_C(17241),UINT64_C(70443)},
{UINT64_C(0xfb48014ff3fcf9c8),3,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0xdce979160c5b88ae),3,UINT64_C(16930),UINT64_C(69822)},
{UINT64_C(0x2b169d60dffce95c),3,UINT64_C(17001),UINT64_C(71667)},
{UINT64_C(0x81c2d4aca5a4a09a),3,UINT64_C(17241),UINT64_C(70443)},
{UINT64_C(0x54445c4c61aa80a4),4,UINT64_C(17070),UINT64_C(70342)},
{UINT64_C(0xab99985faeeb4f82),4,UINT64_C(16930),UINT64_C(69822)},
{UINT64_C(0x9fa01b79d8cc3e60),4,UINT64_C(17001),UINT64_C(71667)},
{UINT64_C(0xe9dbf963029f2066),4,UINT64_C(17241),UINT64_C(70443)},
};
static const floor_input_row *floor_input_lookup(uint64_t hash){for(unsigned i=0;i<20;i++)if(floor_input_rows[i].snapshot==hash)return floor_input_rows+i;return NULL;}
#endif
