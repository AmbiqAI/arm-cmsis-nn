cmake_minimum_required(VERSION 3.21)

set(_root "${CMAKE_CURRENT_LIST_DIR}/..")
set(_semver
    "(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?")

file(READ "${_root}/nsx-module.yaml" _module)
string(REGEX MATCH
    "module:[ \t]*\n[ \t]+name:[ \t]*arm-cmsis-nn[ \t]*\n[ \t]+type:[ \t]*backend_specific[ \t]*\n[ \t]+version:[ \t]*\"(${_semver})\""
    _module_match "${_module}")
if(NOT _module_match)
    message(FATAL_ERROR "nsx-module.yaml does not declare a valid module identity")
endif()
set(_version "${CMAKE_MATCH_1}")

file(READ "${_root}/version.txt" _version_file)
string(STRIP "${_version_file}" _version_file)
if(NOT _version STREQUAL _version_file)
    message(FATAL_ERROR "nsx-module.yaml and version.txt disagree")
endif()

file(READ "${_root}/.release-please-manifest.json" _manifest)
string(REGEX MATCH "\"\\.\"[ \t]*:[ \t]*\"(${_semver})\""
    _manifest_match "${_manifest}")
if(NOT _manifest_match OR NOT _version STREQUAL CMAKE_MATCH_1)
    message(FATAL_ERROR "Release Please manifest version is inconsistent")
endif()

foreach(_required IN ITEMS
        CHANGELOG.md
        COMPATIBILITY.md
        LICENSE
        PROVENANCE.md
        README.md
        RELEASE.md
        release-please-config.json
        version.txt)
    if(NOT EXISTS "${_root}/${_required}")
        message(FATAL_ERROR "Missing release foundation file: ${_required}")
    endif()
endforeach()

set(_cmsis_nn_revision "cf08f6728f1a39eb551c6e48c6058a346284fecb")
set(_cmsis_6_revision "7f62ddc8ab8e9af22039912b8f9f46a9290f49ba")
execute_process(
    COMMAND git -C "${_root}" ls-tree HEAD -- external/CMSIS-NN external/CMSIS_6
    RESULT_VARIABLE _tree_result
    OUTPUT_VARIABLE _gitlinks
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT _tree_result EQUAL 0
        OR NOT _gitlinks MATCHES "160000 commit ${_cmsis_nn_revision}[ \t]+external/CMSIS-NN"
        OR NOT _gitlinks MATCHES "160000 commit ${_cmsis_6_revision}[ \t]+external/CMSIS_6")
    message(FATAL_ERROR "Pinned upstream gitlinks do not match release provenance")
endif()

file(READ "${_root}/PROVENANCE.md" _provenance)
foreach(_revision IN ITEMS "${_cmsis_nn_revision}" "${_cmsis_6_revision}")
    if(NOT _provenance MATCHES "${_revision}")
        message(FATAL_ERROR "PROVENANCE.md omits ${_revision}")
    endif()
endforeach()

foreach(_submodule IN ITEMS CMSIS-NN CMSIS_6)
    if(EXISTS "${_root}/external/${_submodule}/.git")
        execute_process(
            COMMAND git -C "${_root}/external/${_submodule}" rev-parse HEAD
            RESULT_VARIABLE _revision_result
            OUTPUT_VARIABLE _hydrated_revision
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        if(NOT _revision_result EQUAL 0)
            message(FATAL_ERROR "Cannot inspect external/${_submodule}")
        endif()
        if(_submodule STREQUAL "CMSIS-NN")
            set(_expected_revision "${_cmsis_nn_revision}")
        else()
            set(_expected_revision "${_cmsis_6_revision}")
        endif()
        if(NOT _hydrated_revision STREQUAL _expected_revision)
            message(FATAL_ERROR "external/${_submodule} is at the wrong revision")
        endif()
        if(NOT EXISTS "${_root}/external/${_submodule}/LICENSE")
            message(FATAL_ERROR "external/${_submodule} omits its upstream license")
        endif()
    endif()
endforeach()

file(READ "${_root}/CMakeLists.txt" _cmake)
foreach(_contract IN ITEMS
        "NSX_BOARD_FLAGS_TARGET"
        "ARM_CMSIS_NN_ROOT"
        "ARM_CMSIS_ROOT"
        "ARM_CMSIS_NN_OPTIMIZATION_LEVEL"
        "TARGET cmsis-nn"
        "nsx::arm_cmsis_nn")
    if(NOT _cmake MATCHES "${_contract}")
        message(FATAL_ERROR "Public CMake contract omits ${_contract}")
    endif()
endforeach()

file(GLOB _workflows "${_root}/.github/workflows/*.yml")
foreach(_workflow IN LISTS _workflows)
    file(READ "${_workflow}" _workflow_content)
    string(REGEX MATCHALL "uses:[^\n\r]+" _uses_lines "${_workflow_content}")
    foreach(_uses IN LISTS _uses_lines)
        if(NOT _uses MATCHES
                "uses:[ \t]*[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+@[0-9a-f]+")
            message(FATAL_ERROR
                "Third-party action is not pinned to a full commit: ${_uses}")
        endif()
        string(REGEX REPLACE "^.*@" "" _action_revision "${_uses}")
        string(REGEX REPLACE "[ \t]+#.*$" "" _action_revision
            "${_action_revision}")
        string(LENGTH "${_action_revision}" _action_revision_length)
        if(NOT _action_revision_length EQUAL 40)
            message(FATAL_ERROR
                "Third-party action pin is not 40 characters: ${_uses}")
        endif()
    endforeach()
endforeach()

message(STATUS "Release metadata contract passed for arm-cmsis-nn ${_version}")
