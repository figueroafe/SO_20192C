/************  inicio encabezado  **************
# Nombre Script: "tp3_ej1.c"
# Numero Trabajo Practico: 3
# Numero Ejercicio: 1
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

void crearDemonio();
void ayuda();


int main(int argc, char *argv[]){

pid_t pid, pid2, pid3, pid4, pid5, pid6, pid7, pid8, pid9, pid10;

    if(argc > 2){
        printf("\nCantidad de parámetros incorrectos, consulte ayuda con %s -help.\n\n", argv[0]);
        return 1;
    }

    if(argc == 2){

        if(strcmp(argv[1],"-help") == 0) {
            ayuda();
            return 1;
        }
        else{
            printf("\nNo se reconoce parámetro, consulte ayuda con %s -help.\n\n", argv[0]);
            return 1;
        }
    }

    pid = fork();
    if(pid == 0){
        printf ("PID: %d PPID: %d Parentesco-Tipo: [hijo] - [normal]\n", getpid(), getppid());
        pid5 = fork();
        if(pid5 == 0){
            printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
            pid9 = fork();
            if(pid9 == 0)
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
            else{
                pid10 = fork();
            if(pid10 == 0)
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
            else
                sleep(60);
            }
        }
        else{
            pid6 = fork();
            if(pid6 == 0){
                printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
                pid7 = fork();
                if(pid7 == 0)
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [normal]\n", getpid(), getppid());
                else{
                    pid8 = fork();
                    if(pid8 == 0){
                        printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                        crearDemonio();
                    }
                }
            }
        }
    }
    else{
        printf ("PID: %d PPID: %d Parentesco-Tipo: [padre] - [normal]\n", getpid(), getppid());
        pid2 = fork();
        if(pid2 == 0){
            printf ("PID: %d PPID: %d Parentesco-Tipo: [hijo] - [normal]\n", getpid(), getppid());
            pid3 = fork();
            if(pid3 == 0){
                printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [demonio]\n", getpid(), getppid());
                pid4 = fork();
                if(pid4 == 0){
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                    crearDemonio();
                }
                crearDemonio();
            }
        }
    }
}

void crearDemonio(){

    pid_t sid;
    sid = setsid();

    if (sid < 0) {
        perror("\nNo se pudo generar demonio\n\n");
        exit(EXIT_FAILURE);
    }

    chdir("/home");
    close(STDIN_FILENO);
    close(STDOUT_FILENO);
    close(STDERR_FILENO);

    while(1){

    }
}

void ayuda(){

    printf("\n--------------------------------------------------------------------------------\n");
    printf("--------------------------- Ayuda Ejercicio 1 ----------------------------------\n");
    printf("--------------------------------------------------------------------------------\n");
    printf("\nDescripción\n");
    printf("El script genera mediante el uso de fork() el siguiente escenario:\n");
    printf("\n");
    printf("2 procesos hijos\n");
    printf("3 procesos nietos\n");
    printf("5 procesos bisnietos\n");
    printf("2 procesos zombies (2 bisnietos)\n");
    printf("3 procesos demonios (1 nieto y 2 bisnietos)\n");
    printf("\nParámetros\n");
    printf("No tiene.\n");
    printf("\nEjemplos\n");
    printf("./tp3_ej1\n\n");

}
