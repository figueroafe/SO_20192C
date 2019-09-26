#! /bin/bash

#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "ej_6.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 6
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           ----------
#       Francisco Figueroa	                            	32.905.374
#       Adrian Morel		                            	34.437.202
#       Sergio Salas                                    	32.090.753
#       Fernando Sanchez	 		                		36.822.171
#       Sabrina Tejada			       	     				37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

#########################################

# Funciones

Ayuda(){
echo    
echo "El script muestra los 10 subdirectorios mas grandes que se encuentran dentro del directorio suministrado"
echo "Parametro path de carpeta a analizar ej /Oracle/client1/diag/Trace"
echo
echo "Ej: ./script.sh /Oracle/client1/diag/Trace"
echo
}

# Fin Funciones

# Verificacion de parametros

param="mal";
if (( $# == 0 ))
then
    param="-nada";
    echo
    echo "Parametros insuficientes"
    Ayuda
    exit
else
    if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]
    then
        Ayuda
        exit;
    fi


    if [ -d "$(dirname "$1")" ]
    then
        if [ ! -r "$(dirname "$1")" ]
        then
            echo " El directorio indicado no tiene permiso de lectura. "
            exit
        fi
    else
        echo "La ruta: "$(dirname "$1")" "
        echo
        echo "No es valida"
        exit
    fi

fi

# Fin Verificacion de parametros

#########################################
#! /bin/bash

path="$1"
vwsubd=()

readarray vect1 <<< "$(find "$path" -maxdepth 1 -mindepth 1  -type d)"

readarray vect2 <<< "$(du -kx -d 1 "$path" | sort -rn | head -n 11 |cut -f2)"

for i in "${vect1[@]}"; do

	tmp=$(echo "$i" | cut -d$'\n' -f1)
	aux=$(find "$tmp" -maxdepth 1 -mindepth 1 -type d | wc -l)

	if [ $aux -eq 0 ];
	then
		vwsubd+=("$i")
	fi

done	

echo "Directorio           Cant Archivos"
echo

for j in "${vect2[@]}"; do

    for h in "${vwsubd[@]}";do

    if [ "$j" == "$h" ];
    then
        tmp=$(echo "$h" | cut -d$'\n' -f1)
        cant=$(find "$tmp" -type f | wc -l)
    
        echo "$tmp"   "  $cant"  "arch"
    
    fi    

    done

done