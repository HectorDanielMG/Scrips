#!/bin/bash
# Script avanzado para monitorear el sistema

echo "=== Monitoreo del sistema ==="
echo "Fecha y hora: $(date)"
echo "=============================="

# Uso de CPU
echo -e "\nUso de CPU:"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "CPU: $cpu_usage%"

# Temperatura de la CPU (requiere 'sensors' instalado)
if command -v sensors &> /dev/null; then
  echo -e "\nTemperatura de la CPU:"
  sensors | grep -E '^(Package id|Core|temp1)' | awk '{print $1 ": " $2}'
else
  echo -e "\nTemperatura de la CPU: No disponible (instala 'sensors' para habilitar)"
fi

# Uso de memoria
echo -e "\nUso de Memoria:"
free -h | awk '/Mem/ {print "Memoria usada: " $3 " / " $2}'
free -h | awk '/Swap/ {print "Swap usada: " $3 " / " $2}'

# Espacio en disco
echo -e "\nEspacio en disco:"
df -h | grep '^/dev/' | awk '{print $1 ": " $3 " usado de " $2 " (" $5 " lleno)"}'

# Monitorizar servicios importantes (SSH, Apache2, y otros configurables)
echo -e "\nEstado de servicios importantes:"
services=("ssh" "apache2" "mysql") # Añadir servicios adicionales aquí
for service in "${services[@]}"; do
  if systemctl is-active --quiet $service; then
    echo "$service está corriendo."
  else
    echo "$service no está corriendo."
  fi
done

# Actividad de red
echo -e "\nActividad de red:"
if command -v ifstat &> /dev/null; then
  ifstat -i $(ip route | grep '^default' | awk '{print $5}') 1 1 | tail -1
else
  echo "Herramienta ifstat no disponible. Instálala para ver detalles de red."
fi

# Procesos con mayor uso de CPU y memoria
echo -e "\nProcesos con mayor uso de CPU y memoria:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10

echo -e "\nMonitoreo completo."
