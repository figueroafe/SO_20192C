#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

pid_t pid, pid2, pid3, pid4, pid5, pid6, pid7, pid8, pid9, pid10;
//int padre = 0;
void crearHijos();
void crearDemonio();

int main(){

    crearHijos();
    getchar();

    printf("Proceso Finalizado!\n"); 
}

void crearHijos(){
        pid = fork();
    if(pid == 0)
    { //soy hijo
        printf ("PID: %d PPID: %d Parentesco-Tipo: [hijo] - [normal]\n", getpid(), getppid());
        pid5 = fork(); //creo un nieto izq
        if(pid5 == 0){ //soy nieto
            printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
            pid9 = fork(); //creo bisnieto
            if(pid9 == 0){
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
		exit(0);}
            else{ // soy el nieto
                pid10 = fork(); //creo bisnieto 2
            if(pid10 == 0){
                printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [zombie]\n", getpid(), getppid());
		exit(0);}
            else //sigo siendo el nieto
                sleep(30); //duermo al nieto para crear a los 2 bisnietos zombies
		waitpid(pid9, NULL, 0);
	    	waitpid(pid10, NULL, 0);
		
            }
        }
        else{ //soy el hijo
            pid6 = fork(); //creo un nieto por der
            if(pid6 == 0){ // soy nieto
                printf ("PID: %d PPID: %d Parentesco-Tipo: [nieto] - [normal]\n", getpid(), getppid());
                pid7 = fork(); //creo bisnieto
                if(pid7 == 0){// soy bisnieto
                  //  sleep(1);
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
		    crearDemonio();
                }
                else{ //soy nieto
                    pid8 = fork(); //creo bisnieto
                    if(pid8 == 0){ //soy bisnieto
                //    sleep(1);
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                    crearDemonio();
                    }
                    else //soy nieto                 
                    waitpid(pid7, NULL, 0);
                    waitpid(pid8, NULL, 0);
                    }
            }
            //else{
		//exit(0);
         //	}
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
                //    sleep(2);
                    printf ("PID: %d PPID: %d Parentesco-Tipo: [bisnieto] - [demonio]\n", getpid(), getppid());
                    crearDemonio();
                }
                else{ //Espero al bisnieto que termine.
		    waitpid(pid4, NULL, 0);
                    }        
            }
            else //soy hijo
            waitpid(pid3, NULL, 0);

        }
        else{
             //soy padre
             waitpid(pid, NULL, 0);
             waitpid(pid2, NULL, 0);
        }
    }
}

void crearDemonio(){
 while(1){}   
}
