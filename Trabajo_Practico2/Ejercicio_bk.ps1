
Param (
    [Parameter(ParameterSetName="Cantidad")]
    [switch] $Cantidad
)
$lista_procesos = Get-Process | Select-Object ProcessName | Format-Table -HideTableHeaders ProcessName | Out-String 
<#Get-Process | Select-Object ProcessName | Format-Table ProcessName -HideTableHeaders | Out-String #>
$hashCantI = @{} 

Write-Output "tamaño" $lista_procesos.length
$tam =$lista_procesos.Split().GetLength()

foreach ($i in $lista_procesos.Split('\n')) 
{      
     <#    if(!$i.Equals("")){
            Write-Output $i
           <#  if( $hashCantI.ContainsKey($i))
             {
                Write-Output -InputObject $i
                Write-Host " existe key"
                exit
            }else {
                <#$hashCantI.Add( (Write-Output $i ), '0')
            
            $hashCantI[$i] ='0'
                Write-Host "no existe, se guardo key"
                
            } 
        }    #>
}
<#
foreach ($i in $lista_procesos) 
{   
    $lista_un_proceso = Get-Process -ProcessName "nombre clave" 
    $contar=0
    foreach ($i in $lista_un_proceso) 
    {
        $contar = $contar+1
    }
    ACA editar el valor con lo contado.
}
#>