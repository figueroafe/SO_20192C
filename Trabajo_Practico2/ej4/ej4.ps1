
		
Param (
	[Parameter(Position=0,Mandatory=$true)]
	[string]$pathzip,
	
	[Parameter(Position=1,Mandatory=$true)]
	[string]$directorio,

	[Parameter(Position=2,Mandatory=$true,ParameterSetName='Descomprimir')]
	[Parameter(Position=2,Mandatory=$true,ParameterSetName='Comprimir')]
	[Parameter(Position=2,Mandatory=$true,ParameterSetName='Informar')]
	[switch]$comdesinf
)

	

	
#Write-Host "Mostrar $pathzip y $directorio"

#Add-Type -AssemblyName 'system.io.compression.filesystem'
#[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio) 

#Add-Type -Assembly 'System.IO.Compression.FileSystem'
#[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio)

Add-Type -Assembly 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::ExtractToDirectory($pathzip, $directorio)


#if (-not (Test-Path $pathzip)) {
#	"Directorio Inexistente."
#}