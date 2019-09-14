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
	echo "		-l lista los archivos que contiene la papelera de reciclaje."
	echo 	
	echo "		-r [archivo] recupera el archivo pasado por parámetro a su"
	echo "		ubicación original."
	echo		
	echo "		-e vacia la papelera de reciclaje (elimina definitivamente)"
	echo
	echo "		[archivo] mueve el archivo a la papelera de reciclaje."
	echo 
	echo "Ejemplos:"
	echo
	echo "		./tp1_ej5.sh -l"
	echo 
	echo "		./tp1_ej5.sh -r archivoARecuperar.txt"
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
	echo "Parametro/s no valido/s o archivo inexistente, utilice –h, -? o –help para obtener ayuda"
	echo
}

PapeleraVacia()
{
	echo ""
	echo "No hay archivos en la papelera"
	echo ""
}

if test $# -lt 1 || test $# -gt 2; then #cantidad de parametros validos
	ErrorSintax
	exit
fi

mkdir ~/.papelera 2> /dev/null #crea la papelera si no existe, omite mensajes por consola

if test $# -eq 1; then #para 1 parametro
	
	if test "$1" = "-?" || test "$1" = "-h" || test "$1" = "-help";then #si se solicita ayuda
		help

	elif test "$1" = "-l"; then #si es el parametro "-l"
		
		if [ `ls ~/.papelera/ | wc -l` -ne 0 ]; then #verifica si la cantidad de ficheros que tiene la papelera no es cero
			archivos=`ls ~/.papelera -1 -c`
			echo ""
			echo "	Archivos de la papelera"
			echo "	======================="
			echo "Nombre"
			echo "------"
			echo "$archivos"
			echo ""
		else	
			PapeleraVacia
		fi
	
	elif test "$1" = "-e"; then #sino pregunta si es el parametro "-e"
		rm -r ~/.papelera/ #borra la papelera junto con todo su contenido
		mkdir ~/.papelera 2> /dev/null #vuelve a crear la papelera vacia
		echo ""
		echo "La papelera fue vaciada"
		echo ""
		
	elif test -f "$1"; then #sino pregunta si es una ruta de un archivo existente		
		ruta=`realpath "$1"` #obtiene la ruta del fichero
		nombre=`basename "$1"` #obtiene el nombre del fichero
		cantArchivos=`ls ~/.papelera/"\$nombre"* 2> /dev/null | wc -l` #obtiene la cantidad de archivos con el mismo nombre
		echo "$ruta$cantArchivos" >> ~/.papelera/.rutas.txt #guarda la ruta en un fichero oculto
		mv "$1" ~/.papelera/"$nombre$cantArchivos" #mueve el archivo a la papelera
		echo ""		
		echo "El archivo fue movido a la papelera"
		echo ""		

	else #sino es ninguna de las anteriores
		ErrorParametro
	fi

elif test "$1" = "-r"; then #sino tiene un parametro, hay 2 que deben ser -r y el nombre del archivo con su extensión
	if [ `ls ~/.papelera/ | wc -l` -ne 0 ]; then #verifica si la cantidad de ficheros que tiene la papelera no es cero	
		echo "" > ~/.papelera/.norestaurar.txt
		awk -F/ -v archivo=$2	'BEGIN{
									cont=0;
								}
								
								{
								expresion="^"archivo"[0-9]";
								if ($NF ~ expresion)
									{nombreSinNro=substr($0, 1, length($0)-1);
									system("mv ~/.papelera/"$NF" "nombreSinNro" ");
									cont++;
								}
								else
									system("echo "$0" >> ~/.papelera/.norestaurar.txt");
								}
		
								END{
									if(cont == 0)
										printf "\nNo se encontro ningún archivo en la papelera que coincida con la búsqueda. Debe indicar el nombre del archivo y la extensión, intente de nuevo\n\n";
									else
										{printf "\nEl/los archivo/s se ha/n restaurado a su ubicación original\n\n";
										system("mv ~/.papelera/.norestaurar.txt ~/.papelera/.rutas.txt");
										}
								}' ~/.papelera/.rutas.txt
	else
		PapeleraVacia
	fi
fi
