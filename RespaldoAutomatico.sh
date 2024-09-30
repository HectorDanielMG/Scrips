#!/bin/bash

# Directorio a respaldar
SOURCE_DIR="/ruta/a/tu/carpeta"

# Directorio donde se guardará la copia de seguridad
BACKUP_DIR="/ruta/a/carpeta_backup"

# Fecha actual para nombrar el archivo
DATE=$(date +%Y-%m-%d)

# Nombre del archivo de backup
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

# Crear el archivo comprimido
tar -czf $BACKUP_FILE $SOURCE_DIR

# Mostrar mensaje de éxito
echo "Copia de seguridad completada: $BACKUP_FILE"
