 
#!/bin/bash

# Definir directorios de archivos temporales
TEMP_DIRS=("/tmp" "/var/tmp" "/home/usuario/temp")

# Definir cantidad de días para eliminar archivos antiguos
DIAS=7

for dir in "${TEMP_DIRS[@]}"; do
    echo "Limpiando $dir de archivos mayores a $DIAS días..."
    find "$dir" -type f -mtime +$DIAS -exec rm -f {} \;
done

echo "Limpieza de archivos temporales completada"
