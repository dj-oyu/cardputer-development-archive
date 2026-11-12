#ifndef DOT8_CORPUS_H
#define DOT8_CORPUS_H
#include "checked.h"
#include "control.h"
typedef struct { uint32_t before[4]; dot8_input value; uint32_t after[4]; } GuardInput;
typedef struct { uint32_t before[4]; dot8_packed value; uint32_t after[4]; } GuardPacked;
typedef struct { _Alignas(16) uint32_t before[4]; int32_t value[8]; uint32_t after[4]; } GuardOutput;
typedef struct { GuardInput n,d; GuardPacked packed; GuardOutput out; int32_t expected[8]; } Dot8Workspace;
typedef struct { Dot8Progress progress; uint32_t seed; } Dot8Suite;
typedef bool (*Dot8CheckedFn)(const dot8_input *,const dot8_input *,dot8_packed *,int32_t *);
void dot8_suite_init(Dot8Suite *);
bool dot8_suite_step(Dot8Workspace *,Dot8Suite *,Dot8CheckedFn);
#endif
