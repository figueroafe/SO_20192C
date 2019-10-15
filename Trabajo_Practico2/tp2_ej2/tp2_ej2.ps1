
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
    [Parameter(Mandatory=$true, Position=1)][Int] $Cantidad
)

if($Cantidad -le 1)
{
    Write-Host "Parametros incorrecto. Debe ser mayor a 1. Ejecute la ayuda del script para mas informacion."
    exit
}else{
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

}