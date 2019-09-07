BEGIN{ 
	 comentarios = 0;
	 codigo = 0;
	 senal = 0;
	 lineas = 0;
	 reg = "//*"
}
{ 

		if($0 ~ reg){
			comentarios++;
			senal = 1;
		}
		if(senal == 0){
			codigo++;
		}
			senal = 0;
			lineas++;
}	
END{
print comentarios > "com.txt";
print codigo > "cod.txt";
print lineas > "lineas.txt";
}
