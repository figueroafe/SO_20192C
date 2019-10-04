
		
Param (
	[Parameter(Position=0,Mandatory=$true)]
	[string]$pathzip,
	
	[Parameter(Position=1,Mandatory=$true)]
	[string]$directorio
)

	

	
#Write-Host "Mostrar $pathzip y $directorio"

#Add-Type -AssemblyName 'system.io.compression.filesystem'
#[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio) 
Add-Type -Assembly 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio)



#if (-not (Test-Path $pathzip)) {
#	"Directorio Inexistente."
#}