#!/bin/bash

# Verificar si UFW está instalado
if ! command -v ufw &> /dev/null; then
    echo "UFW no está instalado. Instalando UFW..."
    sudo apt-get install ufw -y
fi

# Activar UFW si no está activo
if [[ $(sudo ufw status | grep -i "inactive") ]]; then
    echo "Activando UFW..."
    sudo ufw enable
fi

# Definir puertos que pueden ser vulnerables a ataques
vulnerable_ports=(21 23 25 110 143 445 465 587 993 995 2049 3306 3389 5900 8080)

# Función para abrir o cerrar un puerto
manage_ports() {
    action=$1  # "allow" o "deny"
    for port in "${vulnerable_ports[@]}"; do
        echo "¿Deseas $action el puerto $port? (s/n)"
        read -r response
        if [[ $response == "s" ]]; then
            if [[ $action == "allow" ]]; then
                echo "Abriendo puerto $port..."
                sudo ufw allow $port
            else
                echo "Cerrando puerto $port..."
                sudo ufw deny $port
            fi
        fi
    done
}

# Función para gestionar el tiempo de cierre de puertos
manage_time() {
    echo "¿Quieres cerrar los puertos por un tiempo limitado? (s/n)"
    read -r timed_choice
    if [[ $timed_choice == "s" ]]; then
        echo "Introduce el tiempo en segundos para mantener los puertos cerrados:"
        read -r seconds
        echo "Los puertos permanecerán cerrados durante $seconds segundos."
        sleep "$seconds"
        echo "Reabriendo puertos vulnerables..."
        manage_ports "allow"
    else
        echo "Los puertos permanecerán cerrados hasta que los reabras manualmente."
    fi
}

# Menú para el usuario
while true; do
    echo "Elija una opción:"
    echo "1. Cerrar puertos vulnerables"
    echo "2. Abrir puertos vulnerables"
    echo "3. Salir"
    read -r option

    case $option in
        1)
            manage_ports "deny"
            manage_time
            ;;
        2)
            manage_ports "allow"
            ;;
        3)
            echo "Saliendo..."
            break
            ;;
        *)
            echo "Opción no válida, por favor elige 1, 2 o 3."
            ;;
    esac
done

# Mostrar el estado final de UFW
echo "Estado de UFW:"
sudo ufw status verbose
