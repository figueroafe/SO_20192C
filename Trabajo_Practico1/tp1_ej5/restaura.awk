BEGIN	{
		cont=0;
		}
								
		{
		expresion="^"archivo"[0-9]";  
		if ($NF ~ expresion) #Si lo que se intenta restaurar esta en el archivo de rutas
			{system("echo "$0" >> ~/.papelera/.restaurar.txt");
			cont++; #Copia a un archivo de rutas a restaurar
			}
		else
			system("echo "$0" >> ~/.papelera/.norestaurar.txt"); #Copia a un archivo de rutas a no restaurar
		}
		
END	{
	if(cont == 0) #Si no se encontró ninguna coincidencia con lo que se intenta restaurar
		printf "\nNo se encontro ningún archivo en la papelera que coincida con la búsqueda. Debe indicar el nombre del archivo y la extensión, intente de nuevo\n\n";
	else
		{printf "\nEl/los archivo/s se ha/n restaurado a su ubicación original\n\n";
		system("mv ~/.papelera/.norestaurar.txt ~/.papelera/.rutas.txt");
		}
	}