#!/bin/bash
# Script para monitorear el sistema

echo "=== Monitoreo del sistema ==="
echo "Fecha y hora: $(date)"

# Uso de CPU
echo -e "\nUso de CPU:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU: " $2 + $4 "%"}'

# Uso de memoria
echo -e "\nUso de Memoria:"
free -h | awk '/Mem/ {print "Memoria usada: " $3 " / " $2}'

# Espacio en disco
echo -e "\nEspacio en disco:"
df -h | grep '^/dev/' | awk '{print $1 ": " $3 " usado de " $2 " (" $5 " lleno)"}'

# Monitorizar servicios importantes (ejemplo: SSH y Apache)
echo -e "\nEstado de servicios importantes:"
for service in ssh apache2; do
  if systemctl is-active --quiet $service; then
    echo "$service está corriendo."
  else
    echo "$service no está corriendo."
  fi
done

# Mostrar procesos con mayor uso de CPU
echo -e "\nProcesos con mayor uso de CPU:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10

echo -e "\nMonitoreo completo."
