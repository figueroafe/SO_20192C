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







#########################################
