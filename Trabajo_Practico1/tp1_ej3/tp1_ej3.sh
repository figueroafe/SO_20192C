#!/bin/bash

var=$1

LOCK="/var/lock/bkp.lock"
trap 'rm -f $LOCK' INT
BKP_SH="./bkpd"

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


detener_demonio()
{
	cat /tmp/bkp.pid | awk '{print "kill -9 "$1}'|sh
	>/tmp/bkp.pid
}

borra_que_te_borra()
{
	#echo "Ingresar directorio de backups:"
	#read destino
	echo "Ingresar cantidad de backups a guardar:"
	read cant
	#rm -f $(ls -1t | awk  -v c="$cant" '{NR > c}')
	#cd $destino
	cd $dest
	rm $(ls -1t | awk 'NR>'$cant)
	#ls $(ls -1t | awk 'NR>'$cant)
	#echo "rm $(ls -1t $destino| awk 'NR >= "$cant" ')" \n
	#echo "$(ls -1t $destino| awk 'NR >= "$cant" ')" > /tmp/bkp_borrar.txt > /dev/null 2>&1
	#cat /tmp/bkp_borrar.txt | awk ''

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


		#echo "Preciones Ctrl+C para interrumpir."
		
		$BKP_SH $orig $dest $slp & echo $! >/tmp/bkp.pid 2>$1 < /dev/null
		
		#sh $BKP_SH $orig $dest $slp >/tmp/bkp.pid &
		#while [ -f $LOCK ] 
		#do
		#	hh=`date +%Y-%m-%d-%T`
		#	tar -czf $dest/bkp_$hh.tar.gz $orig 
		#	echo "Backup realizado."
		#	sleep $slp 
		#done
		;;
	stop )
		echo "Se detiene el demonio de backup."
		rm -f $LOCK
		detener_demonio
		;;
	count )
		#echo "Ingresar directorio de backups:"
		#read destino
		#ls -1tr $destino | wc -l
		ls -1tr $dest | wc -l
		;;
	clear )
		echo ""
		borra_que_te_borra
		;;
	play )
		echo ""
		tar -czf $destino/bkp.$D.tar.gz $ORIGEN
		;;	
esac