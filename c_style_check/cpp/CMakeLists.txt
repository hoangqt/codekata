# Specify the minimum version for CMake
cmake_minimum_required(VERSION 3.16)

# Project's name
project(c_style_check VERSION 1.0)

# Adhere to cpp17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(c_style_check c_style_check.cpp)
