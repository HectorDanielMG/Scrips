#!/bin/bash
# Script para buscar y eliminar archivos duplicados

DIR=${1:-.}  # El directorio por defecto es el actual si no se especifica

echo "Buscando archivos duplicados en el directorio: $DIR"

# Buscar duplicados usando hash MD5
find "$DIR" -type f -exec md5sum {} + | sort | uniq -w32 -dD | tee duplicados.txt

# Mostrar los archivos duplicados encontrados
if [[ -s duplicados.txt ]]; then
  echo "Se han encontrado los siguientes archivos duplicados:"
  cat duplicados.txt
  echo "¿Desea eliminar los archivos duplicados? (y/n)"
  read -r respuesta
  if [[ $respuesta == "y" ]]; then
    # Eliminar los duplicados
    cat duplicados.txt | awk '{print $2}' | xargs rm -v
    echo "Archivos duplicados eliminados."
  else
    echo "No se eliminaron archivos."
  fi
else
  echo "No se encontraron archivos duplicados."
fi

# Limpiar el archivo temporal
rm -f duplicados.txt
