set(LOTUSLIB_PACKAGES_BIN_SOURCE
    "${CMAKE_CURRENT_SOURCE_DIR}/lib/LotusLib/src/PackagesBin.cpp")
set(LOTUSLIB_PACKAGES_BIN_PATCH
    "${CMAKE_CURRENT_SOURCE_DIR}/patches/LotusLib/packages-bin-v46-bounds.patch")

if(NOT EXISTS "${LOTUSLIB_PACKAGES_BIN_SOURCE}")
    message(FATAL_ERROR
        "LotusLib is not initialized. Run the submodule initialization steps in Compiling.md.")
endif()

execute_process(
    COMMAND git apply --check "${LOTUSLIB_PACKAGES_BIN_PATCH}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/LotusLib"
    RESULT_VARIABLE LOTUSLIB_PATCH_CHECK_RESULT
    OUTPUT_QUIET
    ERROR_QUIET
)

if(LOTUSLIB_PATCH_CHECK_RESULT EQUAL 0)
    execute_process(
        COMMAND git apply "${LOTUSLIB_PACKAGES_BIN_PATCH}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/LotusLib"
        RESULT_VARIABLE LOTUSLIB_PATCH_RESULT
        OUTPUT_VARIABLE LOTUSLIB_PATCH_OUTPUT
        ERROR_VARIABLE LOTUSLIB_PATCH_ERROR
    )
    if(NOT LOTUSLIB_PATCH_RESULT EQUAL 0)
        message(FATAL_ERROR
            "Failed to apply the LotusLib Packages.bin compatibility patch:\n"
            "${LOTUSLIB_PATCH_OUTPUT}${LOTUSLIB_PATCH_ERROR}")
    endif()
    message(STATUS "Applied LotusLib Packages.bin v46 bounds patch")
else()
    execute_process(
        COMMAND git apply --reverse --check "${LOTUSLIB_PACKAGES_BIN_PATCH}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib/LotusLib"
        RESULT_VARIABLE LOTUSLIB_PATCH_REVERSE_CHECK_RESULT
        OUTPUT_QUIET
        ERROR_QUIET
    )
    if(NOT LOTUSLIB_PATCH_REVERSE_CHECK_RESULT EQUAL 0)
        message(FATAL_ERROR
            "The pinned LotusLib source no longer matches packages-bin-v46-bounds.patch. "
            "Review the upstream parser before building.")
    endif()
    message(STATUS "LotusLib Packages.bin v46 bounds patch is already applied")
endif()
