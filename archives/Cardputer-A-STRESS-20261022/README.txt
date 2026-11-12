Cardputer A STRESS measurements — 2026-10-22
A = 5b47d28ce77cfe0778be15dab903c58da3eed330 plus the same app-control changes as candidate B.
Three fresh-guest runs in the same device boot. Each run: L1 20 s, accept, L2 20 s, accept, L3 20 s, STOP/CLOSE.
IDF 6.0.1, DMA ON, compiler cache OFF. This measures the whole PR46 bundle, not a header-only effect.
The .log files contain actual device log lines delivered by broker read_app_events and saved by the common MCP client.
They are not a second direct serial reader. All three runs: no log/control drops, gaps or expiry.
turn/render/send are medians of emitted 30-draw-window averages, not per-frame p50/p95.
peak in STRESS lines is retained chunk count, not heap bytes. Null metrics were not collected.
Compile-time null in the STRESS summary means no independent compile metric was extracted for this app.
Successful app transport does not certify physical LCD appearance or a paired A/B improvement.
The original flash job's boot verification failure remains recorded separately.
No credentials or private configuration files are included.
