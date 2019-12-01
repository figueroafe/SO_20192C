/************  inicio encabezado  **************
# Nombre Script: "tp3_ej5_cliente.c"
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
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <signal.h>
void eliminar_socket();
void ayuda();
int sockfd = 0;
int main(int argc, char *argv[])
{
    if(argc == 2)
    {
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

    /*Fin de validaciones*/

    struct servent *puerto;
    puerto = getservbyname ("systat", "tcp");

    if (puerto == NULL)
    {
        printf ("Error\n");

    }


    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        printf("Error: No se pudo crear el socket.");
        return 1;
    }

    char recvBuff[1024];
    char sendBuff[1024];
    char *aux;
    memset(recvBuff, '0',sizeof(recvBuff));
    memset(sendBuff, '0',sizeof(sendBuff));
    struct hostent *servidor;
    servidor = gethostbyname(argv[1]);

    if(servidor == NULL)
	{	
	 printf("No se pudo ubicar el host del servidor\n");
	 exit(2);
		}
    struct sockaddr_in serv_addr;
    memset(&serv_addr, '0', sizeof(serv_addr));
    memcpy(&serv_addr.sin_addr.s_addr, servidor->h_addr_list[0], servidor->h_length);
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(atoi(argv[2]));
  /*  serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
    if(inet_pton(AF_INET, argv[1], &serv_addr.sin_addr) != 1)
    {
      printf("Error - Direccion IP no valida\n");
      exit(1);
    }*/

    if(connect(sockfd,(struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       printf("Error: No se pudo conectar\n");
       return 1;
    }

    signal(SIGINT, eliminar_socket); //atrapo la señal sigint y cierro el cliente
    signal(SIGTERM, eliminar_socket); //atrapo la señal sigterm y cierro el cliente
    while(1)
    {
        printf("Ingrese una consulta: ");
        fgets(sendBuff, sizeof(sendBuff), stdin);
        aux = strtok(sendBuff, "\n");
            if(strcmp(aux, "QUIT") == 0)
            {
                printf("Cerrando Conexion...\n");
                send(sockfd, sendBuff, strlen((sendBuff)-1), 0);
            //    sleep(1);
            //    close(sockfd);
                sleep(1);
                exit(1);
            }
        aux = strrchr(sendBuff, '=');
        if(aux == NULL)
        printf("Error - Consulta con formato incorrecto\n");
        else
        {
            send(sockfd, sendBuff, strlen((sendBuff)-1), 0);
            sleep(3);

            int bytesRecibidos = 0;
	    printf("\n");
            while((bytesRecibidos = recv(sockfd, recvBuff, sizeof(recvBuff)-1, MSG_DONTWAIT)) > 0)
            {
                recvBuff[bytesRecibidos] = 0;
		fflush(stdout);
                printf("%s", recvBuff);
                memset(recvBuff, '0',sizeof(recvBuff));
            }
        }

    }
    return 0;
}

void eliminar_socket(){
	printf("\nSeñal recibida, cerrando conexión\n");
	exit(1);
}
void ayuda(){

    printf("\n-----------------------------------------------------------------------------------\n");
    printf("---------------------Ayuda Ejercicio 5 - Cliente-----------------------------------\n");
    printf("-----------------------------------------------------------------------------------\n");
    printf("\nDescripción:\n\n");
    printf("*El Cliente tiene la posibilidad de conectarse a un servicio de red en el cual\n");
    printf("*va a poder consultar sobre los articulos del maestro de archivos.\n");
    printf("*Para ello debe indicar la ip o el nombre del host donde se encuentra el servidor\n");
    printf("*y el puerto del mismo.\n");
    printf("*Una vez establecida la conexion puede consultar mediante el formato CAMPO=VALOR.\n");
    printf("*Paso siguiente se imprimira el resultado por pantalla. Para salir debe indicarlo.\n");
    printf("*ingresando QUIT por teclado.");
    printf("\n\nParámetros:\n\n");
    printf("*Direccion IP: Direccion ip del servidor\n");
    printf("*Puerto: Puerto de comunicacion del servidor\n");
    printf("\nEjemplos:\n\n");
    printf("* ./ej5_cliente 192.168.1.2 7000\n");
    printf("*ID=979\n\n");
    printf("* ./ej5_cliente 192.168.2.5 8000\n");
    printf("*QUIT\n\n");
    printf("*./ej5_cliente hostname 6789\n");
    printf("*MARCA=MAROLIO\n\n");
}

