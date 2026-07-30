set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

find_program(_armclang armclang REQUIRED)
find_program(_armar armar REQUIRED)
find_program(_armlink armlink REQUIRED)

set(CMAKE_C_COMPILER "${_armclang}")
set(CMAKE_CXX_COMPILER "${_armclang}")
set(CMAKE_AR "${_armar}")
set(CMAKE_LINKER "${_armlink}")
set(CMAKE_C_STANDARD_LIBRARIES "")
set(CMAKE_CXX_STANDARD_LIBRARIES "")
set(CMAKE_C_LINK_EXECUTABLE
    "<CMAKE_LINKER> <LINK_FLAGS> <OBJECTS> <LINK_LIBRARIES> -o <TARGET>")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES NSX_SMOKE_CPU)
if(NSX_SMOKE_CPU STREQUAL "cortex-m0")
    set(_cpu_flags
        "--target=arm-arm-none-eabi -mcpu=cortex-m0 -mthumb -mfloat-abi=soft")
elseif(NSX_SMOKE_CPU STREQUAL "cortex-m4")
    set(_cpu_flags
        "--target=arm-arm-none-eabi -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
elseif(NSX_SMOKE_CPU STREQUAL "cortex-m55")
    set(_cpu_flags
        "--target=arm-arm-none-eabi -mcpu=cortex-m55 -mthumb -mfloat-abi=hard")
else()
    message(FATAL_ERROR
        "NSX_SMOKE_CPU must be cortex-m0, cortex-m4, or cortex-m55")
endif()

set(CMAKE_C_FLAGS_INIT "${_cpu_flags}")
set(CMAKE_CXX_FLAGS_INIT "${_cpu_flags}")
