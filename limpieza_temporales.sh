#!/bin/bash

LOG_FILE="limpieza_archivos_temp.log"

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script necesita permisos de superusuario. Ejecuta con sudo."
        exit 1
    fi
}

function log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

function clean_temp_files() {
    read -p "Ingresa el directorio a limpiar (por defecto es /tmp): " directory
    directory=${directory:-/tmp}

    if [[ ! -d $directory ]]; then
        echo "Directorio no encontrado: $directory"
        exit 1
    fi

    read -p "Eliminar archivos mayores a cuántos días? (ej. 7): " days
    days=${days:-7}

    temp_files=$(find "$directory" -type f -name "*.tmp" -o -name "*.temp" -mtime +"$days")

    if [[ -z $temp_files ]]; then
        echo "No se encontraron archivos temporales en $directory con más de $days días."
        exit 0
    fi

    echo "Archivos temporales encontrados:"
    echo "$temp_files"
    read -p "¿Quieres eliminar estos archivos? (s/n): " confirm

    if [[ $confirm == "s" ]]; then
        echo "$temp_files" | xargs rm -f
        echo "Archivos eliminados."
        log_action "Archivos eliminados en $directory con más de $days días"
    else
        echo "Limpieza cancelada."
    fi
}

check_root
clean_temp_files
