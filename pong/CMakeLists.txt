cmake_minimum_required(VERSION 4.0)

project(pong VERSION 0.0.1 LANGUAGES C)

# Устанавливаем бинарный выход в папку builds/bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/bin)
# Устанавливаем выход библиотек в папку builds/lib
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/lib)
# Устанавливаем выход архивов в папку builds/lib
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/builds/lib)

find_package(Curses REQUIRED)

include_directories(${CURSES_INCLUDE_DIRS})

add_executable(${PROJECT_NAME} 
    main.c 
    ./utils/result.c 
    ./utils/result.h
    ./game_engine/engine.h
    ./game_engine/engine.c
    ./utils/input.h
    ./utils/input.c
)

target_link_libraries(pong ${CURSES_LIBRARIES})

# Опционально: настраиваем стандарт C
set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
