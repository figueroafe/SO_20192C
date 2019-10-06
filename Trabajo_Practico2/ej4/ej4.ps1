Param (
	[Parameter(Position=0,Mandatory=$true)]
	[string]$pathzip,
	
	[Parameter(Mandatory=$false)]
	[string]$directorio
	
	#[Parameter(Mandatory=$true,ParameterSetName='Descomprimir')]
	#[Parameter(Mandatory=$true,ParameterSetName='Comprimir')]
	#[Parameter(Mandatory=$true,ParameterSetName='Informar')]
	#[switch]$comdesinf
	
	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Descomprimir')]
	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Comprimir')]
	#[Parameter(Position=2,Mandatory=$true,ParameterSetName='Informar')]
	#[switch]$comdesinf
)

$file_exits = Test-Path $pathzip;
if($file_exits -ne $true){
	Write-Host "El archivo de entrada no existe. Ultice la opcion Get-Help para ver la ayuda del script."
	exit;
}

	
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
try{
	$RawZips = [io.compression.ZipFile]::OpenRead($pathzip).Entries
}catch{
	Write-Host "El archivo de entrada no existe. Ultice la opcion Get-Help para ver la ayuda del script."
	exit;
}	

$ObjArray = @();
foreach($RawZip in $RawZips){
	$comprimido=($RawZip.CompressedLength/1KB).ToString(00);
	$original=00;
	if($RawZip.Length -gt 0){
		$original=($RawZip.Length/1KB).ToString(00);
	}
	
	$object = New-Object psobject
	$object | Add-Member -MemberType NoteProperty -Name Nombre_Archivo($RawZip.Name)
	$orig=($original/1024).ToString()+" MB";
	$object | Add-Member -MemberType NoteProperty -Name Tamaño_Original($orig)
	$compri=($comprimido/1024).ToString()+" MB",
	$object | Add-Member -MemberType NoteProperty -Name Tamaño_Comprimido($compri)

	#valido que no se divida por cero
	$notzero=0;
	try{
		$notzero=$comprimido/$original;
	}catch{
		$divido_cero=1;
	}
	#Muestro la relación con 2 decimales
	$object | Add-Member NoteProperty Relación($notzero.ToString("0.00"))
	if($RawZip.Name -and $original){
		$ObjArray += $object
	}
}

#Imprimo
$ObjArray | Format-Table




