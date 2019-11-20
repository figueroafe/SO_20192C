/************  inicio encabezado  **************
# Nombre Script: "tp3_ej3.c"
# Numero Trabajo Practico: 3
# Numero Ejercicio: 3
# Tipo: 1° Entrega
# Integrantes:
#
#		Nombre y Apellido                           DNI
#		---------------------                       ----------
#       Francisco Figueroa	                        32.905.374
#       Adrian Morel		                        34.437.202
#       Sergio Salas                                32.090.753
#       Fernando Sanchez	 		                36.822.171
#       Sabrina Tejada			       	     		37.790.024
***************  fin encabezado  ***************/


#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <stddef.h>
#include <dirent.h>
#include <signal.h>

void ayuda();

/****************************** MAIN ********************************/

int main(int argc, char *argv[])
{

    char consulta[500];
    char id_item[100];
    char articulo[100];
    char producto[100];
    char marca[100];
    char campo[100];
    char valor[100];
    char linea[500];
    char cadena[500]="\0";
    char *aux='\0';
    int pidDemonio = 0;
    int contador=0;
    int fd1, fd2;
    FILE *fp1, *fp2, *fdaemon;
    pid_t pid, sid;

/****************************** VALIDACIONES ***************************/

    if(argc == 1 || argc == 3){
        printf("\nCantidad de parámetros incorrectos, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    if(argc > 4){
        printf("\nDemasiados parámetros, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    if(argc == 2){

        if(strcmp(argv[1],"-help") == 0){
            ayuda();
            return 1;
        }

        if(strcmp(argv[1], "-detener") == 0){
            char fila[7];
            fdaemon = fopen("/tmp/demonio.txt","r");
            fgets(fila, sizeof(fila), fdaemon);
            sscanf(fila,"%d", &pidDemonio);
            kill(pidDemonio,SIGINT);
            fclose(fdaemon);
            printf("\nEl proceso demonio se detuvo correctamente.\n\n");
            return 1;
        }

        else{
            printf("\nParámetros incorrectos, consulte ayuda con %s -help.\n\n", argv[0]);
            return 1;
        }
    }

    if(argc == 4){

        if( (strcmp(argv[1], argv[2]) == 0) ||
            (strcmp(argv[1], argv[3]) == 0) ||
            (strcmp(argv[2], argv[3]) == 0)){
                printf("\nLas rutas de los archivos no pueden ser iguales.\n\n");
                return 1;
        }

        errno=0;
        if(mkfifo(argv[1], 0666) == -1){
            if(errno == EEXIST)
                printf("\nSe usará el FIFO de entrada ya existente.\n");
            else{
                printf("\nNo se pudo crear el FIFO de entrada, revise la ruta\n\n");
                return 1;
            }
        }

        errno=0;
        if(mkfifo(argv[2], 0666) == -1){
            if(errno == EEXIST)
                printf("\nSe usará el FIFO de salida ya existente.\n");
            else{
                printf("\nNo se pudo crear el FIFO de salida, revise la ruta\n\n");
                return 1;
            }
        }
    }


/****************************** DEMONIO ********************************/

    pid = fork();

    if (pid != 0){
        exit(1);
    }

    else{
        fp1 = fopen("/tmp/demonio.txt", "w");
        fprintf(fp1,"%d",getpid());
        umask(0);
        sid = setsid();

        if(sid < 0){
            perror("\nNo se pudo generar el demonio.\n\n");
            exit(EXIT_FAILURE);
        }

        fclose(fp1);

        fp2 = fopen(argv[3], "r");
        if(fp2 == NULL){
            printf("\nNo se encontró el archivo de artículos, revise la ubicación.\n\n");
            return 1;
        }

        printf("\nEl proceso demonio fue iniciado correctamente.\n\n");

        chdir("/home");
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);


/****************************** MANEJO DE ARCHIVOS ****************************/

        while(1){
            printf("\nEsperando consulta ...\n");
            fd1 = open(argv[1], O_RDONLY);
            read(fd1, consulta, sizeof(consulta));

            fd2 = open(argv[2], O_WRONLY | O_NONBLOCK);

            aux=strrchr(consulta, '=');
            if(aux == NULL){
                write(fd2,"\nRevise la consulta, debe tener formato CAMPO=VALOR\n", 55);
                close(fd2);
                continue;
            }

            aux = strtok(aux, "\n");
            strcpy(valor, aux+1);
            *aux = '\0';

            aux = strtok(consulta,"=");
            strcpy(campo, aux);
            *aux = '\0';

            close(fd1);

            while(fgets(linea, sizeof(linea), fp2)){

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

                    strcat(cadena, id_item);
                    strcat(cadena, ";");
                    strcat(cadena, articulo);
                    strcat(cadena, ";");
                    strcat(cadena, producto);
                    strcat(cadena, ";");
                    strcat(cadena, marca);
                    strcat(cadena, "\n");
                    write(fd2, cadena, strlen(cadena));
                    cadena[0]='\0';

                }
            }

            if(contador == 0)
                write(fd2, "\nNo se encontraron registros que coincidan con la búsqueda.\n\n", 100);

            close(fd2);
            rewind(fp2);
            contador=0;
        }
    }
    fclose(fp2);
    return 0;
}

/****************************** FUNCIONES ******************************/


void ayuda(){

    printf("\n--------------------------------------------------------------------------------\n");
    printf("--------------------------- Ayuda Ejercicio 3 ----------------------------------\n");
    printf("--------------------------------------------------------------------------------\n");
    printf("\nDescripción\n");
    printf("El proceso demonio lee de un FIFO las consultas y devuelve por\n");
    printf("otro FIFO los registros coincidentes del archivo de articulos que\n");
    printf("encuentre. Toma por parámetro la ruta y nombre de los FIFO (los crea\n");
    printf("\nde ser necesario) y el archivo de artículos a evaluar.\n");
    printf("\nParámetros\n");
    printf("Origen: Ruta del FIFO donde se buscan las consultas realizadas (una a la vez).\n");
    printf("Destino: Ruta del FIFO donde se arrojan los resultados de las consultas.\n");
    printf("Archivo: Ruta del archivo de artículos a evaluar.\n");
    printf("-detener: Detiene el proceso demonio.\n");
    printf("\nSintáxis\n");
    printf("./tp3_ej3 [origen] [destino] [archivo]\n");
    printf("./tp3_ej3 -detener\n");
    printf("\nEjemplos\n");
    printf("./tp3_ej3 \"/tmp/consultas\" \"/tmp/resultados\" \"/tmp/archivos.txt\"\n");
    printf("./tp3_ej3 -detener\n\n");

}
