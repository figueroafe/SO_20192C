/************  inicio encabezado  **************
# Nombre Script: "tp3_ej4_servidor.c"
# Numero Trabajo Practico: 3
# Numero Ejercicio: 4
# Tipo: 1° Entrega
# Integrantes:
#
#	Nombre y Apellido                           DNI
#	---------------------                       ----------
#       Francisco Figueroa	                    32.905.374
#       Adrian Morel		                    34.437.202
#       Sergio Salas                                32.090.753
#       Fernando Sanchez	 		    36.822.171
#       Sabrina Tejada			       	    37.790.024
***************  fin encabezado  ***************/
#include <stdio.h>
#include <stdlib.h>
#include <sys/shm.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/types.h>
#include <signal.h>
#include <semaphore.h>
#include <sys/stat.h>
#include <time.h>

sem_t* mutex_0, *mutex_1, *mutex_2;
int fd;
char *buffer;
void ayuda(void);
void eliminar_segmento();
FILE *fp;

int main(int argc, char *argv[])
{
      if(argc > 2 || argc <=1 ){
	printf("La cantidad de parametros no es correcta, utilice ./servidor -help para ver la ayuda..\n");
	return 1;
      }
      
      //Validaciones
      if(argc == 2 && strcmp(argv[1],"-help") == 0)
      {
         ayuda();
         return 1;
      }
      
	fp = fopen(argv[1], "r");
	if(fp == NULL){
		printf("\nNo se encontró el archivo de artículos, revise la ubicación.\n");
		return 1;
	    }
    //Fin validaciones

    char *aux='\0';
    char id_item[100];
    char articulo[100];
    char producto[100];
    char marca[100];
    char campo[100];
    char valor[100];
    char linea[500];
    int contador=0, consultas = 0;

    fd = shm_open("shm", O_CREAT | O_EXCL | O_RDWR, 0600); //creacion de memoria compartida
    if(fd < 0){
	printf("Error - No pudo crearse un area de memoria compartida.\n");
	exit(1); 
	}
    ftruncate(fd, 65536);
	mutex_0 = sem_open("mutex_0", O_CREAT, 0777, 0); //creacion de semaforo
	mutex_1 = sem_open("mutex_1", O_CREAT, 0777, 1); //creacion de semaforo
	mutex_2 = sem_open("mutex_2", O_CREAT, 0777, 0); //creacion de semaforo
	
    signal(SIGINT, eliminar_segmento); //atrapo la señal sigint y cierro el servidor
    signal(SIGTERM, eliminar_segmento); //atrapo la señal sigterm y cierro el servidor
	while(1  && consultas < 5){

	    printf("Pidiendo semaforo de lectura...\n");
	    sem_wait(mutex_0);
	    printf("Semaforo obtenido, leyendo consulta...\n");
	    buffer = (char *) mmap(0, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	    printf("\nconsulta recibida: %s\n\n", buffer);
	    aux=strrchr(buffer, '=');
	    if(aux == NULL){
		strcpy(buffer, "\nRevise la consulta, debe tener formato CAMPO=VALOR\n");
		sem_post(mutex_2);
		sem_close(mutex_0);
	    	sem_close(mutex_1);
	    	sem_close(mutex_2);
	    	munmap(buffer, 65536);
	    	shm_unlink("shm");
		return 1;
	    }

	    aux = strtok(aux, "\n");
	    strcpy(valor, aux+1);
	    *aux = '\0';

	    aux = strtok(buffer,"=");
	    strcpy(campo, aux);
	    *aux = '\0';

	    buffer[0] = '\0';
	    printf("Buscando coincidencias...\n");
	    sleep(10);
	    while(fgets(linea, sizeof(linea), fp)){

		aux = strrchr(linea, '\r');
		if(aux != NULL){
		    aux=strtok(strrchr(linea, ';'), "\r");
		    strcpy(marca, aux+1);
		    *aux = '\0';
		}

		else{
		    aux=strtok(strrchr(linea, ';'), "\n");
		    strcpy(marca, aux+1);
		    *aux = '\0';
		}

		strcpy(marca, aux+1);
		*aux = '\0';

		aux = strrchr(linea, ';');
		strcpy(producto, aux+1);
		*aux = '\0';

		aux = strrchr(linea, ';');
		strcpy(articulo, aux+1);
		*aux = '\0';

		sscanf(linea, "%10s", id_item);

		if((strcmp(id_item, valor) == 0 && strcmp("ITEM_ID", campo) == 0) ||
		    (strcmp(articulo, valor) == 0 && strcmp("ARTICULO", campo) == 0) ||
		    (strcmp(producto, valor) == 0 && strcmp("PRODUCTO", campo) == 0) ||
		    (strcmp(marca, valor) == 0 && strcmp("MARCA", campo) == 0)){

		    contador++;

		    strcat(buffer, id_item);
		    strcat(buffer, ";");
		    strcat(buffer, articulo);
		    strcat(buffer, ";");
		    strcat(buffer, producto);
		    strcat(buffer, ";");
		    strcat(buffer, marca);
		    strcat(buffer, "\n");

		}

    	}
	
	if(contador == 0)
   	strcpy(buffer, "\nNo se encontraron registros que coincidan con la búsqueda.\n\n");

	    rewind(fp);    
	    printf("Enviando respuesta...\n");
	    sem_post(mutex_2);
	    printf("Semaforo de lectura de buffer liberado...\n");
	    consultas++;
   }
    fclose(fp);
    printf("Eliminando segmento de memoria compartida...\n");
    sem_close(mutex_0);
    sem_close(mutex_1);
    sem_close(mutex_2);
    munmap(buffer, 65536);
    shm_unlink("shm");
    return(1);
}

//FUNCIONES
void ayuda(){

    printf("\n-------------------------------------------------------------------------------\n");
    printf("--------------------------- Ayuda Ejercicio 4 ---------------------------------\n");
    printf("-------------------------------------------------------------------------------\n");
    printf("\n*Descripción:\n\n");
    printf("El Servidor crea un espacio de memoria compartida en el cual los\n");
    printf("procesos consumidores pueden generar consultas sobre el fichero maestro.\n");
    printf("El espacio de memoria compartida esta sincronizado mediante el uso de\n");
    printf("semaforos. Requiere como parametro la ruta del fichero maestro.\n");
    printf("Las respuestas tienen una demora de 10seg para que se pueda ver el uso\n");
    printf("sincronizado de los consumidores al area critica para consultar.\n");
    printf("El segmento se elimina al ingresar una consulta erronea, al realizar 5 \n");
    printf("consultas o al enviar una señal SIGINT con Ctrl+C desde la terminal\n");
    printf("solo para los fines practicos del ejercicio del tp.\n\n");
    printf("*Ejemplos\n\n");
    printf("./server /tmp/articulos.txt \n\n");
}

void eliminar_segmento(){

	sem_close(mutex_0);
	sem_close(mutex_1);
	sem_close(mutex_2);	
	munmap(buffer, 65536);
	shm_unlink("shm");
	close(fd);
	exit(1);
}
