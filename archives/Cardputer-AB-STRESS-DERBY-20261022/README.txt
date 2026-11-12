Cardputer real-device A/B evidence, 2026-10-22
A = 5b47d28ce77cfe0778be15dab903c58da3eed330 + the same app-control delta as B.
B = 32f1a735aac80c4335a5b88f22dc39fa686422a4 (PR46 10fbed31 + PR47 app control).
Both use IDF 6.0.1, GCC 15.2.0, DMA ON, ccache OFF, matching sdkconfig and app sources.
Three fresh guests in one boot per variant. STRESS: L1/L2/L3 20 seconds each;
accept between levels, normal STOP/CLOSE. DERBY: 20-second normal demo, no input.
All A was measured before all B; no randomized crossover, cold boot timing or confidence interval.
Heap fragmentation and background state differ between boots and repeated guests.
STRESS pressure trimming/OOM makes allocation work adaptive rather than fixed;
L3 pressure events/trims and OOM counts differ between A and B.
These are whole-PR46-bundle observations, not an isolated function-header effect.
turn/render/send: median of emitted 30-draw-window averages, then median of 3 trial medians.
They are not per-frame p50/p95. STRESS peak is retained chunk count, not heap byte peak.
Null means not collected, never zero substituted. No actual heap high-water mark was collected.
JS and heap values are snapshots after source loading; startup ACK includes host/protocol overhead.
STRESS compile time is uncollected. DERBY compile_us is per named module;
the 6-module compile sum excludes entry compilation. Module run_us must not be summed:
play includes nested module execution/compilation.
DERBY is NOT a valid fixed benchmark: raw markers show reps=0 valid=0 quality=2 independent=0.
DERBY animation phase/work is not seeded/fixed; treat paint times as descriptive only.
Raw .jsonl files are official broker MCP responses, .log files readable device-only lines.
No direct serial reader was used. All twelve benchmark trials have zero cursor gaps,
expiry, control drops and log drops. Successful transport does not verify physical LCD appearance.
Historical flash failures remain separate; HELLO subsequently verified B's operational identity.
Firmware-reported identity is unattested; flash readback verifies the written segment bytes separately.
Original firmware-only recovery and original configuration restoration are recorded separately.
Firmware-only restore cannot promise to reverse saved-data changes made by an application.
No credentials, private configuration, process environments or history database are included.
