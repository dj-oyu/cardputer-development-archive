#include "lease_freertos.h"
char budget_mutex[sizeof(lease_mutex)];
void budget_lock_smoke(lease_mutex *m){lease_mutex_init(m);lease_mutex_lock(m);lease_mutex_unlock(m);}
