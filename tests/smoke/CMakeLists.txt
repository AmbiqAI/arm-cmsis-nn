cmake_minimum_required(VERSION 3.21)
project(arm_cmsis_nn_smoke LANGUAGES C)

add_library(nsx_smoke_board_flags INTERFACE)
set(NSX_BOARD_FLAGS_TARGET nsx_smoke_board_flags)

get_filename_component(_module_root "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
add_subdirectory("${_module_root}" arm-cmsis-nn)

add_executable(arm_cmsis_nn_smoke main.c)
target_link_libraries(arm_cmsis_nn_smoke PRIVATE nsx::arm_cmsis_nn)

if(CMAKE_CROSSCOMPILING)
    if(CMAKE_C_COMPILER_ID STREQUAL "ARMClang")
        target_link_options(arm_cmsis_nn_smoke PRIVATE --entry=main)
    elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU"
            OR CMAKE_C_COMPILER_ID MATCHES "Clang")
        target_link_options(arm_cmsis_nn_smoke PRIVATE
            -nostdlib
            "LINKER:--entry=main")
    endif()
else()
    enable_testing()
    add_test(NAME arm_cmsis_nn_smoke COMMAND arm_cmsis_nn_smoke)
endif()
