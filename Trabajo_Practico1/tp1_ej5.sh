# Trabajo Practico 1
# Ejercicio 5
# ***Alumnos***
#
#
#
#
#
#
#


#!bin/bash

help()
{
	echo
	echo "Ayuda del script"
	echo "===== === ======"
	echo
	echo "Descripcion:"
	echo
	echo "		El script emula el comportamiento del comando rm, pero"
	echo "		utilizando el concepto de “papelera de reciclaje”. Al "
	echo "		borrar un archivo se tiene la posibilidad de recuperarlo"
	echo "		en el futuro."
	echo
	echo "Parametros:"
	echo
	echo "		-l listar los archivos que contiene la papelera de reciclaje."
	echo 	
	echo "		-r [archivo] recuperar el archivo pasado por parámetro a su"
	echo "		ubicación original."
	echo		
	echo "		-e vaciar la papelera de reciclaje (eliminar definitivamente)"
	echo
	echo "		[archivo] para que elimine el archivo."
	echo 
	echo "Ejemplos:"
	echo
	echo "		./tp1_ej5.sh -l"
	echo 
	echo "		./tp1_ej5.sh -r ./archivoARecuperar.txt"
	echo 
	exit
}

ErrorSintax()
{
	echo
  	echo "La sintaxis no es correcta, utilice –h, -? o –help para obtener ayuda"
	echo	
}

ErrorParametro()
{
	echo
	echo "Parametro/s no valido/s, utilice –h, -? o –help para obtener ayuda"
	echo
}

if test $# -lt 1 || test $# -gt 2; then #cantidad de parametros validos
	ErrorSintax
	exit
fi

mkdir ~/.papelera 2> /dev/null #crea el archivo si no existe, omite mensajes por consola


if test $# -eq 1; then #para 1 parametro
	
	if test "$1" = "-?" || test "$1" = "-h" || test "$1" = "-help";then #si se solicita ayuda
		help

	elif test "$1" = "-l"; then #si es el parametro "-l"
		ls ~/.papelera -a
	
	elif test "$1" = "-e"; then #sino pregunta si es el parametro "-e"
		rm -r ~/.papelera/ #borra la papelera junto con todo su contenido
		mkdir ~/.papelera 2> /dev/null #vuelve a crear la papelera vacia
	
	elif test -f "$1"; then #sino pregunta si es una ruta de un archivo existente
		echo "es una ruta valida"
		mv "$1" ~/.papelera

	else #sino es ninguna de las anteriores
		ErrorParametro
	fi

elif test "$1" = "-r" && test -f "$2"; then #sino tiene un parametro, hay 2 que deben ser -r y un path de archivo existente.
	echo "Tengo 2 parametros validos" 

else
	ErrorParametro
fi

#fin archivo
