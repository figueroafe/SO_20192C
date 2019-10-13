<#
    .Synopsis
    Script creado para calcular el producto escalar de una matriz
    o la suma entre 2 matrices.
    .Description
    El Script tiene 2 funcionalidades: realizar la suma de dos matrices o el producto escalar
    de una matriz. Para realizar la suma de dos matrices se deben enviar por parametro los paths
    absolutos o relativos de ambas matrices, siendo la primera matriz la de entrada y la segunda 
    la matriz a sumarle. Para el producto escalar se debe ingresar el path de la matriz de entrada
    y el escalar. Para ambas funcionalidades, se genera un archivo de texto con el nombre 
    salida.nombrematrizentrada.txt en el mismo directorio donde se encuentra la matriz de entrada
    con el resultado obtenido. Recuerde que si utiliza directorios que contiene espacios en el nombre
    debe ingresarlos con "".
    .Example
    ./tp2_ej6.ps1 -Entrada ~/Escritorio/matriz.txt -Producto 5
    ./tp2_ej6.ps1 -Entrada ~/Escritorio/matriz.txt -Suma /home/user/Escritorio/Matriz2.txt
#>

Param
(
[Parameter(Position = 1, Mandatory = $false)]
[string] $Entrada = "vacio",
[Parameter(Position = 2, Mandatory = $false, ParameterSetName = 'Producto')]
[int] $Producto = -999,
[Parameter(Position = 3, Mandatory = $false, ParameterSetName = 'Suma')]
[string] $Suma = "vacio"
)

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
    $filas = $Matriz1.count
    $columnas = $Matriz1[0].Split("|").Length
    $Matriz1 = @($Matriz1.Split("|")) 
    $Matriz2 = @(Get-Content $Suma)
    $Matriz2 = @($Matriz2.Split("|")) 
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

$path = Test-Path "$Entrada"
$path2 = Test-Path "$Suma"
$NombreArchivo = $Entrada.Substring($Entrada.LastIndexOf("/")+1)
if($Entrada -eq "vacio"){
    Write-Host "Imposible continuar - No se ingresó el origen de la matriz"
}
elseif ($path -ne $true) {
    Write-Host "Imposible continuar - El path no existe.."
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
        Write-Host "Imposible continuar - No se pudo ubicar el path de la matriz2"
    }
}
