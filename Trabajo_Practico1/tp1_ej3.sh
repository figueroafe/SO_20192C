#!/bin/bash

var=$1

destino=/home/francisco/bkps
ORIGEN=/home/francisco/aws
D=`date +%Y-%m-%d-%T`
LOCK="/var/lock/bkp.lock"
trap 'rm -f $LOCK' INT

#echo "##########################################################################"
#echo "--------------------------------------------------------------------------"
#echo "########### TRABAJO PRACTICO N°1 #########################################"
#echo "--------------------------------------------------------------------------"
#echo "##########################################################################"
#echo "Instrucciones de uso del script: 										    "
#echo "**Para inicializar el demonio del script, escriba 'start' y luego indique "
#echo "**directorio de origen, directorio de destino y el intervalo de ejecución."
#echo " "
#echo "**Para detener el demonio del script, escriba 'stop'.					    "
#echo " "
#echo "**Para saber la cantidad de archivos de backups escriba 'count'           "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "
#echo "																		    "

#funcion_error()
#{
#	ERROR="Opcion Invalida"
#}
#
#funcion_backup()
#{
#		while [ -f $LOCK ] 
#		do
#			hh=`date +%Y-%m-%d-%T`
#			tar -czf $dest/bkp_$hh.tar.gz $orig 
#			echo "Backup realizado."
#			sleep $slp
#		done
#}

detener_demonio()
{
	cat /tmp/bkp.pid | awk '{print "kill -9 "$1}'|sh
}

case $var in
	start )
		if [ ! -e $LOCK ]
		then
			trap "rm -f $LOCK; exit" INT TERM EXIT
			touch $LOCK
			echo "Ingrese directorio origen"
			read orig
			echo "Ingrese directorio destino"
			read dest
			echo "Sleep"
			read slp
			trap - INT TERM EXIT
		else
			echo "Ya se está ejecutando el demonio de backups."
			exit 1
		fi


		echo "Preciones Ctrl+C para interrumpir."
		#setsid funcion_backup >/tmp/bkp.pid 2>$1 < /dev/null &
		while [ -f $LOCK ] 
		do
			hh=`date +%Y-%m-%d-%T`
			tar -czf $dest/bkp_$hh.tar.gz $orig 
			echo "Backup realizado."
			sleep $slp 
		done
		;;
	stop )
		echo "Se detiene el demonio de backup."+
		rm -f $LOCK
		detener_demonio
		;;
	count )
		ls -1tr $destino | wc -l
		;;
	clear )
		echo "Ingresar cantidad:"
		read cant
		echo rm $(ls -1t $destino| awk ' NR => ${cant} ')
		;;
	play )
		echo ""
		tar -czf $destino/bkp.$D.tar.gz $ORIGEN
		;;	
esac