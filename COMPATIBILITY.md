# Compatibility and qualification

The catalog declares `arm-none-eabi-gcc`, `armclang`, and `atfe` compatibility.
The first-release preparation validates the public wrapper target and upstream
source with the following configure, compile, archive, and final-link smokes.

| Environment | Version | CPUs | Evidence |
| --- | --- | --- | --- |
| Native AppleClang | 21.0.0 | Host | Builds, links, and runs the public target smoke |
| GNU Arm Embedded | 15.2.1 | Cortex-M0, Cortex-M4, Cortex-M55 | Builds all upstream sources and links a bare-metal ARM executable |
| Arm Compiler 6 | 6.24.0 | Cortex-M0, Cortex-M4, Cortex-M55 | Builds all upstream sources and links a bare-metal ARM executable |
| Arm Toolchain for Embedded | 22.1.0 | Cortex-M0, Cortex-M4, Cortex-M55 | Builds all upstream sources and links a bare-metal ARM executable |
| Hosted Ubuntu CI | Distribution GNU Arm package | Cortex-M0, Cortex-M4, Cortex-M55 | Repeats metadata, archive, host, and GNU Arm smokes on every PR |

The CPU matrix covers the baseline M-profile path, Cortex-M4 DSP flags, and
Cortex-M55 MVE-capable flags. The downstream `nsx-tflite-micro` CMSIS-NN smoke
also builds, links, and runs on the host with Helia-RT revision
`7c1b162c0fd2336876b69daaa20c87a1e7e2f508`.

## Qualification boundary

These are structural source and link checks, not numerical conformance,
performance, hardware, BSP, or production-application qualification. Hosted CI
does not currently provide licensed Armclang or an ATfE installation, so those
toolchains require repeatable local or controlled-runner evidence before each
customer-qualified release. The current upstream revisions are development
snapshots; moving either gitlink requires renewed toolchain, downstream, and
hardware qualification.
