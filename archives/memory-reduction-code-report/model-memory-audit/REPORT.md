# Model allocation correction and deferred design

The historical ledger field liveModelArena129064 is a combined live total, not a single allocation: cold model47708 + model arena81356. The earlier statements identifying129064 as one contiguous block are incorrect and superseded here. Instance control584 is a separate stack object. Existing full depth129600 truly is one allocation.

Host arena:55 node states ×24 =1320; one group84 +54 mesh work slots79952 =80036; total81356. Mesh slots1248..1648 each. Current functions states()/work() centralize layout but all alias guards assume one contiguousarena. Splitting individual node slots is computationally possible but needs a new descriptor/init/dispose/borrowedview and fullspan-alias contract. No segmentedmodel implementation is claimed. Host sizes do not prove target32 ABI.

Small independent lifetime alternative: append owned snapshot in unchanged forward/reverse order, extract owned world-double geometry/materials in original node order, then dispose/poison/free arena and cold data before BVH/transport/background construction. Current code reads model views for snapshot after BVHbuild, so earlyfree without reorder is unsafe. The reordering could remove129064 from constructionphases, but does not reduce maximumallocation or renderpeak. Extraction still overlaps source model and geometry/attribute arrays. This remains a proposal, not implemented or tested.

For the current task, depth band segmentation is the narrower first prototype. It preserves both original admission layers and publicationatomicity; totalmemory will increase slightly while contiguousdepthallocation shrinks. No prohibited ownedcontext/pagedBVH source was consulted, no new device/SDK/model/reference action.
