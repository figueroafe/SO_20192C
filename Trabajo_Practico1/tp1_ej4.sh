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
lcodigo=0
lcomentarios=0
cantFicheros=0
ltotales=0
find "$1" -name "*.$2" > resultados #aca almaceno la ruta a los archivos
# leo el archivo y mientras no se de fin de archivo
# ejecuto un awk para el fichero leido en la linea 
# ese awk tendra que ir acumulando en una variable "crearla aca"
# rm eliminar  
echo "Sobre la cantidad de ficheros: $cantFicheros se obtuvo:"
echo "    Total de Lineas de Codigo: $lcodigo "
#echo "  Porcentaje de lineas Codigo: (($lcodigo / $ltotales)) "
echo "      Total lineas comentadas: $lcomentarios "
#echo " Porcentaje lineas comentadas: (($lcomentarios / $ltotales))"
echo
rm resultados
fi

