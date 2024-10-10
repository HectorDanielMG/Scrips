 #!/bin/bash

# Directorios de origen y destino
ORIGEN="/ruta/a/origen"
DESTINO="/ruta/a/destino"

# Crear respaldo incremental
rsync -av --update --ignore-existing --log-file=/ruta/a/logs/backup_incremental.log $ORIGEN $DESTINO

echo "Respaldo incremental realizado con éxito"

