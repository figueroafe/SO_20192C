/************  inicio encabezado  **************
# Nombre Script: "tp3_ej5_server.c"
# Numero Trabajo Practico: 3
# Numero Ejercicio: 5
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
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <syslog.h>
#include <signal.h>
#include <pthread.h>
#include <netdb.h>
#include <ctype.h>
pthread_mutex_t mutex;
void ayuda();
void *procesar();

typedef struct{

    int sockcli;
    char campo[100],
    valor[100],
    id_item[100],
    articulo[100],
    producto[100],
    marca[100],
    linea[500],
    sendBuff[1025],
    recevBuff[1025],
    cadena[500];
    FILE *fp;
    pthread_t tid[50];
}t_params;

int main(int argc, char *argv[])
{
   FILE *fdaemon;
  /*Validacion de parametros*/
    if(argc == 2)
    {
        if(strcmp(argv[1], "-detener") == 0)
        {
            int pidDemonio = 0;
            char fila[7];
            fdaemon = fopen("/tmp/deamonpid","r");
            fgets(fila, sizeof(fila), fdaemon);
            sscanf(fila,"%d", &pidDemonio);
            kill(pidDemonio,SIGINT);
            fclose(fdaemon);
            exit(2);
        }


        if(strcmp(argv[1], "-help") == 0)
            ayuda();
        else
            printf("El parametro no es correcto. Utilice %s -help para ver la ayuda.\n", argv[0]);

        exit(1);
    }

    if(argc < 2 || argc > 3)
    {
        printf("La Cantidad de parámetros no es correcta. Utilice %s -help para ver la ayuda.\n", argv[0]);
        exit(3);
    }

    FILE *fp;
    char puerto[20];

    if(!(fp = fopen(argv[1], "r")))
    {
      fprintf(stderr, "Error - No se pudo ubicar el fichero de consulta.\n");
      exit(1);
    }

    sscanf(argv[2],"%20s", puerto);
    int i;
    for(i = 0; i < strlen(puerto); i++)
    {
       if(!isdigit(puerto[i]))
       {
        printf("Error - Puerto no valido.\n");
        exit(1);
       }
    }
   /*Fin validaciones*/

    pid_t pid, sid;
    pid = fork();

    if (pid != 0)
    {
        exit(1);
    }
    else
    {

        fdaemon = fopen( "/tmp/deamonpid", "w" );
        int valorpid = getpid();
        fprintf(fdaemon, "%d", valorpid);
        fclose(fdaemon);
        umask(0);
        sid = setsid();

        if (sid < 0) {
        perror("new SID failed");
        exit(EXIT_FAILURE);
        }

        chdir("/home");
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
        /*Fin creacion del demonio*/

        struct sockaddr_in serv_addr;
        t_params param;
        memset(&serv_addr, '0', sizeof(serv_addr));
        serv_addr.sin_family = AF_INET;
        serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
        serv_addr.sin_port = htons(atoi(argv[2]));
        int listenfd = socket(AF_INET, SOCK_STREAM, 0);
        bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
        listen(listenfd, 10);
        param.fp = fp;
	pthread_mutex_init(&mutex,NULL);
	int i=0;
        while(1)
        {
            int connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
            param.sockcli = connfd;
            pthread_create(&param.tid[i], NULL, procesar,(void *)&param);
		i++;
        }
	pthread_mutex_destroy(&mutex);
    }
    return 1;
}

