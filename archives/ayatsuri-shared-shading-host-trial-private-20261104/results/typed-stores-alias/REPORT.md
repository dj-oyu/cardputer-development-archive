# Typed color store overlap tests

Status: PASS. Four configurations: O0, O2, ASan+UBSan O0, ASan+UBSan O2. Compiler: cc (Debian 14.2.0-19) 14.2.0.

Each configuration: 87,336 synthetic shading inputs, 1,746,720 calls, 3,493,440 exact output checks, 24,454,080 surrounding uint16 element checks. 873,360 calls use output aligned to 2 bytes but not 4. Digest: cb0a1d5fd3f72de5; identical in all configurations.

The exact frozen analysis/typed-stores/shade_pair.c is compiled into separate control and candidate translation units with SHARED=1 and TYPED_STORES=0/1 respectively. Both original input colors are read by the oracle before mutation. Each resulting full 16-element array must match that immutable expectation. Arrays are declared uint16_t objects with 4-byte base alignment, never reinterpreted float/normal storage. No invalid uint16 pointer or new alias contract is used.

Five layouts, each at both uint16 index parities and for both implementations: output one element before albedo, identical pointers, one element after albedo, disjoint before, and disjoint after. The one-element-after case catches reading albedo[1] after overwriting it through out[0]. Every nonoutput element must remain unchanged, including input elements not overlapped by output. All 65,536 albedos occur in both input slots; other cases include 20,000 deterministic random inputs (xorshift seed 0x9e3779b9), direction extremes including FLT_TRUE_MIN/FLT_MAX, thickness boundaries, opposite directions and 27 independently rounded front/back SNORM half ties. Total cases comprise 65,536 RGB565, 180 extremes, 1,620 tie cases, and 20,000 random cases.

Strict FP: FE_TONEAREST checked, FP contraction off, no fast-math, standard excess precision. -fno-builtin-memcpy retained in every build. LSan is explicitly disabled because the sandbox ptrace restriction prevents its use; ASan and UBSan remain enabled. Source and harness identities verified before/after every run and overall. Exact commands, complete source hashes, binary hashes and counts are in alias.json; build/run logs in each configuration folder.

Reproduce from experiment root: `python3 tests/typed-stores/run_alias.py`.

Host semantic test only: no target runtime, cycle/performance, device, original assets, or general proof for all inputs. Product and old test files were not edited. This tests the actual isolated pair harness, not a fabricated variant; parent whole-evaluator tests separately cover product call sites.
