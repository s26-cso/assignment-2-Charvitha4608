#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[10];
    int num1, num2;
 
    // loop runs until input ends 
    while (scanf("%s %d %d", op, &num1, &num2) == 3) {

        char libname[20];
        sprintf(libname, "./lib%s.so", op);

        // load library
        void *handle = dlopen(libname, RTLD_LAZY);

        // if library not found 
        if (handle == NULL) {
            fprintf(stderr,"cant load %s\n",libname);
            continue;
        }

        // pointer to function
        int (* func)(int , int);

        // get function address from library using op name
        *(void **)(&func)= dlsym(handle, op);

        if (func == NULL) {
            fprintf(stderr,"Can't find function %s\n", op);
            dlclose(handle); // to remove from memory
            continue;
        }
        int result = func(num1, num2);
        printf("%d\n", result);

        dlclose(handle);
    }
}
