#!/bin/bash

echo "Actualizando lista de paquetes..."
sudo apt update

echo "Actualizando paquetes instalados..."
sudo apt upgrade -y

echo "Eliminando paquetes innecesarios..."
sudo apt autoremove -y

echo "Limpiando caché de paquetes..."
sudo apt clean

echo "Mantenimiento del sistema completado"
 
