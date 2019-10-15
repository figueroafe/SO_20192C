
#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej6.ps1"
# Numero Trabajo Practico: 2 
# Numero Ejercicio: 6
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
    Script creado para calcular el producto escalar de una matriz
    o la suma entre 2 matrices.
    .Description
    -El Script tiene 2 funcionalidades: realizar la suma de dos matrices o el producto escalar
    de una matriz. Para realizar la suma de dos matrices se deben enviar por parametro los paths
    absolutos o relativos de ambas matrices, siendo la primera matriz la de entrada y la segunda 
    la matriz a sumarle. Para el producto escalar se debe ingresar el path de la matriz de entrada
    y el escalar. Para ambas funcionalidades, se genera un archivo de texto con el nombre 
    salida.nombrematrizentrada.txt en el mismo directorio donde se encuentra la matriz de entrada
    con el resultado obtenido. Recuerde que si utiliza directorios que contiene espacios en el nombre
    debe ingresarlos con "".

    -Los parámetros a utilizar son los siguientes:
    -Entrada: Path del archivo de entrada. Debe ser una matriz válida de formato x|x|x en cada fila.
    -Suma: Path del archivo a sumarle a la matriz de entrada. Debe ser una matriz válida. No se puede usar con -Producto.
    -Producto: Valor entero que representa el escalar a ser utilizado en el producto escalar. No se puede usar con -Suma.
     
     Aclaracion:
     No se puede utilizar el script con los comandos -Entrada, -Suma, -Producto sin incluir esta palabra clave, esto es asi
     porque sino no se verán los mensajes de error que muestran el uso de parameterset.

    .Example
    ./tp2_ej6.ps1 -Entrada ~/Escritorio/matriz.txt -Producto 5
    .Example
    ./tp2_ej6.ps1 -Entrada ~/Escritorio/matriz.txt -Suma /home/user/Escritorio/Matriz2.txt
#>

Param
(
[Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Producto')][Parameter(ParameterSetName = 'Suma')] [string] $Entrada = "vacio",
[Parameter(Mandatory = $false, ParameterSetName = 'Producto')] [int] $Producto = -999,
[Parameter(Mandatory = $false, ParameterSetName = 'Suma')] [string] $Suma = "vacio"
)


if(($PSBoundParameters.Count -eq 0)){ #Valida cantidad de parámetros.
    Write-Host ""
    Write-Host "No se ingresaron parametros - Utilice Get-Help para la ayuda del script"
    Write-Host ""
    Exit
}


function ProductoEscalar(){
    $Matriz1 = @(Get-Content $Entrada)
    $filas = $Matriz1.count
    $columnas = $Matriz1[0].Split("|").Length
    $Matriz1 = @($Matriz1.Split("|")) 
    $salida = Test-Path "salida.$NombreArchivo"
    if($salida -eq $true){
        Remove-Item "salida.$NombreArchivo" | Out-Null
        New-Item "salida.$NombreArchivo" | Out-Null
    }
    else {
        New-Item "salida.$NombreArchivo" | Out-Null
    }
    
    $pos = 0;
    for ($i = 0; $i -lt $filas; $i++) {
        
        for ($j = 0; $j -lt $columnas; $j++) {
            [double]$res = [double]$Matriz1[$pos] * $Producto 
             if($j -eq $columnas-1){
                $array += "$res"
             }
             else {
                $array += "$res|"
             }
             $pos++;                 
         }
         Write-Output $array >> "salida.$NombreArchivo"
         $array = ""
    }
}

function SumarMatrices(){
    $Matriz1 = @(Get-Content $Entrada)
    $Matriz2 = @(Get-Content $Suma)
    $filas = $Matriz1.count
    $filas2 = $Matriz2.count
    $columnas = $Matriz1[0].Split("|").Length
    $columnas2 = $Matriz2[0].Split("|").Length
    $Matriz1 = @($Matriz1.Split("|")) 
    $Matriz2 = @($Matriz2.Split("|"))
    if($filas -eq $filas2 -and $columnas -eq $columnas2){
        $salida = Test-Path "salida.$NombreArchivo"
        if($salida -eq $true){
            Remove-Item "salida.$NombreArchivo" | Out-Null
            New-Item "salida.$NombreArchivo" | Out-Null
        }
        else {
            New-Item "salida.$NombreArchivo" | Out-Null
        }
        $pos = 0;
        for ($i = 0; $i -lt $filas; $i++) {
            
            for ($j = 0; $j -lt $columnas; $j++) {
                [float]$res = [double]$Matriz1[$pos] + [double]$Matriz2[$pos] 
                 if($j -eq $columnas-1){
                    $array += "$res"
                 }
                 else {
                    $array += "$res|"
                 }
                 $pos++;                 
             }
             Write-Output $array >> "salida.$NombreArchivo"
             $array = ""
        }
        
    }
    else {
        Write-Host "Imposible Continuar - La matriz pasada en -Suma no es valida para realizar la suma"
    } 

}

$path = Test-Path "$Entrada" -PathType leaf
$path2 = Test-Path "$Suma" -PathType leaf
$NombreArchivo = $Entrada.Substring($Entrada.LastIndexOf("/")+1)
if($Entrada -eq "vacio"){
    Write-Host "Imposible continuar - No se ingresó el origen de la matriz de entrada"
}
elseif ($path -ne $true) {
    Write-Host "Imposible continuar - No se pudo ubicar el path de la matriz de entrada.."
}
elseif($Producto -eq -999 -and $Suma -eq "vacio"){
    Write-Host "Imposible continuar - No se ingresó una operacion"
}
elseif($Producto -ne -999) {
        ProductoEscalar
}
elseif($Suma -ne "vacio"){
    if($path2 -eq $true){
        SumarMatrices
    }
    else {
        Write-Host "Imposible continuar - No se pudo ubicar el path de la matriz a sumar pasada por parámetro -Suma"
    }
}
