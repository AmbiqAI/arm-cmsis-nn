# Changelog

All notable changes to this module are documented in this file. The module
follows [Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-07-30

### Added

- First customer-supportable release foundation for the
  `nsx::arm_cmsis_nn` wrapper.
- Exact CMSIS-NN and CMSIS 6 source provenance and ownership documentation.
- CI validation for metadata, source archives, the host target contract, and
  GNU Arm cross-builds.
- Controlled annotated-tag publishing with submodule-inclusive source
  archives.

### Compatibility

- Preserves the wrapper tree and public CMake behavior consumed from
  `41e0cf520fe68d5e22298f98e1a0ffda1196f8d8`.
- Does not change either upstream gitlink, runtime source, or downstream
  registry pin.

[0.1.0]: https://github.com/AmbiqAI/arm-cmsis-nn/releases/tag/v0.1.0
