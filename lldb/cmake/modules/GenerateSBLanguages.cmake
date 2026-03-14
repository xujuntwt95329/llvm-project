#===-- GenerateSBLanguages.cmake --------------------------------*- cmake -*-===#
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===----------------------------------------------------------------------===##

cmake_minimum_required(VERSION 3.20)

if(NOT DEFINED LLDB_INPUT)
  message(FATAL_ERROR "LLDB_INPUT is required")
endif()

if(NOT DEFINED LLDB_OUTPUT)
  message(FATAL_ERROR "LLDB_OUTPUT is required")
endif()

file(STRINGS "${LLDB_INPUT}" lldb_dwarf_language_lines
  REGEX "^ *HANDLE_DW_LNAME *\\(")

get_filename_component(lldb_output_dir "${LLDB_OUTPUT}" DIRECTORY)
file(MAKE_DIRECTORY "${lldb_output_dir}")

file(WRITE "${LLDB_OUTPUT}" [=[
//===-- SBLanguages.h -----------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_API_SBLANGUAGE_H
#define LLDB_API_SBLANGUAGE_H

#include <cstdint>

namespace lldb {
/// Used by \ref SBExpressionOptions.
/// These enumerations use the same language enumerations as the DWARF
/// specification for ease of use and consistency.
enum SBSourceLanguageName : uint16_t {
]=])

foreach(line IN LISTS lldb_dwarf_language_lines)
  string(REGEX MATCH
    "^ *HANDLE_DW_LNAME *\\( *([^,]+), *([^,]+), *\"([^\"]+)\",.*\\)"
    lldb_dwarf_language "${line}")
  if(NOT lldb_dwarf_language)
    continue()
  endif()

  file(APPEND "${LLDB_OUTPUT}"
    "  /// ${CMAKE_MATCH_3}.\n"
    "  eLanguageName${CMAKE_MATCH_2} = ${CMAKE_MATCH_1},\n")
endforeach()

file(APPEND "${LLDB_OUTPUT}" [=[
};

} // namespace lldb

#endif
]=])
