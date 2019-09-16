function verLineaPorDer(){
    subc2 = substr($0, fincom+2, (length($0)-fincom));
    if(index(subc2, "//") == 1)
	comentario++;
	else{
    if(index(subc2, "//") == 0)
	codigo++;
    else{
    codigo++;
    comentario++;}}
}

BEGIN{ 
	 comentarios = 0;
	 codigo = 0;
}
{ 
   barraBarra = index($0, "//");
   barraAst = index($0, "/*");
   if((barraBarra == 0 && barraAst != 0) || (barraAst != 0 && barraAst < barraBarra)){
	if(barraAst > 1){
      codigo++;
    }
	  inicom = 1;
	  fincom = index($0, "*/")
      haylinea=1;
		while(!fincom && haylinea){
		 inicom++;
		 haylinea = getline;
		 fincom = index($0, "*/")
		}
       if(haylinea){
	   comentarios+=inicom;
	   if(fincom+1 < length($0)){
        	verLineaPorDer();
        }}
        else
        comentarios+=inicom-1;
	}
	else
	{
	if(barraBarra != 0){
		    if(barraBarra == 1){
		    comentarios++;}
		    else{
		    comentarios++;
		    codigo++;}
		}
		else
		codigo++;
	}  
}	
END{
print comentarios > "/tmp/com.txt";
print codigo > "/tmp/cod.txt";
}
