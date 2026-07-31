set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

if(NOT DEFINED ENV{ATFE_ROOT})
    message(FATAL_ERROR "ATFE_ROOT must identify an Arm Toolchain for Embedded install")
endif()
set(_atfe_bin "$ENV{ATFE_ROOT}/bin")

find_program(_atfe_clang clang HINTS "${_atfe_bin}" NO_DEFAULT_PATH REQUIRED)
find_program(_atfe_clangxx clang++ HINTS "${_atfe_bin}" NO_DEFAULT_PATH REQUIRED)
find_program(_atfe_ar llvm-ar HINTS "${_atfe_bin}" NO_DEFAULT_PATH REQUIRED)
find_program(_atfe_ranlib llvm-ranlib
    HINTS "${_atfe_bin}" NO_DEFAULT_PATH REQUIRED)

set(CMAKE_C_COMPILER "${_atfe_clang}")
set(CMAKE_CXX_COMPILER "${_atfe_clangxx}")
set(CMAKE_AR "${_atfe_ar}")
set(CMAKE_RANLIB "${_atfe_ranlib}")
set(CMAKE_C_COMPILER_TARGET arm-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET arm-none-eabi)

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES NSX_SMOKE_CPU)
if(NSX_SMOKE_CPU STREQUAL "cortex-m0")
    set(_cpu_flags "-mcpu=cortex-m0 -mthumb -mfloat-abi=soft")
elseif(NSX_SMOKE_CPU STREQUAL "cortex-m4")
    set(_cpu_flags
        "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
elseif(NSX_SMOKE_CPU STREQUAL "cortex-m55")
    set(_cpu_flags "-mcpu=cortex-m55 -mthumb -mfloat-abi=hard")
else()
    message(FATAL_ERROR
        "NSX_SMOKE_CPU must be cortex-m0, cortex-m4, or cortex-m55")
endif()

set(CMAKE_C_FLAGS_INIT "${_cpu_flags}")
set(CMAKE_CXX_FLAGS_INIT "${_cpu_flags}")
