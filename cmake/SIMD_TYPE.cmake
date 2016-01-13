#====================================================================
# SIMD optimization for CMake
# Copyright (c) 2016 Koichi OKADA. All rights reserved.
#
# This script is distributed under the MIT license.
#====================================================================
cmake_policy(PUSH)
cmake_policy(SET CMP0054 NEW)

if    ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  set(DEFAULT_SIMD_TYPE "sse3")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  set(DEFAULT_SIMD_TYPE "")
else()
  message("TODO: ${CMAKE_CURRENT_LIST_FILE}: ${CMAKE_CURRENT_LIST_LINE}: Please impliment a SIMD option for the ${CMAKE_CXX_COMPILER_ID} CXX compiler here.")
endif()

set(SIMD_TYPE "${DEFAULT_SIMD_TYPE}" CACHE STRING "A SIMD type for optimization.")
message("SIMD_TYPE : ${SIMD_TYPE}")

if    ("${SIMD_TYPE}" STREQUAL "")
  # nothing to do
  message("SIMD_TYPE is not set.")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  if("${SIMD_TYPE}" MATCHES "^(mmx|3dnow|sse|sse2|sse3|ssse3|sse4|sse4.1|sse4.2|sse4a|avx|avx2)$")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m${SIMD_TYPE}")
    message("-m is set to ${SIMD_TYPE}.")
  else()
    message("Erroe: SIMD_TYPE must take \"\", mmx, 3dnow, sse, sse2, sse3, ssse3, sse4, sse4.1, sse4.2, sse4a, avx or avx2.")
    return()
  endif()
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  if ("${SIMD_TYPE}" MATCHES "^(IA87|SSE2|AVX|AVX2)$")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /ARCH:${SIMD_TYPE}")
    message("ARCH is set to ${SIMD_TYPE}.")
  else()
    message("Error: SIMD_TYPE must take \"\", IA87, SSE2, AVX or AVX2.")
    return()
  endif()
else()
  message("something wrong.")
endif()

message("CMAKE_CXX_FLAGS : ${CMAKE_CXX_FLAGS}")

cmake_policy(POP)
