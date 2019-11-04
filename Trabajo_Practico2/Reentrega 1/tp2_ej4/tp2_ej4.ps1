#-----------------------Inicio Encabezado------------------------------##
# Nombre Script: "tp2_ej4.ps1"
# Numero Trabajo Practico: 2 
# Numero Ejercicio: 4
# Tipo: 2° Entrega
# Integrantes:
#
#		Nombre y Apellido                              DNI
#		---------------------                       ----------
#       Francisco Figueroa                          32.905.374
#       Adrian Morel                                34.437.202
#       Sergio Salas                                32.090.753                 
#       Fernando Sanchez                            36.822.171
#       Sabrina Tejada                              37.790.024
#
##-----------------------Fin del Encabezado-----------------------------##

<#
	.Synopsis
	Script creado para realizar la compresión y descompresión de directorios,
	tambien informa el contenido de los archivos con extensión .zip
	.Description
	El script es llamado indicando los directorios de origen y destino para realizar
	la compresión o descompresión de los archivos
	.Example
	./ej4.ps1 -pathzip C:\destino\docs.zip -directorio C:\user\docs  -comprimir
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

if($comprimir.IsPresent -and $informar.IsPresent){
	Write-Host "Acción no permitida, de necesitar ayuda ejecute el comando get-help"
	exit
}

if($descomprimir.IsPresent -and $informar.IsPresent){
	Write-Host "Acción no permitida, de necesitar ayuda ejecute el comando get-help"
	exit
}

if($comprimir.IsPresent){
	
	#busco la ruta completa
	$dest = Resolve-Path $directorio;

	#consulto si es valida
	$valid_path = Test-Path $dest;
	if($valid_path -ne $true){
		Write-Host "El directorio indicado no existe. Ultice la opcion Get-Help para ver la ayuda del script."
		exit;
	}

	Add-Type -Assembly 'System.IO.Compression.FileSystem'
	#[System.IO.Compression.ZipFile]::CreateFromDirectory($directorio,$pathzip)
	$compresion = [System.IO.Compression.CompressionLevel]::Optimal 
	[System.IO.Compression.ZipFile]::CreateFromDirectory($dest,$pathzip,$compresion,$true)
	exit;
}

if($descomprimir.IsPresent){

	#Consulto si existe el archivo a descomprimir
	$file_exits = Test-Path $pathzip;
	if($file_exits -ne $true){
		Write-Host "El archivo de entrada no existe. Ultice la opcion Get-Help para ver la ayuda del script."
		exit;
	}
	
	#consulto si existe el directorio donde voy a descomprimir el archivo zip
	$valid_path = Test-Path $directorio;
	if($valid_path -ne $true){
		Write-Host "El directorio indicado no existe. Ultice la opcion Get-Help para ver la ayuda del script."
		exit;
	}
	
	#consulto por si hay contenido en el archivo zip
	$contenido = Get-ChildItem $directorio | Measure-Object
	if($contenido.Count -ne 0){
		Write-Host "Revisar el directorio de destino. El directorio debe estar vacio para realizar esta accion."
		exit;
	}

	Add-Type -Assembly 'System.IO.Compression.FileSystem'
	[System.IO.Compression.ZipFile]::ExtractToDirectory($pathzip, $directorio)
	exit;
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