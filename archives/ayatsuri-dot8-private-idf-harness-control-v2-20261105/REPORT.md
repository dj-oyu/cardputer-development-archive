# Private dot8 control v2 — compile/link and host model evidence

RESULT: final ESP-IDF compile/link PASS; HOST control/fault-injection PASS. No target execution, hardware connection, flash, monitor, reset, public checkout edit, commit, push or firmware restore. This is NOT production/hardware safety acceptance. New private derivative: /workspace/private-dot8-controlled-harness-20261105. Prior /workspace/private-dot8-idf-harness-20261105, its /workspace/build artifacts and prior Library version0 are preserved.

## Frozen algorithm / build identity

main/dot8.c SHA256 d1d321916966b3632a258aad130356459dd502123819ea8b2b0c66fced41b09d; dot8.h 6c187ebf6fe5847b00e16eacc5942bd57d34294e8df52afeddc1f9a06480c0de. checked.c/h also reused unchanged. Raw is a separate -fno-lto translation unit; no .gnu.lto sections in its ordinary object. Its50B text is byte-identical to the retained prior object (old/new-raw-code.bin). Final raw14PIE operations and windowed ABI/frame32 unchanged. Final linked CP handler contains QACC_H/L_0..4 and Q0/Q1 full stores/loads. All disassemblies, symbols and link map included.

Emitted build field c7d748404001436e is a source fingerprint of listed component source/header/CMake files plus sdkconfig.defaults, verified independently by collect.py. It is not an ELF hash. CMAKE_CONFIGURE_DEPENDS now tracks those inputs; incremental stale fingerprint was found during development and corrected before final collection. Exact final ELF/BIN/config hashes below and in the manifest are authoritative build evidence.

Existing IDF v6.0.1 / Xtensa GCC15.2.0 esp-15.2.0_20251204; GNU23, final componentO2, contraction off, longcalls/picolibc/disabled memcpy builtins and established warnings retained. No warning relaxation. Actual argv/response/spec and SDK source hashes included. Command:
```
source /workspace/.setup/activate.sh
source /workspace/.setup/esp-idf/export.sh
IDF_COMPONENT_MANAGER=0 idf.py -C /workspace/private-dot8-controlled-harness-20261105 -B /workspace/private-dot8-controlled-harness-20261105/build -D IDF_TARGET=esp32s3 build size
```
No installs. The controlled build uses its own absolute builddir. The original build-only evidence was not overwritten.

## Observable one-shot protocol

Console is IDF supported stdio/UART0 default at115200 baud. Exactly one normal START output attempt and at most one terminal output attempt (one terminal when functioning console/scheduler permits), each newline with prefix `DOT8 ` and a JSON object. No per-case logging. Normal harness protocol is2 lines, each under512B for the fixed identifiers and integer field widths; other IDF error/panic output is not counted as protocol. No byte-delivery guarantee under console loss/blocking/power failure.

START fields: event=START,harness=dot8-control-v2,build,cases=564,deadline_us=2000000.
Terminal event: PASS/FAIL/TIMEOUT/SETUP_ERROR; same identity/cases, passed/failed/invalid counts, first_error enum, first_case zero-based (-1 for PASS/setup), elapsed_us (supervisor commit observation elapsed), event_us (pending worker publication elapsed, or deadline observation). Error enum:0none,1numeric,2guard,3padding,4transactional rejection,5deadline,6supervisor creation,7worker creation,8warm-boot reentry suppressed,9incomplete count gate. PASS requires564passed,0failed,48invalid and next_case564.

app_main emits START, claims a two-word RTC noinit one-shot latch, creates static normal supervisor(priority6) and worker(priority5), both core0-pinned. Worker waits for a private start notification. Supervisor is armed immediately once it exists, including remaining setup; no start-notification dependency delays its deadline monitoring. app_main issues worker start only after setup and checking terminal state. Null returns from task creation produce SETUP_ERROR, without configASSERT/reboot. A failure inside the kernel API itself is a panic/lockup category, not a returned setup error.

