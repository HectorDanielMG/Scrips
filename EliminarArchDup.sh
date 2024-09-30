#!/bin/bash

# Directorio a buscar duplicados
DIR="/ruta/a/directorio"

# Buscar y eliminar duplicados
find "$DIR" -type f -exec md5sum {} + | sort | uniq -w32 -dD | while read MD5SUM FILE; do
    echo "Eliminando duplicado: $FILE"
    rm "$FILE"
done

echo "Limpieza de duplicados completada."
