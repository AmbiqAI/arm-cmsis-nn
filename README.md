# arm-cmsis-nn

Thin NSX wrapper around Arm's upstream CMSIS-NN CMake project. It exports the
standard implementation as `nsx::arm_cmsis_nn` for runtime modules such as
`nsx-tflite-micro`. Pinned CMSIS-NN and CMSIS 6 source checkouts live under
`external/` as Git submodules and are hydrated automatically when NSX vendors
the module.

Set `ARM_CMSIS_NN_ROOT` to an upstream CMSIS-NN checkout only to override the
vendored source. `ARM_CMSIS_ROOT` must point to a directory containing
`CMSIS/Core/Include`; it is inferred for the bundled CMSIS 6 source and common
Helia-RT download layouts.
