#!/bin/bash

# build.sh - Скрипт сборки для проекта c-prg
# Разместить внутри папки c-prg/
# Использование: ./build.sh [команда] [имя_папки_проекта]

set -e  # Выйти при ошибке

# Определяем корневую директорию (где находится этот скрипт)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_DIR="${SCRIPT_DIR}"
BUILDS_DIR="${SCRIPT_DIR}/builds"

# Функция для показа помощи
show_help() {
    echo "Использование: $0 [команда] [имя_папки_проекта]"
    echo ""
    echo "Команды:"
    echo "  configure, config, c  - Конфигурация CMake"
    echo "  build, make, b        - Сборка проекта"
    echo "  clean, cl             - Очистка сборки"
    echo "  rebuild, rb           - Полная пересборка"
    echo "  run, execute, r       - Сборка и запуск"
    echo "  debug, dbg, d         - Сборка в Debug и запуск в отладчике"
    echo "  help, h               - Эта справка"
    echo ""
    echo "Примеры:"
    echo "  $0 build arrays      # Собрать проект arrays"
    echo "  $0 run pong          # Собрать и запустить проект pong"
    echo "  $0 clean test        # Очистить сборку проекта test"
    echo "  $0 configure arrays -DCMAKE_BUILD_TYPE=Debug"
    echo ""
    echo "Доступные проекты в ${PROJECTS_DIR}:"
    echo "-----------------------------------"
    for dir in "${PROJECTS_DIR}"/*/; do
        if [ -d "$dir" ] && [ -f "${dir}/CMakeLists.txt" ]; then
            project=$(basename "$dir")
            echo "  $project"
        fi
    done
    exit 0
}

# Проверяем количество аргументов
if [ $# -lt 2 ] && [ "$1" != "help" ] && [ "$1" != "h" ]; then
    echo "Ошибка: Необходимо указать команду и имя папки проекта!"
    echo ""
    show_help
fi

COMMAND="$1"
PROJECT_NAME="$2"
shift 2  # Убираем первые два аргумента, остальное - параметры CMake

# Проверяем существование проекта
PROJECT_DIR="${PROJECTS_DIR}/${PROJECT_NAME}"
if [ ! -d "${PROJECT_DIR}" ]; then
    echo "Ошибка: Проект '${PROJECT_NAME}' не найден в ${PROJECTS_DIR}/"
    exit 1
fi

if [ ! -f "${PROJECT_DIR}/CMakeLists.txt" ]; then
    echo "Ошибка: Файл CMakeLists.txt не найден в проекте '${PROJECT_NAME}'!"
    exit 1
fi

# Показываем информацию о проекте
echo "========================================"
echo "Проект: ${PROJECT_NAME}"
echo "Директория проекта: ${PROJECT_DIR}"
echo "Директория сборки: ${BUILDS_DIR}/${PROJECT_NAME}"
echo "Команда: ${COMMAND}"
echo "========================================"

# Функция для проверки переменных CMakeCache
check_cmake_cache() {
    if [ -f "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" ]; then
        echo "Проверяем настройки CMakeCache..."
        
        # Проверяем выходные директории
        echo "CMAKE_RUNTIME_OUTPUT_DIRECTORY:"
        grep "CMAKE_RUNTIME_OUTPUT_DIRECTORY" "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" || echo "  Не найдено"
        
        echo "CMAKE_BINARY_DIR:"
        grep "CMAKE_BINARY_DIR" "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" || echo "  Не найдено"
        
        echo "CMAKE_CURRENT_BINARY_DIR:"
        grep "CMAKE_CURRENT_BINARY_DIR" "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" || echo "  Не найдено"
    fi
}

# Функции для различных действий
configure_project() {
    echo "Конфигурация CMake..."
    
    # Полностью удаляем старую директорию сборки для чистоты
    if [ -d "${BUILDS_DIR}/${PROJECT_NAME}" ]; then
        echo "Удаляем старую директорию сборки..."
        rm -rf "${BUILDS_DIR}/${PROJECT_NAME}"
    fi
    
    mkdir -p "${BUILDS_DIR}/${PROJECT_NAME}"
    cd "${BUILDS_DIR}/${PROJECT_NAME}"
    
    echo "Выполнение: cmake ${PROJECT_DIR} $@"
    
    # Устанавливаем выходные директории через cache переменные
    cmake "${PROJECT_DIR}" \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="${BUILDS_DIR}/${PROJECT_NAME}/bin" \
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${BUILDS_DIR}/${PROJECT_NAME}/lib" \
        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY="${BUILDS_DIR}/${PROJECT_NAME}/lib" \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE="${BUILDS_DIR}/${PROJECT_NAME}/bin" \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG="${BUILDS_DIR}/${PROJECT_NAME}/bin" \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO="${BUILDS_DIR}/${PROJECT_NAME}/bin" \
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL="${BUILDS_DIR}/${PROJECT_NAME}/bin" \
        "$@"
    
    echo "Конфигурация завершена."
    check_cmake_cache
}

build_project() {
    echo "Сборка проекта..."
    
    # Проверяем, сконфигурирован ли проект
    if [ ! -f "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" ]; then
        echo "Проект не сконфигурирован. Конфигурируем с настройками по умолчанию..."
        configure_project -DCMAKE_BUILD_TYPE=Release
    else
        # Проверяем настройки перед сборкой
        check_cmake_cache
    fi
    
    cd "${BUILDS_DIR}/${PROJECT_NAME}"
    
    # Определяем количество ядер для параллельной сборки
    if command -v nproc >/dev/null 2>&1; then
        CORES=$(nproc)
    elif command -v sysctl >/dev/null 2>&1; then
        CORES=$(sysctl -n hw.ncpu)
    else
        CORES=4
    fi
    
    echo "Выполнение сборки с использованием ${CORES} ядер..."
    
    # Собираем проект
    cmake --build . -- -j${CORES}
    
    # Проверяем, что файлы создались в правильных местах
    echo ""
    echo "Проверка созданных файлов:"
    
    if [ -d "bin" ]; then
        echo "В bin/:"
        find "bin" -type f 2>/dev/null | while read file; do
            echo "  - $(basename "$file")"
        done || true
        
        # Проверяем права доступа
        echo ""
        echo "Права доступа в bin/:"
        ls -la "bin/" 2>/dev/null || true
    else
        echo "Ошибка: Директория bin/ не создана!"
        echo "Текущая директория: $(pwd)"
        ls -la
    fi
    
    if [ -d "lib" ]; then
        echo ""
        echo "В lib/:"
        find "lib" -type f 2>/dev/null | head -5 | while read file; do
            echo "  - $(basename "$file")"
        done || true
    fi
}

clean_project() {
    echo "Очистка сборки..."
    if [ -d "${BUILDS_DIR}/${PROJECT_NAME}" ]; then
        cd "${BUILDS_DIR}/${PROJECT_NAME}"
        cmake --build . --target clean
        echo "Сборка очищена."
    else
        echo "Директория сборки не существует: ${BUILDS_DIR}/${PROJECT_NAME}"
    fi
}

run_project() {
    echo "Подготовка к запуску проекта..."
    
    # Проверяем, собран ли проект
    if [ ! -f "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" ]; then
        echo "Проект не сконфигурирован. Конфигурируем и собираем..."
        configure_project -DCMAKE_BUILD_TYPE=Release
        build_project
    elif [ ! -d "${BUILDS_DIR}/${PROJECT_NAME}/bin" ] || [ -z "$(ls -A "${BUILDS_DIR}/${PROJECT_NAME}/bin" 2>/dev/null)" ]; then
        echo "Проект не собран. Собираем..."
        build_project
    fi
    
    # Ищем исполняемый файл
    EXECUTABLE=""
    
    # Проверяем разные возможные имена
    for potential_name in "${PROJECT_NAME}" "main" "app" "test"; do
        if [ -f "${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}" ]; then
            EXECUTABLE="${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}"
            break
        fi
        if [ -f "${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}.exe" ]; then
            EXECUTABLE="${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}.exe"
            break
        fi
    done
    
    # Если не нашли, ищем любой исполняемый файл в bin
    if [ -z "${EXECUTABLE}" ] && [ -d "${BUILDS_DIR}/${PROJECT_NAME}/bin" ]; then
        EXECUTABLE=$(find "${BUILDS_DIR}/${PROJECT_NAME}/bin" -type f -executable 2>/dev/null | head -n 1)
        if [ -z "${EXECUTABLE}" ]; then
            # Ищем просто любой файл
            EXECUTABLE=$(find "${BUILDS_DIR}/${PROJECT_NAME}/bin" -type f 2>/dev/null | head -n 1)
        fi
    fi
    
    if [ -n "${EXECUTABLE}" ] && [ -f "${EXECUTABLE}" ]; then
        echo "Запуск: ${EXECUTABLE}"
        echo "----------------------------------------"
        if [ -x "${EXECUTABLE}" ]; then
            "${EXECUTABLE}"
        else
            # Пробуем запустить даже если нет флага executable
            echo "Предупреждение: файл не помечен как исполняемый, пробуем запустить..."
            ./"${EXECUTABLE}"
        fi
    else
        echo "Ошибка: Не найден исполняемый файл!"
        echo "Искали в: ${BUILDS_DIR}/${PROJECT_NAME}/bin/"
        echo "Содержимое bin/:"
        ls -la "${BUILDS_DIR}/${PROJECT_NAME}/bin/" 2>/dev/null || echo "Директория не существует"
        exit 1
    fi
}

debug_project() {
    echo "Подготовка к отладке..."
    
    # Для отладки используем Debug сборку
    if [ ! -f "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" ]; then
        echo "Конфигурируем для отладки..."
        configure_project -DCMAKE_BUILD_TYPE=Debug
        build_project
    else
        # Проверяем текущий тип сборки
        if ! grep -q "CMAKE_BUILD_TYPE:STRING=Debug" "${BUILDS_DIR}/${PROJECT_NAME}/CMakeCache.txt" 2>/dev/null; then
            echo "Переконфигурируем для отладки..."
            configure_project -DCMAKE_BUILD_TYPE=Debug
            build_project
        elif [ ! -d "${BUILDS_DIR}/${PROJECT_NAME}/bin" ] || [ -z "$(ls -A "${BUILDS_DIR}/${PROJECT_NAME}/bin" 2>/dev/null)" ]; then
            echo "Собираем проект..."
            build_project
        fi
    fi
    
    # Ищем исполняемый файл
    EXECUTABLE=""
    for potential_name in "${PROJECT_NAME}" "main" "app" "test"; do
        if [ -f "${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}" ]; then
            EXECUTABLE="${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}"
            break
        fi
        if [ -f "${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}.exe" ]; then
            EXECUTABLE="${BUILDS_DIR}/${PROJECT_NAME}/bin/${potential_name}.exe"
            break
        fi
    done
    
    if [ -z "${EXECUTABLE}" ] && [ -d "${BUILDS_DIR}/${PROJECT_NAME}/bin" ]; then
        EXECUTABLE=$(find "${BUILDS_DIR}/${PROJECT_NAME}/bin" -type f 2>/dev/null | head -n 1)
    fi
    
    if [ -n "${EXECUTABLE}" ] && [ -f "${EXECUTABLE}" ]; then
        echo "Запуск отладчика для: ${EXECUTABLE}"
        
        # Проверяем доступные отладчики
        if command -v lldb >/dev/null 2>&1; then
            lldb "${EXECUTABLE}"
        elif command -v gdb >/dev/null 2>&1; then
            gdb "${EXECUTABLE}"
        else
            echo "Ошибка: Не найден отладчик (lldb/gdb)"
            echo "Запуск без отладчика:"
            echo "----------------------------------------"
            if [ -x "${EXECUTABLE}" ]; then
                "${EXECUTABLE}"
            else
                ./"${EXECUTABLE}"
            fi
        fi
    else
        echo "Ошибка: Не найден исполняемый файл!"
        exit 1
    fi
}

# Выполняем запрошенную команду
case "${COMMAND}" in
    configure|config|c)
        configure_project "$@"
        ;;
        
    build|make|b)
        build_project
        ;;
        
    clean|cl)
        clean_project
        ;;
        
    rebuild|rb)
        echo "Полная пересборка проекта..."
        if [ -d "${BUILDS_DIR}/${PROJECT_NAME}" ]; then
            rm -rf "${BUILDS_DIR}/${PROJECT_NAME}"
        fi
        configure_project "$@"
        build_project
        ;;
        
    run|execute|r)
        run_project
        ;;
        
    debug|dbg|d)
        debug_project
        ;;
        
    help|h)
        show_help
        ;;
        
    *)
        echo "Неизвестная команда: ${COMMAND}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo "Готово!"
echo "Директория сборки: ${BUILDS_DIR}/${PROJECT_NAME}"
