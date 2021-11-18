if(1)
  # may Darwin/Linux/Android/Windows
  message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
  # may aarch64/armv7-a/AMD64/x86_64
  message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
  # may Clang/MSVC/AppleClang
  message(STATUS "CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}")
endif()

string(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)
if( uppercase_CMAKE_BUILD_TYPE STREQUAL "RELEASE" )
  add_definitions(-DNDEBUG)
elseif( uppercase_CMAKE_BUILD_TYPE STREQUAL "RELWITHDEBINFO" )
  add_definitions(-DNDEBUG)
elseif( uppercase_CMAKE_BUILD_TYPE STREQUAL "MINSIZEREL" )
  add_definitions(-DNDEBUG)
endif()

if (NOT MSVC AND NOT WIN32)

  # off rtti
  add_compile_options(-fno-rtti)

  # off exceptions
  #add_compile_options(-fno-exceptions)

  # 结合-Wl,--gc-sections、-dead_strip进行库大小优化, 同一个obj文件中未使用的代码不会被链接
  add_compile_options(-ffunction-sections -fdata-sections)

  # -g
  add_compile_options(-g)

  # fast-math
  add_compile_options(-ffast-math)

  add_compile_options(-Wall)
else()
  # off rtti
  add_compile_options(/GR-)

  # off exceptions
  #add_compile_options(/EH-)
  add_compile_options(/EHsc)

  add_compile_options("$<$<C_COMPILER_ID:MSVC>:/source-charset:utf-8>")
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")

  # multi-threads compile
  add_compile_options("$<$<C_COMPILER_ID:MSVC>:/MP>")
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/MP>")

  # cmath M_PI etc.
  add_definitions(-D_USE_MATH_DEFINES)

  add_definitions(-DNOMINMAX)

  add_compile_options(/W4)

  add_link_options(/SAFESEH:NO)
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
  # using Clang
  add_link_options(-dead_strip)

  # -gline-tables-only
  add_compile_options(
          "$<$<CONFIG:DEBUG>:-g>"
          "$<$<CONFIG:RELEASE>:-gline-tables-only>"
          "$<$<CONFIG:RELWITHDEBINFO>:-gline-tables-only>"
          "$<$<CONFIG:MINSIZEREL>:-gline-tables-only>"
  )
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  # using GCC
  add_link_options(-Wl,--gc-sections)
  
  # 优先使用库内符号
  add_link_options(-Wl,-Bsymbolic)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
  # using Intel C++
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  # using Visual Studio C++
  if (CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(WIN_ARCH "x64")
  else(CMAKE_SIZEOF_VOID_P MATCHES 8)
    set(WIN_ARCH "x86")
  endif(CMAKE_SIZEOF_VOID_P MATCHES 8)
endif()

# RPATH
set(CMAKE_SKIP_RPATH TRUE)
set(CMAKE_SKIP_BUILD_RPATH TRUE)
set(CMAKE_SKIP_INSTALL_RPATH TRUE)

if(NOT MSVC)
  set(CMAKE_INSTALL_PREFIX "/")
endif()

SET(CMAKE_INSTALL_DO_STRIP TRUE) # CACHE BOOL "If set to true, executables and libraries will be stripped when installing.")