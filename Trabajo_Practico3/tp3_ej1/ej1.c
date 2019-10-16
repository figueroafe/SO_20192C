#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

pid_t pid, pid2, pid3, pid4, pid5, pid6, pid7, pid8, pid9, pid10;

int main(){
    pid = fork();
    if(pid == 0){ //soy hijo
        printf ("PID: %d PPID: %d Parentesco-Tipo: [hijo] - [normal]\n", getpid(), getppid());
        pid5 = fork(); //creo otro hijo
        if(pid5 == 0){ //soy nieto
            printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
            pid9 = fork(); //creo bisnieto
            if(pid9 == 0)
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
            else{ // soy el nieto
                pid10 = fork(); //creo bisnieto 2
            if(pid10 == 0)
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
            else //sigo siendo el nieto
                sleep(30); //duermo al nieto para crear a los 2 bisnietos zombies
            }
        }
        else{ //soy el hijo
            pid6 = fork(); //creo un nieto
            if(pid6 == 0){ // soy nieto
                printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
                pid7 = fork(); //creo bisnieto
                if(pid7 == 0){// soy bisnieto
                    sleep(2);
                    umask(0);
                    pid_t sed = setsid();
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                }
                else{ //soy nieto
                    pid8 = fork(); //creo bisnieto
                    if(pid8 == 0){ //soy bisnieto
                    sleep(2);
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                    }
                    else //soy nieto
                    exit(0);

                    //wait(NULL);
                    //wait(NULL);
                    }
            }
            else
            wait(NULL);
        }
    }
    else{ //soy padre
        printf ("PID: %d PPID: %d Parentesco-Tipo: [padre] - [normal]\n", getpid(), getppid());
        pid2 = fork(); //creo un hijo
        if(pid2 == 0){ //soy hijo
            printf ("PID: %d PPID: %d Parentesco-Tipo: [hijo] - [normal]\n", getpid(), getppid());
            pid3 = fork(); //creo un nieto
            if(pid3 == 0){ //soy nieto
                printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
                pid4 = fork(); //creo un bisnieto
                if(pid4 == 0){//soy bisnieto
                    sleep(2);
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());

                }
                else
                    exit(0);
                    //wait(NULL);
            }
            else //soy hijo
            wait(NULL);

        }
        else{
             //soy padre
             wait(NULL);
             wait(NULL);
             getchar();
        }
    }
    //https://www.busindre.com/crear_matar_y_entender_los_procesos_zombie
}
