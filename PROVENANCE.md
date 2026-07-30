# Source provenance and ownership

`arm-cmsis-nn` is a thin NSX/CMake adapter. Its release version identifies the
adapter contract; it does not claim to be an upstream Arm CMSIS-NN version.

## Initial release identities

| Component | Repository | Exact revision | Upstream version context | Role |
| --- | --- | --- | --- | --- |
| Wrapper baseline | `AmbiqAI/arm-cmsis-nn` | `5e4a597970e0be141a6b8349ced621fed9e91999` | Tree-identical to downstream-pinned `41e0cf520fe68d5e22298f98e1a0ffda1196f8d8` | Reviewed canonical baseline |
| CMSIS-NN | `ARM-software/CMSIS-NN` | `cf08f6728f1a39eb551c6e48c6058a346284fecb` | `v7.0.0-39-gcf08f672`; PDSC version remains `0.0.0` | Kernel implementation |
| CMSIS 6 | `ARM-software/CMSIS_6` | `7f62ddc8ab8e9af22039912b8f9f46a9290f49ba` | `v6.3.1-dev-22-g7f62ddc8`; CMSIS-Core(M) header reports 6.1 | Core headers |

The two upstream revisions are development snapshots, not stable release tags.
Their immutable commit links are:

- <https://github.com/ARM-software/CMSIS-NN/commit/cf08f6728f1a39eb551c6e48c6058a346284fecb>
- <https://github.com/ARM-software/CMSIS_6/commit/7f62ddc8ab8e9af22039912b8f9f46a9290f49ba>

The first release deliberately preserves both gitlinks. Qualifying or updating
them is a separate compatibility change.

## Ownership and generated content

| Material | Owner/source | License | Release treatment |
| --- | --- | --- | --- |
| Wrapper CMake, metadata, documentation, tests, and automation outside `external/` | Ambiq and contributors | BSD 3-Clause | Authored and maintained in this repository |
| `external/CMSIS-NN` | Arm CMSIS-NN upstream at the exact gitlink above | Apache-2.0 | Unmodified submodule source, materialized into release archives |
| `external/CMSIS_6` | Arm CMSIS 6 upstream at the exact gitlink above | Apache-2.0 | Unmodified submodule source, materialized into release archives |
| Generated build trees, libraries, and executables | Consumer toolchain output | Not distributed as source | Excluded from releases |

This repository does not regenerate, copy, or take ownership of files inside
either submodule. Any upstream-generated files retain their upstream
copyright, notices, and license. The source-archive tool copies each exact
gitlink tree without modification and preserves both upstream `LICENSE` files.

Consumers distributing source or binaries must comply with the top-level
[BSD 3-Clause license](LICENSE) and the Apache-2.0 licenses and notices shipped
with each upstream component.

## Downstream boundary

The NeuralSPOT-X registry and `nsx-tflite-micro` currently identify this module
by exact commit rather than by release tag. Release preparation does not alter
those repositories or pins. Clone-based consumers must initialize submodules
recursively; the published release archive is self-contained.
