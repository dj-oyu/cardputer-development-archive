#include "ksn_runtime.c"
char budget_runtime_block[sizeof(runtime_block)];
char budget_core[sizeof(ksn_core)];
char budget_commands[2*sizeof(ksn_core_command_block)];
char budget_text[2*sizeof(ksn_core_text_block)];
char budget_cache[KSN_CACHE_RESERVED_BYTES];
char budget_animations[2*sizeof(ksn_core_animation_block)];
