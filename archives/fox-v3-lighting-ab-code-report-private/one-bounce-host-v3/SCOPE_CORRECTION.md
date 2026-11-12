# Frozen001 inherited prose correction

The run001 config mapping concatenates older phrases "no AgX/visibility" and "no ground occluder/world visibility" before later enabled-feature clauses. Those old phrases are stale for enabled features. The actual boolean/mode echoes, source and source hashes govern:
- all3 arms have direct character BVH visibility and pixel lighting ON, AgX OFF;
- OFF alone retains unoccluded world;
- WORLD_VISIBLE and ONE_BOUNCE replace it with cosine miss-world;
- ONE_BOUNCE alone adds a single diffuse reflection.
All omit ground transport, emission, higher bounces and specular. The original frozen configs/results are not rewritten. No claimed Pocket failed-present integration: render failure leaves owned snapshots alive, and the host caller discards partial bands. Mutation epochs do not detect reevaluation alone; synchronous copy before reevaluation is caller responsibility.
