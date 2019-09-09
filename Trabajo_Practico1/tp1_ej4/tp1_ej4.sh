#!/bin/bash

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
	echo
	echo "Procesando...."
	echo 
	find "$1" -name "*.$2" > Resultados #aca almaceno la ruta a los archivos
	lcodigo=0
	lcomentarios=0
	cantFicheros=`wc -l Resultados`
	ltotales=0

	while IFS= read -r line
	do
		awk -f codigo.awk $line;
		lcodigo=$(( lcodigo+`cat cod.txt` ))
		lcomentarios=$(( lcomentarios+`cat com.txt` ))
		ltotales=$(( ltotales+`cat lineas.txt` ))
	done < Resultados


	lporCom=$(echo "scale = 2; $lcomentarios/$ltotales" | bc)
	lporCod=$(echo "scale = 2; $lcodigo/$ltotales" | bc)
	echo "Sobre la cantidad de ficheros: $cantFicheros "
    echo "Se obtuvo:"
    echo "== ======"
    echo "              Total de Lineas: $ltotales"
	echo "    Total de Lineas de Codigo: $lcodigo"
	echo "  Porcentaje de lineas Codigo: $lporCod%"
	echo "      Total lineas comentadas: $lcomentarios"
	echo " Porcentaje lineas comentadas: $lporCom%"
	echo
	rm Resultados
	rm cod.txt
	rm com.txt
	rm lineas.txt
fi

