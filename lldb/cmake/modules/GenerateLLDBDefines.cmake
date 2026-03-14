#===-- GenerateLLDBDefines.cmake --------------------------------*- cmake -*-===#
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===----------------------------------------------------------------------===##

cmake_minimum_required(VERSION 3.20)

foreach(required_var LLDB_INPUT LLDB_OUTPUT LLDB_VERSION_MAJOR LLDB_VERSION_MINOR
                     LLDB_VERSION_PATCH)
  if(NOT DEFINED ${required_var})
    message(FATAL_ERROR "${required_var} is required")
  endif()
endforeach()

file(READ "${LLDB_INPUT}" lldb_defines_contents)

string(REPLACE "//#define LLDB_VERSION_STRING\n\n"
  "#define LLDB_VERSION_STRING \"${LLDB_VERSION_MAJOR}.${LLDB_VERSION_MINOR}.${LLDB_VERSION_PATCH}\"\n"
  lldb_defines_contents "${lldb_defines_contents}")
string(REPLACE "//#define LLDB_REVISION"
  "#define LLDB_REVISION ${LLDB_VERSION_PATCH}"
  lldb_defines_contents "${lldb_defines_contents}")
string(REPLACE "//#define LLDB_VERSION"
  "#define LLDB_VERSION ${LLDB_VERSION_MAJOR}"
  lldb_defines_contents "${lldb_defines_contents}")

get_filename_component(lldb_output_dir "${LLDB_OUTPUT}" DIRECTORY)
file(MAKE_DIRECTORY "${lldb_output_dir}")
file(WRITE "${LLDB_OUTPUT}" "${lldb_defines_contents}")
