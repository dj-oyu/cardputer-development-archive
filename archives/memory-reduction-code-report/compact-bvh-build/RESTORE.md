# Restore this private memory-reduction checkpoint

The compact builder diff and synthetic tests are self-contained with visibility.h. The code-only public checkpoint is https://github.com/dj-oyu/cardputer-adv-pocketjs/commit/aba669858ab8b813b67ce5831f5d86086b3e0ca3 . Its tools/renderer_experiments/indexed_visibility/run_tests.py runs the generic test matrix. Previous public commitd7cca777302b32bf790e15d36cb6f4e39911261e supplies the old builder for differential comparison. No images/model assets are in either checkpoint.

Private full actual reproduction additionally requires the previously retained center-id-ring baseline and original private input artifacts. These are not embedded here. review/audit_retained.py requires the original retained output paths and intentionally fails if absent. The code-only package does not falsely guarantee recovery of private raw renders after VM loss. Memory reduction and exactness evidence are preserved as aggregate reports.
