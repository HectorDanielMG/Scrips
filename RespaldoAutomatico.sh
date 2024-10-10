#!/bin/bash
# Script para realizar respaldo automático

# Variables
DIR_ORIGEN=${1:-"/ruta/al/directorio"}  # Directorio a respaldar (argumento 1)
DIR_DESTINO=${2:-"/ruta/al/respaldo"}  # Directorio de respaldo (argumento 2)
NOMBRE_RESPALDO="respaldo_$(date +%Y%m%d_%H%M%S).tar.gz"  # Nombre del archivo de respaldo

# Crear respaldo
echo "Creando respaldo del directorio $DIR_ORIGEN en $DIR_DESTINO/$NOMBRE_RESPALDO"
tar -czvf "$DIR_DESTINO/$NOMBRE_RESPALDO" "$DIR_ORIGEN"

if [[ $? -eq 0 ]]; then
  echo "Respaldo completado exitosamente."
else
  echo "Hubo un error al crear el respaldo."
fi

# Limpiar respaldos antiguos (opcional, deja solo los últimos 5 respaldos)
echo "¿Desea eliminar respaldos antiguos y dejar solo los 5 más recientes? (y/n)"
read -r respuesta
if [[ $respuesta == "y" ]]; then
  ls -tp "$DIR_DESTINO"/*.tar.gz | grep -v '/$' | tail -n +6 | xargs -I {} rm -- {}
  echo "Respaldos antiguos eliminados."
fi
