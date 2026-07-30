# arm-cmsis-nn

Thin NSX wrapper around Arm's upstream CMSIS-NN CMake project. It exports the
standard implementation as `nsx::arm_cmsis_nn` for runtime modules such as
`nsx-tflite-micro`. Pinned CMSIS-NN and CMSIS 6 source checkouts live under
`external/` as Git submodules.

Clone consumers must hydrate the source recursively:

```sh
git submodule update --init --recursive
```

NSX registry clients that support recursive module hydration do this while
vendoring the module. Published release archives include the pinned submodule
content and do not require Git.

Set `ARM_CMSIS_NN_ROOT` to an upstream CMSIS-NN checkout only to override the
vendored source. `ARM_CMSIS_ROOT` must point to a directory containing
`CMSIS/Core/Include`; it is inferred for the bundled CMSIS 6 source and common
Helia-RT download layouts.

## Public CMake contract

Define `NSX_BOARD_FLAGS_TARGET` before adding this directory. The wrapper
preserves upstream's `cmsis-nn` target and exports `nsx::arm_cmsis_nn`.
`ARM_CMSIS_NN_OPTIMIZATION_LEVEL` controls the upstream optimization flag and
defaults to `-Ofast`.

## Release and source identity

This wrapper follows SemVer independently from upstream CMSIS-NN. See
[PROVENANCE.md](PROVENANCE.md) for exact upstream commits and source ownership,
[RELEASE.md](RELEASE.md) for immutable-tag policy, and
[COMPATIBILITY.md](COMPATIBILITY.md) for the validation boundary.
