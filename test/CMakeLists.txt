cmake_minimum_required(VERSION 3.0)

project(test)

# Устанавливаем бинарный выход в папку builds/bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/bin)
# Устанавливаем выход библиотек в папку builds/lib
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/lib)
# Устанавливаем выход архивов в папку builds/lib
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/lib)

add_executable(${PROJECT_NAME} main.c)

# Опционально: настраиваем стандарт C
set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
