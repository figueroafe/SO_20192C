<#
	.Synopsis
	Script creado para realizar la compresión y descompresión de directorios,
	tambien informa el contenido de los archivos con extensión .zip
	.Description
	El script es llamado indicando los directorios de origen y destino para realizar
	la compresión o descompresión de los archivos
	.Example
	./ej4.ps1 -pathzip C:\user\docs -directorio C:\destino\docs.zip -comprimir
	./ej4.ps1 -pathzip C:\destino\docs.zip -directorio C:\user\docs -descomprimir
	./ej4.ps1 -pathzip C:\destino\docs.zip -informar
#>

Param (
	[Parameter(Position=0,Mandatory=$true)]
	[string]$pathzip,
	
	[Parameter(Mandatory=$false)]
	[string]$directorio,
	
	[Parameter(Mandatory=$true,ParameterSetName='Descomprimir')]
	[switch]$descomprimir,
	[Parameter(Mandatory=$true,ParameterSetName='Comprimir')]
	[switch]$comprimir,
	[Parameter(Mandatory=$true,ParameterSetName='informar')]
	[switch]$informar
)

$file_exits = Test-Path $pathzip;

if($file_exits -ne $true){
	Write-Host "El archivo de entrada no existe. Ultice la opcion Get-Help para ver la ayuda del script."
	exit;
}

if( ($PSBoundParameters.Count -lt 2) -or ($PSBoundParameters.Count -lt 3) ){
	Write-Host ""
	Write-Host "La cantidad de parametros es invalidad, ejecute el comando get-help para ver la ayuda."

	exit;
}
if($comprimir.IsPresent -and $descomprimir.IsPresent){
	Write-Host "Acción no permitida, de necesitar ayuda ejecute el comando get-help"
	exit
}

if($comprimir.IsPresent -and $informar.IsPresent){
	Write-Host "Acción no permitida, de necesitar ayuda ejecute el comando get-help"
	exit
}

if($descomprimir.IsPresent -and $informar.IsPresent){
	Write-Host "Acción no permitida, de necesitar ayuda ejecute el comando get-help"
	exit
}

if($comprimir.IsPresent){
	
	$valid_path = Test-Path $directorio;
	if($valid_path -ne $true){
		Write-Host "El directorio indicado no existe. Ultice la opcion Get-Help para ver la ayuda del script."
		exit;
	}


	Add-Type -Assembly 'System.IO.Compression.FileSystem'
	[System.IO.Compression.ZipFile]::CreateFromDirectory($pathzip, $directorio)
}

if($descomprimir.IsPresent){

	$valid_path = Test-Path $directorio;
	if($valid_path -ne $true){
		Write-Host "El directorio indicado no existe. Ultice la opcion Get-Help para ver la ayuda del script."
		exit;
	}

	Add-Type -Assembly 'System.IO.Compression.FileSystem'
	[System.IO.Compression.ZipFile]::ExtractToDirectory($pathzip, $directorio,$true)
}

if($informar.IsPresent){
	add-Type -AssemblyName system.io.compression.filesystem
		try{
			$RawZips = [io.compression.ZipFile]::OpenRead($pathzip).Entries
		}catch{
			Write-Host "El archivo de entrada no existe. Ultice la opcion Get-Help para ver la ayuda del script."
			exit;
		}	
		#Utilizo un array para filtrar las opciones de read command
		$ObjArray = @();
		foreach($RawZip in $RawZips){
			$comprimido=($RawZip.CompressedLength/1KB).ToString(00); #Divido el total por 1KB
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
}
else {
	Write-Host "Parametro invalido. Para obtener ayuda ejecute get-help ej4.ps1"
	exit;
}