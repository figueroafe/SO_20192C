BEGIN{ 
	 comentarios = 0;
	 codigo = 0;
	 nrolinea = 1;
	 lineas = 0;
}
{ 
   if(index($0, "/*")){
	  inicom = 1;
	  fincom = index($0, "*/")
		while(! fincom){
		 inicom++;
		 lineas++;
		 getline;
		 fincom = index($0, "*/")
		}
	   comentarios+=inicom;
	}
	else
	{
	if(t = index($0, "//")){
		    if(t == 1){
		    comentarios++;}
		    else{
		    comentarios++;
		    codigo++;}
		}
		else
		codigo++;

    	lineas++;
	}  
}	
END{
print comentarios > "com.txt";
print codigo > "cod.txt";
print lineas > "lineas.txt";
}
