#!/bin/bash

LOG_FILE="sys_admin_utility.log"

# Función para mostrar el menú de opciones
mostrar_menu() {
    echo "===================================="
    echo "      Utilidades de Administración"
    echo "===================================="
    echo "1. Escanear puertos abiertos en el sistema"
    echo "2. Configurar el cortafuegos (UFW)"
    echo "3. Monitorizar los procesos más pesados"
    echo "4. Ver estado del sistema"
    echo "5. Configurar red (cambiar IP, DNS)"
    echo "6. Ver log de operaciones"
    echo "7. Salir"
    echo "===================================="
}

# Función para registrar logs
registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Función para escanear puertos abiertos
escanear_puertos() {
    echo "Escaneando puertos abiertos..."
    sudo netstat -tuln | grep LISTEN
    echo "Escaneo completado."
    registrar_log "Escaneo de puertos completado."
}

# Función para configurar el cortafuegos UFW
configurar_firewall() {
    echo "Configurando el cortafuegos (UFW)..."
    echo "1. Activar UFW"
    echo "2. Desactivar UFW"
    echo "3. Permitir puerto"
    echo "4. Denegar puerto"
    echo "5. Ver estado de UFW"
    echo "6. Salir"
    read -p "Selecciona una opción: " opcion_fw

    case $opcion_fw in
        1)
            sudo ufw enable
            echo "Cortafuegos activado."
            registrar_log "Cortafuegos activado."
            ;;
        2)
            sudo ufw disable
            echo "Cortafuegos desactivado."
            registrar_log "Cortafuegos desactivado."
            ;;
        3)
            read -p "Ingresa el número de puerto que deseas permitir: " puerto
            if [[ $puerto -ge 1 && $puerto -le 65535 ]]; then
                sudo ufw allow $puerto
                echo "Puerto $puerto permitido."
                registrar_log "Puerto $puerto permitido."
            else
                echo "Puerto no válido. Debe ser un número entre 1 y 65535."
            fi
            ;;
        4)
            read -p "Ingresa el número de puerto que deseas denegar: " puerto
            if [[ $puerto -ge 1 && $puerto -le 65535 ]]; then
                sudo ufw deny $puerto
                echo "Puerto $puerto denegado."
                registrar_log "Puerto $puerto denegado."
            else
                echo "Puerto no válido. Debe ser un número entre 1 y 65535."
            fi
            ;;
        5)
            sudo ufw status verbose
            registrar_log "Mostrando estado de UFW."
            ;;
        6)
            return
            ;;
        *)
            echo "Opción no válida. Inténtalo de nuevo."
            ;;
    esac
}

# Función para monitorizar procesos más pesados
monitorizar_procesos() {
    echo "Mostrando los 5 procesos que más consumen CPU..."
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

    echo "Mostrando los 5 procesos que más consumen memoria..."
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

    registrar_log "Monitorización de procesos completada."
}

# Función para ver el estado del sistema
ver_estado_sistema() {
    echo "===================================="
    echo "         Estado del Sistema          "
    echo "===================================="

    echo "Fecha y Hora:"
    date

    echo "Uptime del sistema:"
    uptime

    echo "Uso de Disco:"
    df -h

    echo "Uso de Memoria:"
    free -h

    echo "===================================="

    registrar_log "Estado del sistema visualizado."
}

# Función para configurar la red
configurar_red() {
    echo "1. Cambiar IP"
    echo "2. Cambiar DNS"
    read -p "Selecciona una opción: " opcion_red

    case $opcion_red in
        1)
            read -p "Ingresa la nueva IP estática: " nueva_ip
            read -p "Ingresa la máscara de subred: " mascara
            read -p "Ingresa la puerta de enlace: " gateway

            # Configurar la IP (reemplaza eth0 por la interfaz adecuada)
            sudo ip addr flush dev eth0
            sudo ip addr add $nueva_ip/$mascara dev eth0
            sudo ip route add default via $gateway
            echo "IP configurada como $nueva_ip"
            registrar_log "IP configurada como $nueva_ip"
            ;;
        2)
            read -p "Ingresa el nuevo DNS (separado por espacios si hay más de uno): " dns
            echo "nameserver $dns" | sudo tee /etc/resolv.conf > /dev/null
            echo "DNS configurado como $dns"
            registrar_log "DNS configurado como $dns"
            ;;
        *)
            echo "Opción no válida."
            registrar_log "Error en la configuración de red."
            ;;
    esac
}

# Función para ver el log de operaciones
ver_log_operaciones() {
    if [[ -f $LOG_FILE ]]; then
        echo "=== Log de Operaciones ==="
        cat "$LOG_FILE"
    else
        echo "No se ha encontrado el archivo de log."
    fi
}

# Bucle principal para mostrar el menú y obtener la selección del usuario
while true; do
    mostrar_menu
    read -p "Selecciona una opción: " opcion

    case $opcion in
        1) escanear_puertos ;;
        2) configurar_firewall ;;
        3) monitorizar_procesos ;;
        4) ver_estado_sistema ;;
        5) configurar_red ;;
        6) ver_log_operaciones ;;
        7) echo "Saliendo..."; exit ;;
        *) echo "Opción no válida. Inténtalo de nuevo." ;;
    esac
done
