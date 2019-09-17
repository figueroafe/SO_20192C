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
#       ----------------------                          ----------
#       ---------------------                           ----------
#       Sergio Salas                                    32.090.753                 
#       --------------------- 		                	----------
#       ---------------------       	     			----------
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
path="$1"

dirwsub=$(find "$path" -maxdepth 2 -type d)


find /home/sergio/Documents -maxdepth 2 -type d | awk '/\.?\/Documents\/\w/'

[0-9a-fA-F_-]

find /home/sergio/Documents -maxdepth 2 -type d | awk '/\.?\/Documents\/[0-9a-fA-F]/'

find /home/sergio/Documents -maxdepth 2 -type d | awk '/\.?\/Documents\/(?!\/)/'

find /home/sergio/Documents -maxdepth 2 -type d | awk '/\.?\/Documents\/(?:(?!\/).)*/'


^(?:(?!ab).)+$

find /home/sergio/Documents -maxdepth 2 -type d | awk '/\.?\/Documents\/^(?:([\/]).)+$/'


#########################################
#! /bin/bash

path="/home/sergio/Documents"

readarray vect1 <<< "$(find "$path" -maxdepth 2 -mindepth 1  -type d)"

readarray vect2 <<< "$(find "$path" -maxdepth 2 -mindepth 2  -type d)"

vwsubd=()

echo "${vect1[@]}"
echo
echo "${vect2[@]}"

for i in "${vect1[@]}"; do

    count=${#vect2[@]}

    for j in "${vect2[@]}"; do    

        echo "vect1"
        echo "$i"
        echo
        echo "vect2"
        echo "$j"
        count=$(($count-1))

        if [ "$i" != "$j" ];
        then
            echo "entro"
            aux=("$i")
        else
            flag=1
        fi
    done

    if [ $count -eq 0 && $flag -eq 0 ];
    then
        vwsubd+=("$aux")
    fi

    flag=0
done

echo "vector final"
echo "${vwsubd[@]}"