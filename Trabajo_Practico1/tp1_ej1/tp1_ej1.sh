#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp1_ej1.sh"
# Numero Trabajo Practico: 1 
# Numero Ejercicio: 1
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           ----------
#       Francisco Figueroa	                            32.905.374
#       Adrian Morel		                            34.437.202
#       Sergio Salas                                    32.090.753                 
#       Fernando Sanchez	 		                	36.822.171
#       Sabrina Tejada			       	     			37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##


#!/bin/bash
ErrorS() #Funcion para mostrar por la terminal que hay un error de sintaxis
{
    echo "Error. La sintaxis del script es la siguiente:"
    echo "Si desea saber la cantidad de lineas del fichero: $0 nombre_archivo L" #COMPLETAR
    echo "Si desea saber la cantidad de bytes del fichero: $0 nombre_archivo C" #COMPLETAR
    echo "Si desea saber la longitud de la linea mas larga: $0 nombre_archivo M" #COMPLETAR
}

ErrorP() #Funcion para mostrar por la terminal que no tiene permisos de lectura el fichero o no existe.
{
    echo "Error. nombre_archivo no existe o no se pudo leer" #COMPLETAR
}

if test $# -lt 2; then  #tiene menos de 2 parametros.
    ErrorS
fi
if ! test -r $1; then
    ErrorP
elif test -f $1 && (test $2 = "L" || test $2 = "C" || test $2 = "M"); then #El primer parametro es un fichero regular y el segundo es un comando.
  if test $2 = "L"; then
    res=`wc -l $1`
    echo "La cantidad de lineas del fichero es: $res" #COMPLETAR
  elif test $2 = "C"; then
    res=`wc -m $1`
    echo "La cantidad de bytes del fichero es: $res" #COMPLETAR
  elif test $2 = "M"; then
    res=`wc -L $1`
    echo "La longitud de la linea más larga es: $res" #COMPLETAR 
  fi
else
  ErrorS
fi

#fin de archivo

#                   ***Respuestas***
# a) El objetivo de este script es mostrar por pantalla información de un   
#    fichero que el usuario solicite consultar. Para este caso, puede solicitar  
#   3 cosas: 1- La cantidad de lineas del documento.
#            2- La cantidad de bytes del documento.
#            3- La longitud de la linea más larga.
#    Si se le ingresa mas de 2 parametros solo devuelve la primer consulta.
#
# b) Recibe 2 parámetros: El nombre del fichero y una letra mayúscula.
#
# c) y d) Ver el código.
#
# e) La variable "$#" brinda la información de la cantidad de parámetros que
#    se pasan del script al shell. Las variables similares que podemos encontrar son:
#    $0, que hace referencia al script, $1, $2...$N, que hace referencia al numero del 
#    parametro en un script, #? (ultimo comando ejecutado), $$ (id de proceso) y por
#    ultimo, #@ y $*, quienes devuelven la lista de parámetros o string de parámetros,
#    respectivamente.
#
# f) En Shell Scripts tenemos 3 tipos de comillas (simple, doble, acento grave).
#    Las comillas simples interpretan el contenido de forma literal. PorEj:
#    SALUDO='Hola $USER, qué tal?' no mostraría el contenido de $USER al 
#    utilizar echo $SALUDO, sino que imprimiría "Hola $USER, qué tal?".
#    Las comillas dobles sì interpreta las referencias a variables, poniendo
#    en su lugar su contenido. Por Ej:
#    echo "tu directorio de trabajo es $HOME" imprimirìa "tu directorio de 
#    trabajo es /home/user"
#    El acento grave se utiliza para ejecutar una orden y luego con eso se 
#    puede asignar a una variable y tratarla. PorEj:
#    DIR=`pwd` voy a poder almacenar en DIR el directorio actual.
#
#


