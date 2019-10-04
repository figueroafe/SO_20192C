Param (
	[Parameter(Position=0,Mandatory=$true)]
	[string]$pathzip
	
	#[Parameter(Position=1,Mandatory=$true)]
	#[string]$directorio

	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Descomprimir')]
	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Comprimir')]
	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Informar')]
	#[switch]$comdesinf
)

	

	
#Write-Host "Mostrar $pathzip y $directorio"

#Add-Type -AssemblyName 'system.io.compression.filesystem'
#[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio) 

#if($comdesinf -eq 'Descomprimir')
#{
#	Add-Type -Assembly 'System.IO.Compression.FileSystem'
#	[System.IO.Compression.ZipFile]::ExtractToDirectory($pathzip, $directorio)
#
#}



#switch ($comdesinf) {
#	"Descomprimir"	{ Add-Type -Assembly 'System.IO.Compression.FileSystem'
#						[System.IO.Compression.ZipFile]::ExtractToDirectory($pathzip, $directorio); break}
#	"Comprimir" 	{ Add-Type -Assembly 'System.IO.Compression.FileSystem'
#						[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio); break}
#	"Informar"		{break}
#	Default {"Opciones erroneas"; break}
#}

add-Type -AssemblyName system.io.compression.filesystem
#[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio)
[io.compression.ZipFile]::OpenRead($pathzip)



#if (-not (Test-Path $pathzip)) {
#	"Directorio Inexistente."
#}