set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

find_program(_arm_gcc arm-none-eabi-gcc REQUIRED)
find_program(_arm_gxx arm-none-eabi-g++ REQUIRED)
find_program(_arm_ar arm-none-eabi-ar REQUIRED)
find_program(_arm_ranlib arm-none-eabi-ranlib REQUIRED)

set(CMAKE_C_COMPILER "${_arm_gcc}")
set(CMAKE_CXX_COMPILER "${_arm_gxx}")
set(CMAKE_AR "${_arm_ar}")
set(CMAKE_RANLIB "${_arm_ranlib}")

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
