# NSX wrapper for Arm's upstream CMSIS-NN CMake project.

cmake_minimum_required(VERSION 3.21)

if(NOT DEFINED NSX_BOARD_FLAGS_TARGET)
    message(FATAL_ERROR
        "arm-cmsis-nn: NSX_BOARD_FLAGS_TARGET must be defined before this module is added.")
endif()

set(ARM_CMSIS_NN_ROOT "" CACHE PATH
    "Path to the upstream Arm CMSIS-NN checkout")
set(ARM_CMSIS_ROOT "" CACHE PATH
    "Path containing CMSIS/Core/Include; inferred when empty")
set(ARM_CMSIS_NN_OPTIMIZATION_LEVEL "-Ofast" CACHE STRING
    "Optimization level applied to upstream CMSIS-NN")

if(NOT ARM_CMSIS_NN_ROOT)
    set(_arm_cmsis_nn_candidates
        "${CMAKE_CURRENT_LIST_DIR}/external/CMSIS-NN"
        "${CMAKE_CURRENT_LIST_DIR}/../helia-rt/tensorflow/lite/micro/tools/make/downloads/cmsis_nn")
    foreach(_candidate IN LISTS _arm_cmsis_nn_candidates)
        if(EXISTS "${_candidate}/CMakeLists.txt")
            get_filename_component(ARM_CMSIS_NN_ROOT "${_candidate}" ABSOLUTE)
            break()
        endif()
    endforeach()
endif()

if(NOT EXISTS "${ARM_CMSIS_NN_ROOT}/CMakeLists.txt")
    message(FATAL_ERROR
        "arm-cmsis-nn: upstream CMSIS-NN was not found at "
        "${ARM_CMSIS_NN_ROOT}. Set -DARM_CMSIS_NN_ROOT=<checkout>.")
endif()

if(NOT ARM_CMSIS_ROOT)
    if(EXISTS "${ARM_CMSIS_NN_ROOT}/CMSIS/Core/Include")
        set(ARM_CMSIS_ROOT "${ARM_CMSIS_NN_ROOT}")
    elseif(EXISTS "${ARM_CMSIS_NN_ROOT}/../cmsis/CMSIS/Core/Include")
        get_filename_component(ARM_CMSIS_ROOT
            "${ARM_CMSIS_NN_ROOT}/../cmsis" ABSOLUTE)
    elseif(EXISTS "${ARM_CMSIS_NN_ROOT}/../CMSIS_6/CMSIS/Core/Include")
        get_filename_component(ARM_CMSIS_ROOT
            "${ARM_CMSIS_NN_ROOT}/../CMSIS_6" ABSOLUTE)
    elseif(EXISTS "${ARM_CMSIS_NN_ROOT}/../CMSIS/CMSIS/Core/Include")
        get_filename_component(ARM_CMSIS_ROOT
            "${ARM_CMSIS_NN_ROOT}/../CMSIS" ABSOLUTE)
    else()
        message(FATAL_ERROR
            "arm-cmsis-nn: could not find CMSIS/Core/Include. Set "
            "-DARM_CMSIS_ROOT=<directory containing CMSIS/Core/Include>.")
    endif()
endif()
if(NOT EXISTS "${ARM_CMSIS_ROOT}/CMSIS/Core/Include")
    message(FATAL_ERROR
        "arm-cmsis-nn: ARM_CMSIS_ROOT='${ARM_CMSIS_ROOT}' does not contain "
        "CMSIS/Core/Include.")
endif()

set(CMSIS_PATH "${ARM_CMSIS_ROOT}" CACHE PATH
    "CMSIS root consumed by upstream CMSIS-NN" FORCE)
set(CMSIS_OPTIMIZATION_LEVEL "${ARM_CMSIS_NN_OPTIMIZATION_LEVEL}" CACHE STRING
    "CMSIS-NN optimization level" FORCE)
set(CMSISNN_BUILD_PYBIND OFF CACHE BOOL "" FORCE)

if(NOT TARGET cmsis-nn)
    add_subdirectory("${ARM_CMSIS_NN_ROOT}" arm-cmsis-nn-src EXCLUDE_FROM_ALL)
endif()
if(NOT TARGET cmsis-nn)
    message(FATAL_ERROR
        "arm-cmsis-nn: upstream CMSIS-NN did not create the expected cmsis-nn target.")
endif()

target_link_libraries(cmsis-nn PUBLIC ${NSX_BOARD_FLAGS_TARGET})
target_include_directories(cmsis-nn PUBLIC
    "${ARM_CMSIS_NN_ROOT}"
    "${ARM_CMSIS_NN_ROOT}/Include"
    "${ARM_CMSIS_ROOT}/CMSIS/Core/Include")

add_library(nsx_arm_cmsis_nn INTERFACE)
set_target_properties(nsx_arm_cmsis_nn PROPERTIES EXPORT_NAME arm_cmsis_nn)
add_library(nsx::arm_cmsis_nn ALIAS nsx_arm_cmsis_nn)
target_link_libraries(nsx_arm_cmsis_nn INTERFACE cmsis-nn)
