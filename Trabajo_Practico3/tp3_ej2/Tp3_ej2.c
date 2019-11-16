#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <math.h>
#define TAM 50
pthread_mutex_t mutex;

/************  inicio encabezado  **************

# Nombre Script: "Tp3_ej2.sh"
# Numero Trabajo Practico: 3
# Numero Ejercicio: 2
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


typedef struct{
    int tamVec, cantS, ubic;
    double v1[TAM], v2[TAM], salida[TAM];
}t_params;

void limpiarVector ( char v[],int t){
    int e;
    for(e=0; e<t; e++){
        v[e]='\n';
    }
    return;
}
void mostrar_ayuda()
{

    printf("\nSinopsis:\n");
	printf("El programa suma dos vectores recibidos en un archivo, y retorna el resultado en Salida.txt \n");
	printf("La suma se realizara sobre una cantidad de threads ingresadas por parametro. \n");
	printf("\n\nSintaxis:\n");
	printf("En la ubicacion del makefile ejecutar\n");
	printf("make Tp3_ej2 para compilar\n");
	printf("\nPara ejecutar:\n");
	printf("./Tp3_ej2 [directorio donde se almacenan los archivos a procesar][cantidad de threads]\n");
    printf("./Tp3_ej2 [-help/-?] \n");
	printf("\n\nEjemplo:\n");
	printf("./Tp3_ej2 -? \n");
	printf("./Tp3_ej2 ~/Documentos/Ej2Tp3/Vectores.txt  \n");
	printf("./Tp3_ej2");
}
void *sumarVectores (void *arg){

    int s=1;
    t_params *p = (t_params *)arg;

    int miub = p->ubic;
    int hilo = miub/p->cantS;
    ///posiciono la ubicacion para el siguiente hilo
    pthread_mutex_lock(&mutex);
        p->ubic = p->ubic +(p->cantS);
    pthread_mutex_unlock(&mutex);
    while(miub < p->tamVec && s <= p->cantS)
    {
        pthread_mutex_lock(&mutex);
            p->salida[miub] =p->v1[miub] +p->v2[miub];
        pthread_mutex_unlock(&mutex);
        printf("Hilo %d suma elemento de posicion: %d \n", hilo+1,miub);
        miub++;
        s++;
    }
    return;
}

int redondeo(double a){
    int p_entera= (int)a;
    if((a-p_entera)!= 0){

        return (int)a+1;
    }
     return (int)a;
}


int main(int argc, char *argv[])
{
    int canth, ok =0, ch;
    FILE *arch, *salida;
    char linea[TAM],n1[TAM],n2[TAM], ruta[50];
    t_params p;

    /**VALIDACIONES**/
    if(argc==3 || argc==2 ||argc==1){
        if(argc==2 && (!strcmp(argv[1],"-help") || !strcmp(argv[1],"-?"))){
            mostrar_ayuda();
            exit(1);
        }else{
            if(argc==2){
            /**validar direcccion y se pide cantidad*/
                if(!(arch = fopen(argv[1],"r"))){
                    printf("No existe archivo\n");
                    return 1;
                }
                do{
                    printf("ingrese entero de cantidad de hilos a usar:\n");
                    fflush(stdout);
                    if((ok = scanf("%d",&canth)) ==EOF)
                        return 1;
                    if(canth <= 0)
                    {
                        printf("La cantidad de hilos ingresada debe ser entera positiva mayor a cero. \n");
                        return 1;
                    }
                    while((ch = getchar()) != EOF && ch != '\n');
                }while(!ok);

            }

        }
        if(argc==3){
            /** validar dir y nro**/
            if(!(arch = fopen(argv[1],"r"))){
                printf("No existe archivo\n");
                return 1;
            }
            canth=atoi(argv[2]);
            if( canth <=0 || canth >100){
                printf("Cantidad Invalida\n");
                return 1;
             }

            }
        if(argc==1){
            printf("ingrese ruta de archivo con vectores (sin .txt):\n");
            scanf("%s",&ruta);
            fflush(stdout);
            strcat(ruta,".txt");
            if(!(arch = fopen(ruta,"r"))){
                printf("No existe archivo\n");
                return 1;

            }
            do{
                printf("ingrese entero de cantidad de hilos a usar:\n");
                fflush(stdout);
                if((ok = scanf("%d",&canth)) ==EOF)
                    return 1;
                if(canth <= 0)
                {
                    printf("La cantidad de hilos ingresada debe ser entera positiva mayor a cero. \n");
                    return 1;
                }
                while((ch = getchar()) != EOF && ch != '\n');
            }while(!ok);
        }

    }else{
        printf("La cantidad de parámetros no es la correcta %d\n", argc);

        exit(1);
    }


    ///Leer 2 vectores
    p.tamVec =0;
    int i,j=0,v=0;
    while ( fgets(linea,50, (FILE *) arch) ){
     p.tamVec++;
     j=0;
     for( i=0; i<strlen(linea) ;i++){
        if(linea[i] == ','){
            i++;
            j=1;
        }
        if(j!=0){
            n2[j-1]=linea[i];
            j++;
        }else{
            n1[i] = linea[i];
        }
     }

    p.v1[v] = atof(n1);
    p.v2[v] = atof(n2);
    v++;
    limpiarVector(n1,TAM);
    limpiarVector(n2,TAM);
    }
    fclose(arch);
    if(p.tamVec == 0){
        printf("El archivo se encuentra vacio \n");
        salida = fopen("Salida.txt","wt");
        fprintf(salida,"El archivo origen se encuentra vacio" );
        fclose(salida);
        return 1;
    }

    printf("Cantidad de elementos a sumar: %d\n", p.tamVec);

    ///repartir trabajo en los hilos
    p.ubic=0;
    p.cantS = redondeo(((double)p.tamVec)/(double)canth);

    printf("cant maxima de sumas x hilo = %d \n",p.cantS );
    pthread_t h[canth];
    pthread_mutex_init(&mutex, NULL);
    for(i=0; i<canth; i++){
        pthread_create(&h[i], NULL,sumarVectores,(void *)&p);
        printf("Cree hilo nro: %d \n", i+1);
    }
    ///Espero que terminen de ejecutarse los hilos para seguir
    for(i=0; i<canth; i++){
        pthread_join(h[i],NULL);
    }
    pthread_mutex_destroy(&mutex);

    salida = fopen("Salida.txt","wt");
    i=0;
    ///Grabo archivo de salida
    while (i<p.tamVec){
        fprintf(salida,"%.4f\n",p.salida[i] );
        i++;
     }

    fclose(salida);
    return 0;
}
