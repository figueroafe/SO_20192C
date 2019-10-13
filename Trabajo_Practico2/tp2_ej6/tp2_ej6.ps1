<#
    .Synopsis
    Script creado para realizar el producto escalar de una matriz
    o la suma entre 2 matrices.
    .Description
    El Script se utiliza para realizar la suma de 
    2 matrices pasadas por parámetro en archivos de texto; devolviendo el resultado
    en un tercer archivo de texto. También puede calcular el producto escalar de
    una matriz pasando un escalar por parámetro.
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

function procesar(){
    for ($i = 0; $i -lt 3; $i++) {
        Start-Sleep -Seconds 0.2
        Write-Host("#")
        
    }
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
            [float]$res = [float]$Matriz1[$pos] * $Producto 
             #$array.Add($res)
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
            [float]$res = [float]$Matriz1[$pos] + [float]$Matriz2[$pos] 
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
