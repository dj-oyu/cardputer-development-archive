# Independent synthetic indexed-input tests

PASS at identical -O2 for unsanitized and ASan+UBSan binaries. LeakSanitizer disabled, no LSan claim. Source and test SHA-256 pins and exact compiler commands are in RESULTS.json and CALLER_RESULTS.json.

- 1539 checks, 321 evaluations, 115 counted reject cases, 157 parity pairs across 15 variants. Exact full-result bytes and visibility work counters match legacy/compact/indexed layouts, including ground modes 1–3 and source poisoning.
- Every triangle/corner checked at index equal to vertex_count and UINT16_MAX. All seven supplied vertices, including the unused vertex, checked for nonfinite masks, invalid normal components, and all-zero normals. Complete spans checked for count, alignment, address wrap, aliases against each other, slot, old scene, geometry, lights and ground. Misaligned slot/lights/ground also rejected.
- Signed zero and full normal/color bits distinguish vertices. Repeated references and unused attributes do not inflate owned storage. Raw expanded triangle bytes and standard FNV-1a fingerprints match reconstructed indexed attributes. Material attributes are not merged by geometric position.
- Exact maximum 6144 unique vertices / 2048 triangles owns 139848 bytes; cap one byte below rejects atomically. Maximum index6143 retained exactly.
- Scene calloc failure and visibility refcount saturation preserve old slot/retained scene. Legacy→compact→indexed replacement cycling leaves old retained bindings evaluable. Bounce refcount saturation rejects.
- Caller allocation test source-extracts the exact allocation statements from native_render_row.c into an isolated wrapper. Failure at allocation1 and allocation2 leaves no tracked allocations and unchanged wrapper output. Success is35868 bytes; OFF makes zero allocations. No helper exposed, so this is not execution of native main or proof of full-main output rollback.

Scope is synthetic code only. No actual render, private geometry, model, reference, device, SDK, public changes, rejected owned-context or unfinished paged-BVH sources used. No implementation changes made by this test worker.
