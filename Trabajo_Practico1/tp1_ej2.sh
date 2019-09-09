#!/bin/bash
help()
{
    echo
    echo "Ayuda del script"
    echo "=============="
    echo
    echo "Descripcion:"

    echo
    echo "        El script permite renombrar todos los ficheros que posean"
    echo "        uno o mas espacios en su nombre, reemplazandolos por _"
    echo "        ./tp1_ej1.sh [directorio] [-r recursividad]"
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
    echo "        [directorio]     ingresar ruta de ficheros a renombrar."
    echo "        En caso de no declararse se tomará como base el "
    echo "        directorio donde se encuentra ubicado el script. "
    echo     
    echo "        -r         Renombrará ademas de los archivos del "
    echo "        directorio indicado, tambien los de los subdirectorios"    
    echo    
    echo "=============="    
    echo 
    echo "Ejemplos:"
    echo
    echo "        ./tp1_ej2.sh "
    echo "        ./tp1_ej2.sh -r"
    echo "        ./tp1_ej2.sh  /home/user/Documentos -r"
    echo "        ./tp1_ej2.sh  ~/Descargas "
    echo 
    exit
}

recur=0
if test $# -eq 0 ; #Si no envio parametro toma la direccion actual
then
    direc=$(pwd);
elif [ $1 = "-h" ] ; then #es consulta de ayuda 
    help

elif [ $1 = "--help" ] ; then #es consulta de ayuda extendida
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
cd $direc 
cant=0
if [[ $recur -eq 1 ]] ; then
    find . -type f -name '* *'  | while IFS=" " read -r FILE
    do 
        echo "Archivo:"
        echo "$FILE"
        if [[ -f "$(basename "$FILE"|tr -s [:space:] _ )" ]] 
        then
            echo "Este fichero ya existe, se renombrara con -copy"
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )-copy";
            echo "Se renombro con exito" 
            cant=$((cant + 1))
        else
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )"; 
            echo "Se renombro con exito"
            cant=$((cant + 1))
        fi
    done
else
    find -maxdepth 1 -type f -name '* *'  | while IFS=" " read -r FILE #NO RECURSIVO
    do 
        echo "Archivo:"
        echo "$FILE"
        if [[ -f "$(basename "$FILE"|tr -s [:space:] _ )" ]] 
        then
            echo "Este fichero ya existe, se renombrara con -copy"
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )-copy";
            echo "Se renombro con exito" 
            cant=$((cant + 1))
        else
            mv -i "$FILE" "$(dirname "$FILE")/$(basename "$FILE"|tr -s [:space:] _ )"; 
            echo "Se renombro con exito"
            cant=$((cant + 1))
        fi
    done
fi
echo "cantidad de archivos renombrados: $cant"

