<#
    .Synopsis
    Script creado para realizar el producto escalar de una matriz
    o la suma entre 2 matrices.
    .Description
    El Script se utiliza para realizar la suma  de 
    2 matrices pasadas por parámetro en archivos de texto; devolviendo el resultado
    en un tercer archivo de texto. También puede calcular el producto escalar de
    una matriz pasando un escalar por parámetro.
    .Example
    ejemplo 1
    .Inputs
    inputs aqui
    .Outputs
    outputs aqui
    .Notes
    notas aqui
#>

Param
(
[parameter(Position = 1, Mandatory = $false)]
[string] $Entrada = "vacio",
[parameter(Position = 2, Mandatory = $false)]
[string] $Producto = "vacio",
[parameter(Position = 3, Mandatory = $false)]
[int] $Suma
)

$path = Test-Path "$Entrada"
if($Entrada -eq "vacio"){
    Write-Host "Imposible continuar - No se ingresó el origen de la matriz"
}
elseif ($path -ne $true) {
    Write-Host "Imposible continuar - El path no existe.."
}
elseif($Producto -eq "vacio"){
    Write-Host "Imposible continuar - No se ingresó una operacion"
}
elseif($Producto -lt 0){
    Write-Host "El escalar es inválido, debe ser un número natural"
}