#!/bin/bash

LOG_FILE="puertos_log.txt"

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script necesita permisos de superusuario. Ejecuta con sudo."
        exit 1
    fi
}

function log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

function is_port_open() {
    ufw status | grep -q "$1.*ALLOW"
}

function open_port() {
    if is_port_open "$1"; then
        echo "El puerto $1 ya está abierto."
    else
        ufw allow "$1"
        echo "Puerto $1 abierto."
        log_action "Puerto $1 abierto"
    fi
}

function close_port() {
    if ! is_port_open "$1"; then
        echo "El puerto $1 ya está cerrado."
    else
        ufw deny "$1"
        echo "Puerto $1 cerrado."
        log_action "Puerto $1 cerrado"
    fi
}

function manage_ports() {
    read -p "Ingresa los puertos a gestionar (separados por comas): " ports
    read -p "Abrir (a) o cerrar (c) los puertos? " action

    IFS=',' read -r -a port_array <<< "$ports"

    for port in "${port_array[@]}"; do
        if [[ ! $port =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
            echo "El puerto $port no es válido. Debe ser un número entre 1 y 65535."
            continue
        fi

        if [[ "$action" == "a" ]]; then
            open_port "$port"
        elif [[ "$action" == "c" ]]; then
            close_port "$port"
        else
            echo "Opción no válida. Usa 'a' para abrir o 'c' para cerrar."
            exit 1
        fi
    done
}

# Ejecutar el script con verificación de permisos
check_root
manage_ports
ufw reload
