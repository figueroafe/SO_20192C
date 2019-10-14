#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h> 
#include <netdb.h>

int main(int argc, char *argv[])
{
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        printf("Error: No se pudo crear el socket.");
        return 1;
    } 

    char recvBuff[1024];
    memset(recvBuff, '0',sizeof(recvBuff));

    struct sockaddr_in serv_addr; 
    memset(&serv_addr, '0', sizeof(serv_addr)); 

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(5000); 

    inet_pton(AF_INET, argv[1], &serv_addr.sin_addr); // Error si IP mal escrita
    
    if ( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       printf("Error: No se pudo conectar\n");
       return 1;
    } 

    int bytesRecibidos = 0;
    while ( (bytesRecibidos = read(sockfd, recvBuff, sizeof(recvBuff)-1)) > 0)
    {
        recvBuff[bytesRecibidos] = 0;
        printf("%s\n", recvBuff);
    } 

    return 0;
}
