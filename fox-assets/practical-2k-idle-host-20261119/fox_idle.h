#ifndef FOX_IDLE_H
#define FOX_IDLE_H
#include "ayatsuri/ayatsuri_model.h"

enum { FOX_MODEL_NODES=187, FOX_HEAD_GROUPS=11, FOX_MARKS=3, FOX_BREATH_GROUPS=3, FOX_CONTROLLED=17 };
/* Mutable, owned by one caller. Bind fresh per native actor, either yaw anchor.
 * Incomplete app integration: apply before model evaluate, then submit/commit normally. */
typedef struct {
    const ayatsuri_model_instance *actor;
    const void *owner;
    uint32_t generation;
    uint16_t ids[FOX_CONTROLLED];
    uint16_t mark_mesh[12], count;
    float base[FOX_CONTROLLED][9], pivot[3], neck_rotation[9];
    float pose[FOX_MODEL_NODES][9];
    uint8_t dirty[FOX_MODEL_NODES];
} fox_idle;
typedef struct { float breath, yaw_rad; } fox_idle_values;
fox_idle_values fox_idle_sample(uint64_t time_ms, int anchor_deg);
ayatsuri_model_status fox_idle_bind(fox_idle *s, ayatsuri_model_instance *instance,
                                   const void *owner, uint32_t gen);
ayatsuri_model_status fox_idle_apply(fox_idle *s, ayatsuri_model_instance *instance,
                                    const void *owner, uint32_t gen,
                                    uint64_t time_ms, int anchor_deg);
/* Select exactly one optional mark (0 sweat, 1 confusion, 2 anger), or -1 to hide all. */
ayatsuri_model_status fox_idle_mark(const fox_idle *s, ayatsuri_model_instance *instance,
                                   const void *owner, uint32_t gen, int selection);
#endif
