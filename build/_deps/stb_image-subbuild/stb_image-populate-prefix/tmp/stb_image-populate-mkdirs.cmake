# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-src")
  file(MAKE_DIRECTORY "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-src")
endif()
file(MAKE_DIRECTORY
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-build"
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix"
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/tmp"
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/src/stb_image-populate-stamp"
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/src"
  "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/src/stb_image-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/src/stb_image-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/Users/phanisrikar/Desktop/Projects/C++ Sandbox/tiny-tools/build/_deps/stb_image-subbuild/stb_image-populate-prefix/src/stb_image-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