Worker executes same fixed corpus incrementally and stops at first detected failure, then publishes pending status and parks; no next case/raw call. First error priority within a case is numerical result, outerguard, then padding; invalid directions have rejection/transaction check. It checks deadline/stop before each case, and delays one tick every16successful cases so idle/system tasks can run. This pacing is not a benchmark. The supervisor independently uses esp_timer_get_time and polls at10ms (1tick with100Hz config), or wakes on notification. It detects a normal-task worker that stalls without yielding, as long as timer interrupts/scheduler and supervisor scheduling remain functional.

## Stop linearization / races

All controller publication/snapshot accesses use short same-core critical sections. No critical section spans raw, task suspension or console IO. When ready, higher-priority same-core supervisor snapshots handles, suspends worker BEFORE committing terminal. If still in setup it also suspends setup task before timeout commit. A created-but-not-yet-published worker cannot have received its start notification and therefore cannot enter raw. Same-core pinning avoids reliance on an asynchronous cross-core suspend handshake. FreeRTOS tasks.c1964ff removes ready/delayed task and places it in suspended list; source excerpt retained. No code resumes worker/setup/supervisor after stop.

A raw invocation already in flight may be suspended mid-instruction sequence; on timeout its partial buffers are not accepted as a completed case or PASS. No subsequent raw call occurs after terminal commit under this pinned-task contract. It is a stop, not cancellation with buffer rollback. The supervisor copies a committed immutable result; the public volatile dot8_terminal_result is written once before output. An emitted latch prevents repeated terminal output attempts. Later progress/commit/setup operations cannot change committed state. No resume/retry API is exposed.

Deadline is absolute2,000,000us from control initialization (before START/setup). A worker completion/failure publication strictly BEFORE deadline wins even when observed later; exact deadline equality or later is TIMEOUT. Once supervisor commits timeout, later completion cannot overwrite it. Timing boundary is publication, not an inferred end of arithmetic. Reporting can be later than2s+one poll due scheduling/console delays; this is not a hard real-time deadline proof.

Terminal means tasks remain stopped, no automatic test retry, reboot, flash write, NVS write or restore. Firmware restoration remains a separate authorized broker operation; ownership/capacity/recovery blockers are not bypassed by this app. No restoration implementation is present.

## Panic / reset limits and config changes

Configured panic changed PRINT_REBOOT -> PRINT_HALT. Bootloader/default/maximum log level INFO->ERROR to bound ordinary noise; reboot-delay key disappears under halt policy. Full semantic differences are evidence/sdkconfig-diff.json. All other settings follow the prior minimal standalone build. DIO80MHz8MiB, standard factory offset0x10000 size1MiB, NVS0x9000/0x6000 and phy0xf000/0x1000; not the current user's firmware layout. FPU-in-ISR OFF, no PSRAM component or custom CPENABLE/ISR code. Standard watchdog/brownout/hardware reset causes are not disabled or guaranteed preventable.

RTC noinit two-word magic/inverse latch suppresses a retained warm-reset rerun with START+SETUP_ERROR/REENTRY before any worker/raw is created. It does not persist across all power loss/reset classes or RTC corruption, and is not an authorized recovery/reset mechanism. A fresh boot with no valid latch can begin one new run. No flash/NVS persistence is used. Panic/hardware watchdog, masked interrupts, CPU lockup, higher-priority system starvation, unavailable scheduler/timer or console loss can prevent a terminal line; absence of terminal is NOT PASS and does not authorize reboot/retry/restore. PRINT_HALT is evidence preservation policy, not a guarantee against all resets. Task-creation failure before a supervisor exists can be reported on a returned failure; a hang before supervisor creation or START stuck in console cannot be supervised by that not-yet-created task.

## HOST validation (not target execution)

ASan/UBSan build with -std=c11 -O2 -Wall -Wextra -Werror. Same checked wrapper, unchanged scalar/unpack, incremental corpus and pure controller. Explicit raw packing stub only; no PIE numeric acceptance. Normal564case behavior gives516raw stub calls and48invalid rejection cases. Old retained corpus versus new incremental corpus has identical sequence digest for all516valid n/d inputs: FNV64 698dff8422906ae5, plus source inspection of same48invalid positions/endpoints. This is reproducibility evidence, not a cryptographic proof of mathematical equivalence.

