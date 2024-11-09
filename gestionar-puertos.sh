#!/bin/bash

# Script de Gestión de Puertos

echo "=== Gestión de Puertos ==="
echo "Seleccione una opción:"
echo "1. Verificar el estado de un puerto"
echo "2. Abrir un puerto (requiere privilegios de superusuario)"
echo "3. Cerrar un puerto (requiere privilegios de superusuario)"
echo "4. Listar servicios que utilizan puertos específicos"
echo "5. Salir"

read -p "Ingrese su elección [1-5]: " choice

# Función para verificar el estado de un puerto
function verificar_puerto {
    read -p "Ingrese el número de puerto a verificar: " port
    if sudo lsof -i :$port >/dev/null; then
        echo "El puerto $port está en uso."
    else
        echo "El puerto $port está libre."
    fi
}

# Función para abrir un puerto (requiere privilegios de superusuario)
function abrir_puerto {
    read -p "Ingrese el número de puerto a abrir: " port
    sudo ufw allow $port
    echo "El puerto $port ha sido abierto."
}

# Función para cerrar un puerto (requiere privilegios de superusuario)
function cerrar_puerto {
    read -p "Ingrese el número de puerto a cerrar: " port
    sudo ufw deny $port
    echo "El puerto $port ha sido cerrado."
}

# Función para listar servicios que utilizan puertos específicos
function listar_servicios {
    echo "Listado de puertos en uso y sus servicios:"
    sudo lsof -i -P -n | grep LISTEN
}

# Ejecución de la opción seleccionada
case $choice in
    1) verificar_puerto ;;
    2) abrir_puerto ;;
    3) cerrar_puerto ;;
    4) listar_servicios ;;
    5) echo "Saliendo..." ;;
    *) echo "Opción no válida. Por favor, seleccione una opción entre 1 y 5." ;;
esac
