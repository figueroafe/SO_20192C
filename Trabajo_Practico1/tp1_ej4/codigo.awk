BEGIN{ 
	 comentarios = 0;
	 codigo = 0;
	 lineas = 0;
}
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
END{
print comentarios > "com.txt";
print codigo > "cod.txt";
print lineas > "lineas.txt";
}
