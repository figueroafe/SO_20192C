#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "ej_2.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 2
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           ----------
#       Francisco Figueroa	                            	32.905.374
#       Adrian Morel		                            	34.437.202
#       Sergio Salas                                    	32.090.753                 
#       Fernando Sanchez	 		                36.822.171
#       Sabrina Tejada			       	     		37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

#!/bin/bash

help1()
{
    echo
    echo "Ayuda del script"
    echo "=============="
    echo
    echo "Descripcion:"

    echo
    echo "        El script permite renombrar todos los ficheros que posean"
    echo "        uno o mas espacios en su nombre, reemplazandolos por _"
    echo "        ./tp1_ej2.sh [directorio] [-r recursividad]"
    echo 
    echo "=============="
    echo 
    exit
}
helpExt()
{
    echo
    echo "Ayuda del script"
    echo "=============="
    echo
    echo "Descripcion:"
    echo
    echo "        El script permite renombrar todos los ficheros que posean"
    echo "        uno o mas espacios en su nombre, reemplazandolos por _"
    echo "        ./tp1_ej2.sh [directorio] [-r recursividad]"
    echo 
    echo
    echo "Parametros:"
    echo
    echo "        [directorio]     ingresar ruta de ficheros a renombrar. "
    echo "        -En caso de contener espacios ingresarlo entre comillas dobles. "
    echo "        excepto en el caso del uso del caracter ~ "
    echo
    echo "        -r         Renombrará ademas de los archivos del "
    echo "        directorio indicado, tambien los de los subdirectorios"    
    echo    
    echo "        -En caso de no declararse el directorio se tomará como base el "
    echo "        directorio donde se encuentra ubicado el script. "
    echo     
    echo "=============="    
    echo 
    echo "Ejemplos:"
    echo
    echo "        ./tp1_ej2.sh "
    echo "        ./tp1_ej2.sh -r"
    echo "        ./tp1_ej2.sh  \"/home/user/Documentos\" -r"
    echo "        ./tp1_ej2.sh  ./Escritorio -r"
    echo "        ./tp1_ej2.sh  ~/Descargas "
    echo 
    exit
}

recur=0
if test $# -eq 0 ; #Si no envio parametro toma la direccion actual
then
    direc=$(pwd);
elif [[ $1 = "-h" ]] ; then #es consulta de ayuda 
    help

elif [[ $1 = "--help" ]] ; then #es consulta de ayuda extendida
    helpExt
elif [[ -d "$1" && $# = 1 ]] ; then #valido si es una direccion para un unico param
    direc=$1
elif [[ $1 = "-r" && $# = 1 ]] ; then #valido si es recursivo para un unico param
    direc=$(pwd);
    recur=1
elif [[ -d "$1" && $2 = "-r" && $# = 2 ]] ; then #Si envia mas de un parametro
    direc=$1
    recur=1
elif [[ -d "$2" && $1 = "-r" && $# = 2 ]] ; then #Si envia mas de un parametro
    direc=$2
    recur=1
else
    echo "ERROR: los parametros ingresados son invalidos"
    exit
fi  

echo "Voy a trabajar en el directorio: $direc"
cd "$direc"; 
cant=0;
echo "$cant" > ./valor.txt
if [[ $recur -eq 1 ]] ; then
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    find . -type f -name '* *'  | while IFS=" " read -r FILE
    do        
	echo "Fichero:"
        echo "$FILE"
        if [[ -f "$(dirname "$FILE")"/"$(basename "$FILE"|tr -s [:space:] _ )" ]] 
        then
            echo "El renombre de este fichero ya existe, se renombrara con  '-copy'"
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )-copy";
            echo "Este fichero se renombro con exito" ;
        else
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )";       
            echo "Este fichero se renombro con exito";
        fi
	cant=$((cant+=1));
	echo "$cant" > ./valor.txt
    done
else
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    find -maxdepth 1 -type f -name '* *'  | while IFS=" " read -r FILE #NO RECURSIVO
    do 
        echo "Fichero:"
        echo "$FILE"
        if [[ -f "$(basename "$FILE"|tr -s [:space:] _ )" ]] 
        then
            echo "El renombre de este fichero ya existe, se renombrara con  '-copy'"
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )-copy";
            echo "Este fichero se renombro con exito" 
        else
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )"; 
            echo "Este fichero se renombro con exito";
        fi
	cant=$((cant+=1));
	echo "$cant" > ./valor.txt
    done
fi
echo "cantidad de archivos renombrados:";
cat valor.txt;
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
rm valor.txt

