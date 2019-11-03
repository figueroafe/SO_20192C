#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>

struct archivocsv
  {
      int id_item;
      char articulo[100];
      char producto[100];
      char marca[100];
  } campoarchivo;

int main(void)
{
    FILE *fp;
    fp = fopen( "articulos.txt", "r" );
    if(fp == NULL) {printf("File error"); exit(1);} else printf("Archivo encontrado!\n");

    char linea[500];
    char *aux;
    while(fgets(linea, sizeof(linea-1), fp)){
    aux = strrchr(linea, ';');
    strcpy(campoarchivo.marca, aux+1);
  //  campoarchivo.marca = strtok(linea,";");
    printf("%s",campoarchivo.marca);
 //   printf("%s", linea);
    }
    fclose(fp);
    return 0;
}
