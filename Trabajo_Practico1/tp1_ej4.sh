#!/bin/bash

#validarPath()
#{
    
#}

ayuda()
{
    echo    
    echo "Ayuda del Script"
    echo "===== === ======"
    echo 
    echo "Descripcion:"
    echo
    echo "          El script se puede utilizar para contar la cantidad"
    echo "          de lineas de codigo y de comentario para una ruta y"
    echo "          extension que usted desee consultar.               "
    echo 
    echo "Parametros:"
    echo 
    echo "          [ruta] [extension] para que el script devuelva lo siguiente"
    echo "          1. Cantidad de archivos analizados"
    echo "          2. Cantidad de lineas de codigo totales y % contra el total"
    echo "          3. Cantidad de lineas comentadas total y % contra el total"
    echo 
}

errorSintax()
{
    echo "Hay un error de sintaxis"
}

if test $# -eq 1; then
    if test $1 = "-h"; then
    ayuda
    else
    echo "pulse -h para la ayuda"
fi
elif test $# -lt 2; then
errorSintax
elif ! test -d $1; then
echo "imposible continuar, el directorio no existe..."
else
echo "es un directorio correcto"
find "$1" -name "*.$2"
 
fi

