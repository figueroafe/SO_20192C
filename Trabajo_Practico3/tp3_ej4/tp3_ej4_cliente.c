/************  inicio encabezado  **************
# Nombre Script: "tp3_ej4_cliente.c"
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
#include <sys/ipc.h>

void ayuda(void);
sem_t* mutex_0;
sem_t* mutex_1;
sem_t* mutex_2;
char *buffer;
int fd;
void eliminar_segmento();

int main(int argc, char *argv[])
{
    //VALIDACIONES
    if(argc != 2){
        printf("\nCantidad de parámetros incorrectos, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    else{

        if(strcmp(argv[1],"-help") == 0){
            ayuda();
            return 1;
        }

    }
    //BUSCA EL ESPACIO DE MEMORIA COMPARTIDA
    fd = shm_open("shm", O_RDWR, 0777);
     if(fd < 0){
	printf("Error - No pudo acceder al area de memoria compartida.\n");
	exit(1); 
	}
    mutex_0 = sem_open("mutex_0", O_RDWR);
    mutex_1 = sem_open("mutex_1", O_RDWR);
    mutex_2 = sem_open("mutex_2", O_RDWR);
    //MAPEO DEL ESPACIO DE MEMORIA COMPARTIDA
    signal(SIGINT, eliminar_segmento); //atrapo la señal sigint y cierro el cliente
    signal(SIGTERM, eliminar_segmento); //atrapo la señal sigterm y cierro el cliente
    buffer = (char *)mmap(0, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    printf("Pidiendo semaforo de share memory...\n");
    sem_wait(mutex_1);
    printf("Semaforo otorgado...Acesso a share memory...\n");
    strcpy(buffer, argv[1]);
    printf("Liberando semaforo de lectura del buffer...\n");
    sem_post(mutex_0);
    printf("Semaforo liberado!...Pidiendo semaforo de respuesta..\n");
    sem_wait(mutex_2);
    printf("Semaforo de respuesta obtenido....\n");
    puts(buffer);
    printf("Liberando share memory para la siguiente consulta...\n");
    sem_post(mutex_1);
    printf("Finalizado!\n");
    sem_close(mutex_0);
    sem_close(mutex_1);
    sem_close(mutex_2);
    munmap(buffer, 65536);
    return 1;
}
    //FUNCIONES
void ayuda(){

    printf("\n-------------------------------------------------------------------------------\n");
    printf("--------------------------- Ayuda Ejercicio 4 ---------------------------------\n");
    printf("-------------------------------------------------------------------------------\n");
    printf("\nDescripción\n");
    printf("El proceso lee de un espacio de memoria compartida las consultas y\n");
    printf("devuelve por pantalla los registros coincidentes que encuentre. Toma\n");
    printf("por parámetro la consulta con formato CAMPO=VALOR.\n");
    printf("\nParámetros\n");
    printf("Consulta: Consulta a realizar.\n");
    printf("\nSintáxis\n");
    printf("./tp3_ej4 [consulta]\n");
    printf("\nEjemplos\n");
    printf("./tp3_ej4 MARCA=GEORGALOS\n\n");
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
