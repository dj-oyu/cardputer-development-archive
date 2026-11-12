#include "lease.h"
char budget_pool[sizeof(lease_pool)];
char budget_slot[sizeof(lease_slot)];
char budget_reader[sizeof(lease_reader)];
char budget_two_pools[2*(sizeof(lease_pool)+2*sizeof(lease_slot)+4*sizeof(lease_reader))];
