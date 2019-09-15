BEGIN{ 
	 comentarios = 0;
	 codigo = 0;
}
{ 
   if(pos = index($0, "/*")){
	if(pos > 1){
        codigo++;
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
        	codigo++;
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
