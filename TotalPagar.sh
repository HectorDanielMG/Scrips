#!/bin/bash

# Solicitar datos del trabajador
echo "Ingrese el nombre del trabajador:"
read nombre
echo "Ingrese la direccion del trabajador:"
read direccion
echo "Ingrese el puesto del trabajador:"
read puesto
echo "Ingrese el sueldo semanal del trabajador:"
read sueldo_semanal
echo "Ingrese el numero de dias trabajados:"
read dias_trabajados
echo "Ingrese el numero de horas extras trabajadas:"
read horas_extras

# Calcular pago de horas extras
pago_por_dia=$(expr $sueldo_semanal \/ 6)
pago_por_hora=$(expr $pago_por_dia \/ 8)

if [ $horas_extras -le 8 ]
then
    pago_horas_extras=$(expr $pago_por_hora \* 2 \* $horas_extras)
    
else
    pago_doble=$(expr $pago_por_hora \* 2 \* 8)
    horas_restantes=$(expr $horas_extras - 8)
    pago_triple=$(expr $pago_por_hora \* 3 \* $horas_restantes)
    pago_horas_extras=$(expr $pago_doble + $pago_triple)
  
fi

# Calcular pago total

total_pagar=$(expr $pago_horas_extras + $sueldo_semanal )

# Calcular deducciones
if [ $total_pagar -le 3000 ]
then
    lsir=$(expr $total_pagar \* 4 / 100)
else
    lsir=$(expr $total_pagar \* 7 / 100)
fi

if [ $total_pagar -le 3500 ]
then
    imss=$(expr $total_pagar \* 3 / 100)
else
    imss=$(expr $total_pagar \* 5 / 100)
fi

cuota_sindical=$(expr $total_pagar \* 2 / 100)

total_deducciones=$(expr $lsir + $imss + $cuota_sindical)

# Mostrar resultados
echo "  "
echo "Nombre del trabajador: $nombre"
echo "Direccion del trabajador: $direccion"
echo "Puesto del trabajador: $puesto"
echo "Sueldo semanal: $sueldo_semanal"
echo "Dias trabajados: $dias_trabajados"
echo "Horas extras trabajadas: $horas_extras"
echo "Pago de horas extras: $pago_horas_extras"
echo "Total a pagar: $total_pagar"
echo "Deducciones:"
echo " - LSIR: $lsir"
echo " - IMSS: $imss"
echo " - Cuota sindical: $cuota_sindical"
echo "Total de deducciones: $total_deducciones"
echo "Total neto a pagar: $(expr $total_pagar - $total_deducciones)"
