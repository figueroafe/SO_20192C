function verLineaPorIzq(){
	subc = substr($0, 1, pos-1);
	print subc;
	if(index(subc, "//") == 1)
	senal++;
	else
	codigo++;
}

function verLineaPorDer(){
    subc2 = substr($0, fincom+2, (length($0)-fincom));
    print subc2;
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
	 senal = 0;
}
{ 
   if(pos = index($0, "/*")){
	if(pos > 1){
      verLineaPorIzq();
    }
	  inicom = 1;
	  fincom = index($0, "*/")
		while(!fincom){
		 inicom++;
		 getline;
		 fincom = index($0, "*/")
		}
	   comentarios+=inicom;
	   if(fincom+1 < length($0)){
        	verLineaPorDer();
        }
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
	}  
}	
END{
print comentarios > "/tmp/com.txt";
print codigo > "/tmp/cod.txt";
}
