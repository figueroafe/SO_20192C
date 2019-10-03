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
[Parameter(Position = 1, Mandatory = $false)]
[string] $Entrada = "vacio",
[Parameter(Position = 2, Mandatory = $false<#, ParameterSetName = 'Producto'#>)]
[int] $Producto = -999,
[Parameter(Position = 3, Mandatory = $false<#, ParameterSetName = 'Suma'#>)]
[string] $Suma = "vacio"
)


$path = Test-Path "$Entrada"
$path2 = Test-Path "$Suma"
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
    if($Producto -lt 0){
        Write-Host "El escalar es inválido, debe ser un número natural"
    }
    else {
        Write-Host "Realizando el producto, por favor espere..."
        $Matriz1 = Get-Content $Entrada
        $CantFilas = $Matriz1.count
        Write-Host "La cantidad de filas de la matriz es: $CantFilas"
        $Matriz1 = $Matriz1.Split("|")
        Write-Host "$Matriz1"
        Write-Host "El Producto escalar se ha realizado exitosamente!"
    }
}
elseif($Suma -ne "vacio"){
    if($path2 -eq $true){
        Write-Host "Realizando la suma, por favor espere..."
        Write-Host "El Suma de Matrices se ha realizado exitosamente!"
    }
    else {
        Write-Host "No se pudo ubicar el path de la matriz2"
    }
}