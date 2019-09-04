#!/bin/bash

if test $# -eq 0 ; #Si no envio parametro toma la direccion actual
then
direc=$(pwd);
elif [ $1 = "-h" ] ; then #Si el parametro enviado es consulta de ayuda muestro informacion
echo "Voy a mostrar ayuda"
#SALIR
elif [ $1 = "--help" ] ; then #Si el parametro enviado es consulta de ayuda extendida muestro informacion
echo "Voy a mostrar ayuda extendida"
#SALIR
elif [ -d "$1" ] ; then # valido si es una direccion
direc=$1
else 
    echo "El directorio ${direc} no existe"
#SALIR
fi 
if [ -d "$direc" ] ; then
echo "Voy a trabajar en la direccion: $direc"

cd $direc
echo "Archivos que voy a evaluar:"
find . -depth -name '* *'  
while IFS= read -r f ; 
do 
echo "=$f="
#mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr 'v' _)"; 
done
fi


