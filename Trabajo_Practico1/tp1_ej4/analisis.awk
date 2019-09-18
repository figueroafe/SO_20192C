function verLineaPorDer(){	#funcion que se utiliza para ver la derecha de */
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
   if((barraBarra == 0 && barraAst != 0) || (barraAst != 0 && barraAst < barraBarra)){ #condicion para ver si /* esta 																										antes de //
	if(barraAst > 1){
      codigo++;
    }
	  inicom = 1;
	  fincom = index($0, "*/")
      haylinea=1;
		while(!fincom && haylinea){	#no encuentra */ y puede seguir recorriendo
		 inicom++;
		 haylinea = getline;
		 fincom = index($0, "*/")
		}
       if(haylinea){
	   comentarios+=inicom;
	   if(fincom+1 < length($0)){  #si tengo mas caracteres a la derecha de */
        	verLineaPorDer();
        }}
        else
        comentarios+=inicom-1; #entra por no tener fin /*
	}
	else
	{
	if(barraBarra != 0){	#encontre //
		    if(barraBarra == 1){
		    comentarios++;}
		    else{
		    comentarios++;
		    codigo++;}
		}
		else
		codigo++;	#entra si no hay // ni /* en esa linea
	}  
}	
END{
print comentarios > "/tmp/com.txt";
print codigo > "/tmp/cod.txt";
}
