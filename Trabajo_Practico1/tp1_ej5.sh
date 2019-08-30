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

ErrorSintax()
{
   echo "Error - La sintaxis no es correcta, utilice help para mas info" #Refinar mas adelante
}

if test $# -lt 1 && $# -gt 2; then #cantidad de parametros validos
    ErrorSintax
fi

if test -f $1; then #verifica que es un fichero y es regular
elif test $2 = "-l" || test $2 = "-r" || test $2 = "-e";

else
ErrorSintax
fi
#fin archivo

