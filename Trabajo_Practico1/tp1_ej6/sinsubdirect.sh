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

