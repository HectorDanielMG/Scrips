#!/bin/bash

# Establecer el umbral de alerta en porcentaje
THRESHOLD=90

# Obtener el porcentaje de uso del disco
USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Comprobar si el uso supera el umbral
if [ $USAGE -ge $THRESHOLD ]; then
    echo "Advertencia: El uso del disco es de $USAGE%. Considera liberar espacio."
else
    echo "El uso del disco es de $USAGE%. Todo está bien."
fi
