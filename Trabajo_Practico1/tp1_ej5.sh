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

if test $# -lt 1 || test $# -gt 2; then #cantidad de parametros validos
    ErrorSintax
fi
mkdir ~/.papelera 2> /dev/null  #Creo la papelera oculta
if test $# -eq 1; then
if test $1 = "-l"; then
ls ~/.papelera
fi
fi


#fin archivo

