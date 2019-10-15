<#
 .SYNOPSIS
  El script mueve archivos log de un path origen hacia otro path destino.
 .Description
  Recibe un parametro "entrada" con la ruta de un archivo .csv, con los datos de origen y destino.
  El script realiza un movimiento de archivo por cada registro del csv, y se almacena dicho movimiento en un archivo .csv 
  en la ruta pasada por el parametro "salida". 
 .PARAMETER Entrada
  [Obligatorio]  archivo con extension .csv donde se encuentran los datos de los archivos a mover a una ubicacion path destino.
 .PARAMETER Salida
  [Obligatorio]  archivo con extension .csv donde se almacena el archivo movido con su hora respectiva (log). 
 .Example 
 .\ej3.ps1 -entrada './Archivos.csv' -salida 'Log.csv'
 .Example 
 .\ej3.ps1 -entrada 'C:/Users/Pepe/Desktop/Archivos.csv' -salida 'Log.csv'
#>

#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej3.ps1"
# Numero Trabajo Practico: 2 
# Numero Ejercicio: 3
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                                 DNI
#		---------------------                           --------
#       Francisco Figueroa	                            32.905.374
#       Adrian Morel		                            34.437.202
#       Sergio Salas                                    32.090.753                 
#       Fernando Sanchez	 		                	36.822.171
#       Sabrina Tejada			       	     			37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path -Path $_ -PathType 'Leaf'})] 
        [String] $entrada,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $salida
) 


$datos = Import-Csv -Path $entrada  -Delimiter ',' 
$resumen = @();

ForEach($item in $datos){

    if([System.IO.File]::Exists($item.origen)){
    
        $aux= Split-Path -Path $item.destino
        
        if(Test-Path $aux){

            Move-Item -Path $item.origen -Destination $item.destino
            $fecha= Get-Date -Format "dd/MM/yyyy HH:mm";

            $resumen+= @([pscustomobject]@{Archivo=$item.destino; Fecha = $fecha});
        }
    }
}

$dirActual = Get-Location
$dirScript = split-path $PSCommandPath
cd $dirScript
$resumen | Export-csv -Path $salida;
cd $dirActual