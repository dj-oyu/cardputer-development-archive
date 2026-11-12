#ifndef DOT8_CONTROL_H
#define DOT8_CONTROL_H
#include <stdint.h>
#include <stdbool.h>
#define DOT8_CASES 564u
#define DOT8_DEADLINE_US INT64_C(2000000)
#define DOT8_BOOT_MAGIC UINT32_C(0x44385432)
typedef enum { DOT8_RUNNING=0,DOT8_PASS,DOT8_FAIL,DOT8_TIMEOUT,DOT8_SETUP_ERROR } Dot8Status;
typedef enum { DOT8_NO_ERROR=0,DOT8_NUMERIC,DOT8_GUARD,DOT8_PADDING,DOT8_REJECTION,DOT8_DEADLINE,DOT8_CREATE_SUPERVISOR,DOT8_CREATE_WORKER,DOT8_REENTRY,DOT8_COUNTS } Dot8Error;
typedef struct { uint32_t passed,failed,invalid_rejected,next_case; Dot8Error error; bool done; } Dot8Progress;
typedef struct { Dot8Status status; Dot8Error error; int32_t first_case; uint32_t passed,failed,invalid_rejected; int64_t elapsed_us,event_us; } Dot8Terminal;
/* Caller serializes all access. Target uses same-core tasks and short critical
 * sections; no critical section contains raw, console IO or task suspension. */
typedef struct { int64_t start_us,event_at; Dot8Progress progress; Dot8Error pending; bool pending_done,terminal,emitted; Dot8Terminal result; } Dot8Control;
void dot8_control_start(Dot8Control *,int64_t now);
bool dot8_control_permit(Dot8Control *,int64_t now);
void dot8_control_progress(Dot8Control *,const Dot8Progress *,int64_t now);
bool dot8_control_ready(const Dot8Control *,int64_t now);
bool dot8_control_commit(Dot8Control *,int64_t now);
bool dot8_control_setup_error(Dot8Control *,Dot8Error,int64_t now);
bool dot8_control_take(Dot8Control *,Dot8Terminal *);
bool dot8_claim_boot(volatile uint32_t guard[2]);
const char *dot8_status_name(Dot8Status);
#endif
