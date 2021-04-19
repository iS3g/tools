# Para que funcione es necesiario las DLL 7za.dll y 7zxa.dll con el exe 7za.exe
# Tipos de compresion: '7z','zip','gzip','bzip2','tar','iso','udf'
# descargado desde https://www.7-zip.org/a/7z1900-extra.7z


function comprimir(
    [string]$Directorio, 
    [string]$ArchivoZip, 
    [string]$Password, 
    [string]$TipoCompresion = '7z'
)
{
	# "Descarga de 7zip"
	$enlace = "https://github.com/iS3g/tools/raw/main/7z/7z.zip"
	$pathLocal = (Get-Location).toString() + "\"
	$destino = $pathLocal +  "7z.zip"
	Invoke-WebRequest -Uri $enlace -OutFile $destino
	
	#extraccion 
	#if (Test-Path $destino) { Remove-Item $destino -Force }
	Expand-Archive -Path 7z.zip -DestinationPath $pathLocal
	
	$7Zip = "\7za.exe"
    $static7ZipPath = (Get-Location).toString() + $7Zip
	echo $static7ZipPath

	if (Test-Path $static7ZipPath) {	
		$pathTo7ZipExecutable = $static7ZipPath
	}
	 else {
        throw "7-Zip No se encuentra en el sistema!"
    }

    # Borrar el archivo si existe
    if (Test-Path $ArchivoZip) { Remove-Item $ArchivoZip -Force }

    # Argumentos
    $arguments = "a -t$TipoCompresion ""$ArchivoZip"" ""$Directorio"" -mx9"
    
    # Con password
    if (!([string]::IsNullOrEmpty($Password))) { $arguments += " -mhe -p$Password" }

    # Comando para la compresion
	echo "Comprimiendo...." 
    $p = Start-Process $pathTo7ZipExecutable -ArgumentList $arguments -Wait -PassThru -WindowStyle "Hidden" 

    # En caso que no se comprima
    if (!(($p.HasExited -eq $true) -and ($p.ExitCode -eq 0)))
    {
        throw "Error!! no se creo el comprimido... '$ArchivoZip'."
    }
	else{
		echo "Archivo comprimido '$ArchivoZip' "
	}

}
