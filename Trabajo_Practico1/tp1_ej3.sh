#!/bin/bash

var=$1

destino=/home/francisco/bkps
ORIGEN=/home/francisco/aws
D=`date +%Y-%m-%d-%T`

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
#
#funcion_error()
#{
#	ERROR="Opcion Invalida"
#}

case $var in
	start )
		echo "Ingrese origen"
		read orig
		echo "Ingrese destino"
		read dest
		echo "Sleep"
		read slp
		while true 
		do
			hh=`date +%Y-%m-%d-%T`
			tar -czf $dest/bkp_$hh.tar.gz $orig
			sleep $slp
		done
		;;
	stop )
		echo "mata el demonio."
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