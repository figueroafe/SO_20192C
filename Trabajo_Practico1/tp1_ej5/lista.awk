BEGIN	{
		printf "\t\t\tArchivos de la papelera\n"
		printf "======================================================================\n"
		printf "Nombre del archivo\t\t\tUbicacion original\n"
		printf "------------------\t\t\t------------------------------\n"
		}
					
		{
		if ($NF !~ /^$/) #Si la línea no está vacía
			{nombre=substr($NF, 1, length($NF)-1);
			ruta=substr($0, 1, index($0, $NF)-1);
			printf ""nombre"\t\t\t"ruta"\n";
			}
		}