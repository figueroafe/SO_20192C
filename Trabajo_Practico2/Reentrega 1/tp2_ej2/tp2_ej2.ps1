
#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej2.ps1"
# Numero Trabajo Practico: 2 
# Numero Ejercicio: 2
# Tipo: 2° Entrega
# Integrantes:
#
#		Nombre y Apellido                              DNI
#		---------------------                       ----------
#       Francisco Figueroa                          32.905.374
#       Adrian Morel                                34.437.202
#       Sergio Salas                                32.090.753                 
#       Fernando Sanchez                            36.822.171
#       Sabrina Tejada                              37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

<#
    .Synopsis
    Este script informa cuáles de los procesos que se encuentran corriendo en el sistema y tienen mas 
    de una determinada cantidad de instancias. 
    La salida del script debe ser unicamente un listado de los nombres de los procesos que tienen 
    más de “-Cantidad” instancias, sin encabezados ni otro texto adicional.

    .Description
    -Cantidad: Este parámetro debe ser obligatorio y mayor a 1. Indicara la cantidad minima de 
    instancias que debe tener un proceso para ser reportado
   
    .Example
        .\tp2_ej2.ps1  -Cantidad 5
        postgres
        Code
        svchost
        RuntimeBroker
        chrome
        Teams
        conhost
        MicrosoftEdgeCP
        
    .Example
        .\tp2_ej2.ps1 5
        postgres
        Code
        svchost
        RuntimeBroker
        chrome
        Teams
        conhost
        MicrosoftEdgeCP
#>


Param (
    [Parameter(Mandatory=$true, Position=1)][ValidateRange(2,1000)][Int] $Cantidad
)


    $lista_procesos = Get-Process | Select-Object ProcessName
    $lista_procesos -is [array] | Out-Null
    $hashCantI = @{} 

    foreach ($i in $lista_procesos)
    {      
            if(!$i.Equals("")){
                if( $hashCantI.ContainsKey($i.ProcessName))
                { 
                    $hashCantI[$i.ProcessName]= $hashCantI[$i.ProcessName]+1
                }else {
                    $hashCantI.Add( $i.ProcessName, 1)     
                } 
            }    
    }
    foreach($j in $hashCantI.Keys ){
        if ( $hashCantI[$j] -ge $Cantidad ) {
            Write-Output $j
        }
    }

