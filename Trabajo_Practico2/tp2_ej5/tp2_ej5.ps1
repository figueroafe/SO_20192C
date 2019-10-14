
#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej5.ps1"
# Numero Trabajo Practico: 2 
# Numero Ejercicio: 5
# Tipo: 1° Entrega
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
     El script muestra cada cierta cantidad de tiempo la cantidad de procesos que se 
     encuentran en ejecución en ese momento o el tamaño de un directorio.

    .Description
     El script cuenta con los siguientes parámetros:

    -Procesos: Parámetro de tipo switch que indica que se mostrará la cantidad de procesos
     corriendo al momento de ejecutar el script.
    
    -Peso: Parámetro de tipo switch que indica que se mostrará el peso de un directorio.
    
    -Directorio: Indica el directorio a evaluar. Solo se puede usar si se pasó “-Peso”.

    ACLARACIONES

    -Al ejecutar el script se mostrará lo solicitado cada 5 segundos hasta que se detenga.
    
    -Solo se permite realizar una acción a la vez, es decir, se puede consultar la cantidad
     de procesos en ejecución o el peso del directorio indicado.

    -El peso de los archivos está indicado en bytes (ver nota al pie).

    -Para finalizar, se debe ejecutar el script pasandole el parámetro -Detener
         
    .Example
    ./tp2-ej5.ps1 -Procesos
    ./tp2-ej5.ps1 -Peso -Directorio "/home/user"
    ./tp2-ej5.ps1 -Peso "/home/user"
    ./tp2-ej5.ps1 -Detener
    
#>

Param (
        [Parameter(ParameterSetName="Procesos")] [switch] $Procesos,
        [Parameter(ParameterSetName="Directorio")] [switch] $Peso,
        [Parameter(ParameterSetName="Directorio", Mandatory = $true, Position = 2)] [string] $Directorio,
        [Parameter(ParameterSetName="Detener")] [switch] $Detener
    )

$timer = New-Object System.Timers.Timer -Property @{Interval = 5000}
$existe = Test-Path $Directorio
$global:ruta = $Directorio

if(($PSBoundParameters.Count -lt 1) -or ($PSBoundParameters.Count -gt 2)){ #Valida cantidad de parámetros.
    Write-Host ""
    Write-Host "La cantidad de parámetros es incorrecta, consulte la ayuda con el comando Get-Help."
    Write-Host ""
    Exit
}

if($Procesos.IsPresent){ #Si es -Procesos.
    
    Get-EventSubscriber | Where-Object {$_.SourceIdentifier -eq "procesos" -or $_.SourceIdentifier -eq "directorio"} | Unregister-Event

    $accionProcesos = {
        $cantidad = (Get-Process).Count 
        Write-Host ""
        Write-Host $cantidad
    } 
    
    Register-ObjectEvent -InputObject $timer -EventName elapsed -SourceIdentifier procesos -Action $accionProcesos | Out-Null

    $timer.start()
    <#Clear-Host
    Write-Host "------------------------------------------------"
    Write-Host "Se mostrará la cantidad de procesos en ejecución"
    Write-Host "------------------------------------------------"#>
}

elseif ($Peso.IsPresent){ #Sino si es -Peso.

    if($existe -eq $false){
        Write-Host ""
        Write-Host "La ruta ingresada no existe, intente nuevamente."
        Write-Host ""
        Exit
    }
    Get-EventSubscriber | Where-Object {$_.SourceIdentifier -eq "procesos" -or $_.SourceIdentifier -eq "directorio"} | Unregister-Event
    
    $accionDirectorio = {
        $lista = (Get-ChildItem -Path $global:ruta -File -Recurse)
        $tam = ($lista | Measure-Object -Property Length -Sum).Sum

        <#if ($tam -gt 1GB) {
            $tam = $tam / 1GB
            $unidad = "GB"
        } 
        elseif ($tam -gt 1MB) {
            $tam = $tam / 1MB
            $unidad = "MB"
        } 
        else {
            $tam = $tam / 1KB
            $unidad = "KB"
        }

        $tam = "{0:n3}" -f $tam#>
        Write-Host ""
        Write-Host $tam #$unidad
    }

    Register-ObjectEvent -InputObject $timer -EventName elapsed -SourceIdentifier directorio -Action $accionDirectorio | Out-Null

    $timer.start()
    <#Clear-Host
    Write-Host "---------------------------------------------------------"
    Write-Host "Se mostrará el peso del directorio" $Directorio
    Write-Host "---------------------------------------------------------"#>
}

elseif($Detener.IsPresent){ #Para desuscribirse de cualquiera de los 2 eventos.
    Get-EventSubscriber | Where-Object {$_.SourceIdentifier -eq "procesos" -or $_.SourceIdentifier -eq "directorio"} | Unregister-Event
    Clear-Host
    Write-Host "El script se detuvo exitósamente."
    Write-Host ""
}

else { #Sino fue ninguno de los parámetros permitidos, ni detener.
    Write-Host ""
    Write-Host "Los parámetros ingresados no son correctos, consulte la ayuda con el comando Get-Help."
    Write-Host ""
    Exit
}

<#NOTA: Las líneas de la 82 a 85, 102 a 117 y 123 a 126 son para darle formato a la salida, solo están
comentadas para cumplir con el enunciado "La salida debe ser por pantalla y únicamente un número".
Si se quitan los comentarios, la unidad de medida de los directorios se ajustará al peso de los mismos.#> 