/*Ejecucion del trhead*/
void *procesar(void *arg){

    t_params *p = (t_params *)arg;
    memset(p->sendBuff, '0', sizeof(p->sendBuff));
    memset(p->recevBuff, '0', sizeof(p->recevBuff));
    memset(p->cadena, '0', sizeof(p->cadena));
    char *aux;
   
    int sockcli = p->sockcli;
    while(1)
        {

            recv(sockcli, p->recevBuff, 100, 0);
            pthread_mutex_lock(&mutex);
            aux = strtok(p->recevBuff,"\n");
            if(strcmp(aux, "QUIT") == 0)
            {
		pthread_mutex_unlock(&mutex);                
		write(sockcli, "Cerrando conexion...\n", 40);
                close(sockcli);
                return 0;
            }

            aux = strrchr(p->recevBuff, '=');

	if(aux == NULL)
	{
	    write(sockcli, "Error - Consulta con formato incorrecto\n", 50);
	 //   p->cadena[0]= '\0';
	}
	else
	{
	    aux = strtok(aux, "\n");
	    strcpy(p->valor, aux+1);
	    *aux = '\0';
	    //Campo
	    aux = strtok(p->recevBuff,"=");
	    strcpy(p->campo, aux);
	    *aux = '\0';
	}
	    int respuestas = 0;
	    while(fgets(p->linea, sizeof(p->linea), p->fp))
	    {
		aux = strrchr(p->linea, '\r');
		if(aux != NULL)
		{
		    aux = strtok(strrchr(p->linea, ';'), "\r");
		    strcpy(p->marca, aux+1);
		    *aux = '\0';
		}
		else
		{
		    aux = strtok(strrchr(p->linea, ';'), "\n");
		    strcpy(p->marca, aux+1);
		    *aux = '\0';
		}


		aux = strrchr(p->linea, ';');
		strcpy(p->producto, aux+1);
		*aux = '\0';

		aux = strrchr(p->linea, ';');
		strcpy(p->articulo, aux+1);
		*aux = '\0';

		sscanf(p->linea, "%10s", p->id_item);
		p->cadena[0]= '\0';
		if((strcmp(p->id_item, p->valor) == 0 && strcmp("ITEM_ID", p->campo) == 0) ||
		(strcmp(p->articulo, p->valor) == 0 && strcmp("ARTICULO", p->campo) == 0) ||
		(strcmp(p->producto, p->valor) == 0 && strcmp("PRODUCTO", p->campo) == 0) ||
		(strcmp(p->marca, p->valor) == 0 && strcmp("MARCA", p->campo) == 0)){

		    strcat(p->cadena, p->id_item);
		    strcat(p->cadena, ";");
		    strcat(p->cadena, p->articulo);
		    strcat(p->cadena, ";");
		    strcat(p->cadena, p->producto);
		    strcat(p->cadena, ";");
		    strcat(p->cadena, p->marca);
		    strcat(p->cadena, "\r\n");
		    send(sockcli, p->cadena, strlen(p->cadena), 0);
		    p->cadena[0]= '\0';
		    respuestas++;
		    }
	    }

            if(!respuestas)
             send(sockcli, "No se encontraron resultados..\r\n", 50, 0);

            rewind(p->fp);
            pthread_mutex_unlock(&mutex);
        }
    }

void ayuda(){

    printf("\n-------------------------------------------------------------------------------\n");
    printf("---------------------Ayuda Ejercicio 5 - Server--------------------------------\n");
    printf("-------------------------------------------------------------------------------\n");
    printf("\nDescripción:\n\n");
    printf("*El Servidor es un proceso demonio que se utiliza para resolver consultas de\n");
    printf("*un maestro de articulos a los clientes que se conectan a dicho servicio.\n");
    printf("*Se debe indicar el path de dicho fichero maestro y el puerto de comunicacion\n");
    printf("*por el cual los clientes van a conectarse.\n");
    printf("*Puede utilizar el comando lsof -i -n -P para ver su conexion, si el puerto\n");
    printf("*esta ocupado, sepa que se va a crear en un puerto aleatorio, use el comando\n");
    printf("*indicado anteriormente para verificar cual fue otorgado.\n");
    printf("\nParámetros:\n\n");
    printf("Origen: Ruta del fichero donde se buscan las consultas realizadas.\n");
    printf("Puerto: Puerto de comunicacion.\n");
    printf("-Detener: Detiene el servidor.\n");
    printf("\nEjemplo:\n\n");
    printf("./ej5_server /tmp/consultas 7000\n\n");
    printf("./ej5_server -detener\n\n");

    exit(3);

}

