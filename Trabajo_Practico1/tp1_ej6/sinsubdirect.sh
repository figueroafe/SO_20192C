#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "ej_6.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 6
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           ----------
#       Francisco Figueroa	                            32.905.374
#       Adrian Morel		                            34.437.202
#       Sergio Salas                                    32.090.753                 
#       Fernando Sanchez	 		                	36.822.171
#       Sabrina Tejada			       	     			37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

#!/bin/bash


if test $# -eq 0 ; #Si no envio parametro toma la direccion actual
then
    direc="$(pwd)";
elif [[ -d "$1" && $# = 1 ]] ; then #valido si es una direccion para un unico param
    direc="$1"
else
    echo "ERROR: los parametros ingresados son invalidos"
    exit
fi 

echo "Voy a trabajar en el directorio: $direc"
cd "$direc"; 
find -links 2 -type d > /tmp/archivo.txt
find -mindepth 2 -type d > /tmp/nivel2.txt
dirwsub=$(diff /tmp/nivel2.txt /tmp/archivo.txt)

