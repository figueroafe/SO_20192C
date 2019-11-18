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
    //char rutaFifoEntrada[500];
    //char rutaFifoSalida[500];
    int contador=0;
    char ruta1[500]="/tmp/ent";
    char ruta2[500]="/tmp/sal";
    int fd1, fd2;
    FILE *fp1, *fp2, *fdaemon;
    pid_t pid, sid;

/****************************** VALIDACIONES ***************************/

    if(argc == 1){
        printf("\nParámetros insuficientes, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    if(argc > 3){
        printf("\nDemasiados parámetros, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    if(argc == 2){

        if(strcmp(argv[1],"-help") == 0){
            ayuda();
            return 1;
        }

        if(strcmp(argv[1], "-detener") == 0 && argc == 2){
            char fila[7];
            fdaemon = fopen("demonio.txt","r");
            fgets(fila, sizeof(fila), fdaemon);
            sscanf(fila,"%d", &pidDemonio);
            kill(pidDemonio,SIGINT);
            fclose(fdaemon);
            return 1;
        }
    }

    if(argc == 3){

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

    else{
        printf("\nLa cantidad de parámetros es incorrecta, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

/****************************** DEMONIO ********************************/

    /*
    if (pid != 0){
        return 1;
    }

    else{
        fp1 = fopen("demonio.txt", "w");
        fprintf(fp1,"%d",getpid());
        umask(0);
        sid = setsid();

        if(sid < 0){
            perror("\nNo se pudo generar el demonio\n\n");
            exit(EXIT_FAILURE);
        }

        fclose(fp1);

        chdir("/home");
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);*/

/****************************** MANEJO DE ARCHIVOS ****************************/

        while(1){

            printf("\nEsperando consulta ...\n");
            fd1 = open(ruta1, O_RDONLY);
            read(fd1, consulta, sizeof(consulta));

            fd2 = open(ruta2, O_WRONLY | O_NONBLOCK);

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

            fp2 = fopen("articulos.txt", "r");
            if(fp2 == NULL){
                printf("\nNo se encontró el archivo de artículos, revise la ubicación.\n");
                return 1;
            }

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
            fclose(fp2);
            contador=0;
        }
    //}

    return 0;
}

/****************************** FUNCIONES ******************************/

void ayuda(){

    printf("\n-------------------------------------------------------------------------------\n");
    printf("--------------------------- Ayuda Ejercicio 3 ---------------------------------\n");
    printf("-------------------------------------------------------------------------------\n");
    printf("\nDescripción\n");
    printf("El demonio lee de un FIFO las consultas y devuelve por\n");
    printf("otro FIFO los registros coincidentes que encuentre. Toma por\n");
    printf("parámetro la ruta y nombre de los FIFO y los crea de ser necesario.\n");
    printf("\nParámetros\n");
    printf("Origen: Ruta del FIFO donde se buscan las consultas realizadas (una a la vez).\n");
    printf("Destino: Ruta del FIFO donde se arrojan los resultados de las consultas.\n");
    printf("-detener: Detiene el proceso demonio.\n");
    printf("\nSintáxis\n");
    printf("./tp3_ej3 [origen] [destino]\n");
    printf("./tp3_ej3 -detener\n");
    printf("\nEjemplos\n");
    printf("./tp3_ej3 /tmp/consultas /tmp/resultados\n");
    printf("./tp3_ej3 -detener\n\n");
}
