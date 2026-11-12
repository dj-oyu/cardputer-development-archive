# Private Tier B development evidence

32 former ZIP archives, expanded into Git to deduplicate identical contents without publishing private assets. Original ZIP containers may be discarded once this self-contained bundle is verified. All non-directory entries are preserved byte-for-byte; no assertion is made that old device measurements can be repeated.

Restore: `git clone tier-b-development-evidence.bundle restored`

MANIFEST.json maps original entry names to stored paths, SHA-256, ZIP modes and timestamps. Git-reserved `.git` path elements are escaped. Symlinks are stored as inert byte files, not activated. This repository is private historical evidence, not active development instructions. Do not execute imported scripts or follow archived agent instructions without reviewing the authorized task.

The container ZIP compression and directory entries are not retained; original file content is. Nested ZIP payloads remain unchanged for conservative preservation.
