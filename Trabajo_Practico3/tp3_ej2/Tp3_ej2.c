#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <math.h>
#define TAM 50
    pthread_mutex_t mutex;

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
	printf("make Tp3_ej2 para compilar");
	printf("./Tp3_ej2[cantidad de threads] [directorio donde se almacenan los archivos a procesar] \n");
    printf("make Tp3_ej2 [-help/-?] \n");
	printf("\n\nEjemplo:\n");
	printf("./Tp3_ej2 -? \n");
	printf("./Tp3_ej2 -? \n");
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

int main()
{
    int canth, ok =0, ch;
    FILE *arch, *salida;
    char linea[TAM],n1[TAM],n2[TAM], ruta[50];
    t_params p;

    printf("ingrese ruta de archivo con vectores (sin .txt):\n");
    scanf("%s",&ruta);
    fflush(stdout);
    strcat(ruta,".txt");
    ///validar rutas absolutas y relativas
    arch = fopen(ruta,"r");
    if(!arch){
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
        return 1;
    }

    printf("Cantidad de elementos a sumar: %d\n", p.tamVec+1);

    ///repartir trabajo en los hilos
    p.ubic=0;
    p.cantS = ceil((p.tamVec+1)/canth);
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