Fault tests PASS:
- numerical first-failure indices0,1,3,4,257,515; invalid rejection failures516,540,563; guard514; padding513:11conditions, stop immediately, no extra raw calls even with repeated step/permit attempts.
- stalled-worker/supervisor timeout model at0,1,15,515,516,563:6conditions. This models an independently scheduled supervisor; it does not run FreeRTOS.
- completion/failure publication at deadline-1/deadline/deadline+1 and supervisor-first late publication:7boundary orderings; equality TIMEOUT; earlier publication wins; late progress ignored.
- setup returned failures(supervisor,worker) and retained reentry:3models, zero raw calls and one terminal take.
- repeated20commit/take/progress/setup attempts per stop leave frozen controller/result unchanged; terminal take exactly once; zero raw-after-stop. Incomplete completion counts cannot PASS. RTC latch claim/reentry/corruption model checked.

Host does not execute actual vTaskSuspend/notification/kernel scheduling, priority preemption, UART delivery, panic/watchdog/reset behavior, clock/tick deadlines, true task-create failure, CP save or PIE arithmetic. Those remain target-unexecuted. Tests do not establish concurrency safety against arbitrary external task resume/affinity/priority/CPENABLE changes; the minimal harness owns these private handles and makes none.

Reproduce host control test:
```
cc -std=c11 -O2 -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer -DDOT8_HOST_LOGIC_ONLY=1 -Imain main/dot8.c main/checked.c main/corpus.c main/control.c host_control_test.c -o host_control_test
./host_control_test
```

## Final linked budgets and audit

Worker and supervisor static aligned stacks4096B EACH (8192total), StaticTask_t100B EACH, workspace352B, suite28B, control88B (includes terminal40), committed volatile terminal40B, setup_done1B, three handles12B, harness mux8B, RTC latch8B. Linker padding separate. Each task's CP reservation XT_CP_SIZE316B rounds to320B from aligned stack and is INCLUDED in that4096B; CP3's208B is included, not an extra BSS allocation. Both tasks get the normal OS CP reservation even though only worker invokes PIE. TLS/register-window/initial task context, printf/libc and interrupts need additional stack; no runtime fit/whole peak is claimed.

Own .su frames: worker32,supervisor32,app_main64,emit_terminal112,suite_step144,checked80,raw32,control_commit48,other helpers32/48. These are not summed into total peak. See all .su files.

Final BIN128528B SHA256 64870b574455011a939fc514c8d71609004cd479512882b3feeb740452e690af. ELF3111648B SHA256 86b87a57092436d9a8c81cc86ad34c078ac32378259b8283129178bf7e821b07. Partition table3072B SHA256 7f00b6c042a89b15b0cac534f82ed988caf29278ff5700b0c511eb1b5bb7c820. App slot remaining920048B. DIRAM47865B (text25287,data11346,bss11232), IDF static remaining293895B. Flash code50048B, data25304B. Separate IRAM16384B fully accounted by text15356+vectors1028. Decreased BIN versus old build is not performance evidence (log configuration changed).

Actual compile-TU audit finds explicit CPENABLE only in standard IDF port/context/vector sources and PIE only original dot8.c. Named linked CP-handler confirms full save/restore. No PIE in application startup/kernel/ISR or manual CPENABLE was added. Audit does not cover every transitive macro, ROM/prebuilt binary, dynamic handler or future integration. Full objdump literal-pool pseudo-instruction false positives are not used as a global PIE count.

Remaining real-device gates: separately authorized hardware owner/recovery/capacity; minimal layout/security compatibility with actual device; protocol START/terminal delivery; all raw lane/packing/scalar/guard results; same-core supervisor timeout/suspension with stalled worker; first-failure stop; CP task preemption/other CP3 use/ISR policy; actual stack high-water/heap; warm-reset latch and panic outcomes; cycles only in a distinct performance experiment. No current blocker to this compile/link task, no claim that these gates passed.
