#!/bin/bash

# Archivo de registro para registrar la actividad
LOG_FILE="respaldo_automatico.log"

# Función para verificar si se ejecuta con permisos de superusuario
function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script necesita permisos de superusuario. Ejecuta con sudo."
        exit 1
    fi
}

# Función para registrar acciones en el archivo de log
function log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Función para realizar el respaldo
function make_backup() {
    # Configuración del directorio de origen y destino
    read -p "Directorio de origen para el respaldo: " source_dir
    read -p "Directorio de destino para almacenar el respaldo: " backup_dir
    mkdir -p "$backup_dir"

    # Nombre del archivo de respaldo con fecha
    backup_file="$backup_dir/backup_$(date '+%Y%m%d_%H%M%S').tar.gz"

    # Compresión y respaldo
    tar -czf "$backup_file" "$source_dir" &>/dev/null

    # Verificar éxito de respaldo
    if [[ $? -eq 0 ]]; then
        echo "Respaldo completado exitosamente en: $backup_file"
        log_action "Respaldo exitoso: $backup_file"
    else
        echo "Error al crear el respaldo."
        log_action "Error al crear el respaldo de $source_dir"
    fi
}

# Función para agendar respaldos automáticos
function schedule_backup() {
    read -p "Frecuencia en minutos para el respaldo automático: " frequency
    cron_cmd="*/$frequency * * * * /bin/bash $(realpath "$0") >> $(realpath "$LOG_FILE") 2>&1"
    (crontab -l 2>/dev/null; echo "$cron_cmd") | crontab -
    echo "Respaldo automático programado cada $frequency minutos."
    log_action "Respaldo automático programado cada $frequency minutos"
}

check_root
make_backup
schedule_backup
