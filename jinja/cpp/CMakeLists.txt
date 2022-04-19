# Specify the minimum version for CMake
cmake_minimum_required(VERSION 3.16)

# Project's name
project(genciconf VERSION 1.0)

# Adhere to cpp17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set($CMAKE_SOURCE_DIR/external/inja/inja.hpp)

add_executable(genciconf genciconf.cpp)

find_package(nlohmann_json 3.10.5 REQUIRED)
add_library(nlohmann_json INTERFACE)
target_link_libraries(genciconf PRIVATE nlohmann_json::nlohmann_json)
