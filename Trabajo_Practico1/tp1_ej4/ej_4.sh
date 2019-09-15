#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "ej_4.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 4
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

ayuda()
{
    echo    
    echo "Ayuda del Script"
    echo "===== === ======"
    echo 
    echo "Descripcion:"
    echo
    echo "          El script se utiliza para contar la cantidad"
    echo "          de lineas de codigo y de comentario para una ruta y"
    echo "          extension que usted desee consultar.               "
    echo 
    echo "Parametros:"
    echo 
    echo "          [ruta] [extension] para que el script devuelva lo siguiente"
    echo "          1. Cantidad de archivos analizados"
    echo "          2. Cantidad de lineas de codigo totales y % contra el total de lineas"
    echo "          3. Cantidad de lineas comentadas total  y % contra el total de lineas"
    echo
	echo "Si el directorio contiene espacios, utilice comillas para indicar la [ruta]"
	echo 
}

errorSintax()
{
    echo "Hay un error en la sintaxis"
	echo "La sintaxis correspondiente es la siguiente:"
	echo
	echo "$0 [ruta] [extension]"
	echo "$0 -h para obtener la ayuda del script"
	echo
}

if test $# -eq 1; then
    if test $1 = "-h"; then
    ayuda
    else
    echo "utilice $0 -h para la ayuda"
fi
elif test $# -gt 2; then
errorSintax
elif ! test -d "$1"; then
echo "imposible continuar, el directorio no existe..."
else
	echo
	echo "Procesando...."
	echo 
	find "$1" -name "*.$2" > /tmp/resultados #aca almaceno la ruta a los archivos
	lcodigo=0
	lcomentarios=0
	cantFicheros=`wc -l "/tmp/resultados" | awk '{print $1}'`;
	ltotales=0

	while IFS= read -r line
	do
		awk -f analisis.awk "$line";
		lcodigo=$(( lcodigo+`cat "/tmp/cod.txt"` ))
		lcomentarios=$(( lcomentarios+`cat "/tmp/com.txt"` ))
		lineasfichero=`wc -l "$line" | awk '{print $1}'`;
		ltotales=$(( ltotales+lineasfichero ))
	done < "/tmp/resultados"

	lporCom=$(echo "scale = 2; $lcomentarios*100/$ltotales" | bc)
	lporCod=$(echo "scale = 2; $lcodigo*100/$ltotales" | bc)
	
	echo "Sobre la cantidad de ficheros: $cantFicheros" 
    echo "Se obtuvo:"
    echo "== ======"
    echo "              Total de Lineas: $ltotales"
	echo "    Total de Lineas de Codigo: $lcodigo"
	echo "  Porcentaje de lineas Codigo: $lporCod%"
	echo "      Total lineas comentadas: $lcomentarios"
	echo " Porcentaje lineas comentadas: $lporCom%"
	echo
	rm "/tmp/resultados"
	rm "/tmp/cod.txt"
	rm "/tmp/com.txt"
fi

