#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "ej_3.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 3
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           ----------
#       Francisco Figueroa	                            	32.905.374
#       Adrian Morel		                            	34.437.202
#       Sergio Salas                                    	32.090.753                 
#       Fernando Sanchez	 		                		36.822.171
#       Sabrina Tejada			       	     				37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

#!/bin/bash

var=$1

LOCK="/var/lock/bkp.lock"
BKP_SH="./bkpd"

help()
{
    echo
    echo "Ayuda del script"
    echo "=============="
    echo
    echo "Descripcion:"

    echo
    echo "        El script permite crear un demonio de backups"
    echo "        para ellor debe ingresar distintas opciones de ejecucion:"
    echo 
    echo "		  - start - Se debe indicar por parametro el directorio origen "
    echo "		  y el directorio destino asi como el tiempo de ejecucion en segundos."
    echo ""
    echo "		  Ejemplo de ejecucion start:"
    echo ""
    echo "                  ./tp1_ej3.sh start [dirOrigen] [dirDestino] [tiempo de ejecución]"
    echo ""
    echo "                  ./tp1_ej3.sh start /dir/origen /dir/destino 2"
    echo ""
    echo "		  Si desea realizar un backup de un directorio que contiene espacio debe poner el path entre comillas. "
    echo ""
    echo "		  - stop - el demonio detendra su ejecución."
    echo "		  Ejemplo de ejecución stop:"
    echo ""
    echo "				  ./tp1_ej3.sh stop"
    echo 
    echo "		  - clear - Limpiara el directorio de backups, se debe ingresar la cantidad la cantidad"
    echo "		  de backups a guardar. De no ingresar parametro se borraran todos los backups."
    echo ""
    echo "		  Ejemplo de ejecución clear:"
    echo ""
    echo "					./tp1_ej3.sh clear 3"
    echo 
    echo "		  -play - El demonio creara el backup en este instante."
    echo ""
    echo "		  Ejemplode ejecución play:"
    echo ""
    echo "					./tp1_ej3.sh play"
    echo "=============="
    exit
}																    

detener_demonio()
{
	if test -s /tmp/bkp.pid; then
		echo "Se detiene el demonio de backup."
		cat /tmp/bkp.pid | awk '{print "kill -9 "$1}'|sh
		rm -f $LOCK 		#Borro el archivo de lockeo previo a detener el demonio
		>/tmp/bkp.pid
		>/tmp/orig.txt
	else
		echo "Debe ejecutar el demonio de backups para realizar está acción."
		echo "De necesitar ayudar ejecute ./ej_3.sh -h"
		exit
	fi
}

borrar()
{
	if test -s /tmp/bkp.pid; then
		dest=$(cat /tmp/dest.txt)
		cd $dest
		cant=$1
		rm -f $(ls -1t | awk 'NR>'$cant) 
	else
		echo "Debe ejecutar el demonio de backups para realizar está acción."
		echo "De necesitar ayudar ejecute ./ej_3.sh -h"
		exit
	fi
}

contar()
{
	destino=$(cat /tmp/dest.txt)
	echo "La cantidad de backups disponibles es:"
	ls -1tr "$destino" | wc -l
}

play_now()
{
	if test -s /tmp/orig.txt; then
		if test -s /tmp/dest.txt; then
			echo "Se realiza el backup en este instante."
			D=`date +%Y-%m-%d-%T`	
			destino=$(cat /tmp/dest.txt)		
			origen=$(cat /tmp/orig.txt)
			tar -czf "$destino"/bkp_$D.tar.gz "$origen" > /dev/null 2>&1	#Realizo el backup en el momento.
		fi
	else
		echo "Debe ejecutar el demonio de backups para realizar está acción."
		echo "De necesitar ayudar ejecute ./ej_3.sh -h"
		exit		
fi
}

if test $# -eq 1; then #valido por un parametro
	
	if test $var = "-?" || test $var = "-h" || test $var = "-help" ; then #valido si necesita una ayuda
		help
	elif test $var = "stop" ; then
		echo ""
	elif test $var = "play" ; then
		echo ""
	elif test $var = "count" ; then
		echo ""
	elif test $var = "clear" ; then
		nn=0
	else
		echo "ERROR: Los parametros ingresados son invalidos."
		exit
	fi

elif test $# -eq 2 ; then #valido que los parametros sean dos

	if test $var = "clear" && test $2 -gt 0 ; then >/dev/null 2>&1 
		nn=$2
	fi
	
elif test $# -eq 4; then #valido por 4 parametros
	
	if test $var = "start" && test -d "$2" && test -d "$3" && test "$4" -gt 0 ; then #>/dev/null 2>&1 valido las opciones de ejecucion de start
		echo ""
		echo "$2">/tmp/orig.txt	#Me guardo el origen y destino para luego reutilizarlos	
		echo "$3">/tmp/dest.txt #Me guardo el origen y destino para luego reutilizarlos
	else
		echo "Parametros Invalidos."
		exit		
	fi
elif test $# -eq 3 || test $# -gt 4; then
	echo "Cantidad de parametros invalidos."
	echo "Ejecute ./ej3.sh -help para ver ejemplos de ejecición"
	exit
fi

case "$var" in
	start )
		if [ ! -e $LOCK ]
		then
			echo "Se inicializa el demonio de backups."
			touch $LOCK
			$BKP_SH "$2" "$3" $4 & echo $! >/tmp/bkp.pid 2>$1 < /dev/null #Ejecuto el backups llamando al archivo bkpd
		else
			echo "Ya se está ejecutando el demonio de backups."
			exit 1
		fi
		;;
	stop )
		detener_demonio 	
		;;
	count )
		contar
		;;
	clear )
		borrar $nn			#Borro dejando los ultimos solicitados.
		;;
	play )
		play_now
		;;	
esac