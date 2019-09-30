
#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej1.ps1"
# Numero Trabajo Practico: 2 
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

Param   (
    [Parameter(Position = 1, Mandatory = $false)]
    [String] $pathsalida = "./procesos.txt ",
    [int] $cantidad = 3
)
        
$existe = Test-Path $pathsalida 
if ($existe -eq $true){
    $listaproceso = Get-Process
    foreach ($proceso in $listaproceso) {
        $proceso | Format-List -Property Id,Name >> $pathsalida
    }     
    for ($i = 0; $i -lt $cantidad ; $i++) {
        Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id
    } 
} 
else{
    Write-Host "El path no existe" 
} 

# Responder:
# 1. ¿Cuál es el objetivo del script?
#
# El script tiene como objetivo obtener los procesos que se encuentran en ejecución
# y listarlos en un archivo de texto indicando su nombre y pid. Además muestra por
# pantalla los primeros 3 procesos de la lista que se encuetran ordenados alfabéticamente.
# El mismo necesita que se le indique la ruta de un archivo existente, donde se agregarán
# los procesos en ejecución.
#
# ------------------------------------------------------------------------------------------
#
# 2. ¿Agregaría alguna otra validación a los parámetros?
#
# No agregaría otra validación pero si modificaría el primer parámetro para que sea requerido,
# de esta forma se evitará que no se introduzca el path de destino.
# También haría que la cantidad de procesos a mostrar, se pueda pasar como parámetro para 
# darle al script más funcionalidad. Sino se indica solo se mostrarían 3 procesos.
# Quedaría de la siguiente forma:
#
# Param   (
#    [Parameter(Position = 1, Mandatory = $false)]
#    [String] $pathsalida = "./procesos.txt ",
#    [Parameter(Position = 2, Mandatory = $false)]
#    [int] $cantidad = 3
#)
#
# ------------------------------------------------------------------------------------------
#
#3. ¿Qué sucede si se ejecuta el script sin ningún parámetro?
#
# Si no se le indica ningún parámetro, se muestra una leyenda que indica que el path no
# existe y no se realiza el objetivo del script.