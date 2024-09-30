#!/bin/bash

# Obtener la lista de direcciones IP a bloquear
IP_LIST="ip_list.txt"

# Verificar que el script se ejecute como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ser ejecutado como root."
  exit 1
fi

# Comprobar si el archivo de lista de IP existe
if [ ! -f "$IP_LIST" ]; then
  echo "El archivo $IP_LIST no existe."
  exit 1
fi

# Leer cada dirección IP del archivo y bloquearla en el puerto 22
while IFS= read -r ip; do
  # Bloquear la IP utilizando iptables
  iptables -A INPUT -s "$ip" -p tcp --destination-port 22 -j DROP
  echo "IP $ip bloqueada en el puerto 22."
done < "$IP_LIST"

# Guardar la configuración del firewall
iptables-save > /etc/iptables/rules.v4

echo "Las direcciones IP en $IP_LIST han sido bloqueadas en el puerto 22."

