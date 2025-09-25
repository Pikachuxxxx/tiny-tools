cmake_minimum_required(VERSION 3.15)
project(TinyTools C CXX ASM ASM_MASM)

# -----------------------
# Compiler standards
# -----------------------
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

# -----------------------
# Build types
# -----------------------
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# -----------------------
# Include directory
# -----------------------
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
include_directories(${INCLUDE_DIR})

# -----------------------
# Other set options 
# -----------------------
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# -----------------------
# Download stb headers if missing
# -----------------------
set(STB_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
file(MAKE_DIRECTORY ${STB_INCLUDE_DIR})

set(STB_IMAGE ${STB_INCLUDE_DIR}/stb_image.h)
if(NOT EXISTS ${STB_IMAGE})
    message(STATUS "Downloading stb_image.h...")
    file(DOWNLOAD
        https://raw.githubusercontent.com/nothings/stb/master/stb_image.h
        ${STB_IMAGE}
        SHOW_PROGRESS
        STATUS _stb_image_status
    )
    list(GET _stb_image_status 0 _stb_image_code)
    if(NOT _stb_image_code EQUAL 0)
        message(FATAL_ERROR "Failed to download stb_image.h")
    endif()
endif()

set(STB_IMAGE_WRITE ${STB_INCLUDE_DIR}/stb_image_write.h)
if(NOT EXISTS ${STB_IMAGE_WRITE})
    message(STATUS "Downloading stb_image_write.h...")
    file(DOWNLOAD
        https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h
        ${STB_IMAGE_WRITE}
        SHOW_PROGRESS
        STATUS _stb_image_write_status
    )
    list(GET _stb_image_write_status 0 _stb_image_write_code)
    if(NOT _stb_image_write_code EQUAL 0)
        message(FATAL_ERROR "Failed to download stb_image_write.h")
    endif()
endif()


# -----------------------
# Macro to add a tiny tool
macro(add_tiny_tool TOOL_NAME SOURCE_FILE)
    get_filename_component(ext ${SOURCE_FILE} EXT)
    string(TOLOWER ${ext} ext_lower)

    if(ext_lower STREQUAL ".c" OR ext_lower STREQUAL ".cpp" OR ext_lower STREQUAL ".cc")
        add_executable(${TOOL_NAME} ${SOURCE_FILE})
        target_include_directories(${TOOL_NAME} PRIVATE ${INCLUDE_DIR})

        # Compiler flags per configuration
        target_compile_options(${TOOL_NAME} PRIVATE
            $<$<CONFIG:Debug>:-O0 -g>
            $<$<CONFIG:Release>:-O3>
        )

    elseif(ext_lower STREQUAL ".s" OR ext_lower STREQUAL ".asm")
        # Simple assembly build
        add_executable(${TOOL_NAME} ${SOURCE_FILE})
        if(MSVC)
            # Windows MASM
            set_source_files_properties(${SOURCE_FILE} PROPERTIES LANGUAGE ASM_MASM)
        else()
            # GCC/Clang assembly
            set_source_files_properties(${SOURCE_FILE} PROPERTIES LANGUAGE ASM)
        endif()
    else()
        message(FATAL_ERROR "Unsupported source file type: ${SOURCE_FILE}")
    endif()

    # Create a run target
    add_custom_target(run_${TOOL_NAME}
        COMMAND $<TARGET_FILE:${TOOL_NAME}> ${ARGN}
        DEPENDS ${TOOL_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running ${TOOL_NAME}..."
    )
endmacro()

# -----------------------
# Add tools using macro
# -----------------------
add_tiny_tool(tiny_c tiny.c)
add_tiny_tool(tiny_cpp tiny.cpp)
add_tiny_tool(sh sh-coeff.c)
add_tiny_tool(hello-arm-asm hello-arm.S)
