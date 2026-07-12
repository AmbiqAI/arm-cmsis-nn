# arm-cmsis-nn

Thin NSX wrapper around Arm's upstream CMSIS-NN CMake project. It exports the
standard implementation as `nsx::arm_cmsis_nn` for runtime modules such as
`nsx-tflite-micro`.

Set `ARM_CMSIS_NN_ROOT` to an upstream CMSIS-NN checkout. `ARM_CMSIS_ROOT`
must point to a directory containing `CMSIS/Core/Include`; it is inferred for
the usual sibling `CMSIS_6` or Helia-RT download layout.
