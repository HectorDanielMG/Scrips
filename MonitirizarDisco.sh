#!/bin/bash

# Configuración de umbral de uso de disco en porcentaje
UMBRAL=80

# Archivo de registro para eventos de alta utilización
LOG_FILE="disco_alertas.log"

# Función para verificar uso de disco y emitir alertas
function verificar_uso_disco() {
    echo "Revisando uso del disco..."

    # Iterar sobre cada sistema de archivos
    df -h --output=source,pcent,target | grep '^/' | while read -r filesystem usage mountpoint; do
        # Eliminar el símbolo de porcentaje para la comparación numérica
        uso_sin_porcentaje=${usage%?}

        # Mostrar el uso de cada sistema de archivos
        echo "Sistema de archivos: $filesystem | Uso: $usage | Punto de montaje: $mountpoint"

        # Verificar si el uso supera el umbral
        if (( uso_sin_porcentaje > UMBRAL )); then
            # Registrar alerta en el log
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERTA: Uso del disco en $filesystem ($mountpoint) ha superado el $UMBRAL% ($usage)" >> "$LOG_FILE"
            
            # Enviar notificación visual
            notify-send "ALERTA de Uso de Disco" "El uso del disco en $mountpoint ha alcanzado $usage."
            
            # Opción: reproducir alerta sonora (descomentar la línea siguiente si lo deseas)
            # paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
        fi
    done
}

# Verificar el uso del disco
verificar_uso_disco

echo "Monitoreo completado. Consulte $LOG_FILE para ver alertas anteriores."
