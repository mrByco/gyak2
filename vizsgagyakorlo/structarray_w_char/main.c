#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Runner {
    char* name;
    int result;
} Runner;

typedef struct Runners {
    int length;
    Runner* runners;
} Runners;

Runners* readRunnerArray();
Runner* readRunner();

int main() {
    Runners* runners = readRunnerArray();
    return 0;
}

Runners* readRunnerArray() {
    int length = 0;
    Runner* runners = malloc(0);
    Runner* newRunner = readRunner();
    while (newRunner != NULL) {
        if (newRunner != NULL){
            length++;
            realloc(runners, length);
            runners[length - 1] = *newRunner;
            }
        free(newRunner);
        newRunner = readRunner();
        }
    printf("gg");
    Runners* runners_strct = malloc(sizeof(Runners));
    runners_strct->length = length;
    runners_strct->runners = runners;
    return runners_strct;
}

Runner* readRunner() {
    Runner* runner = malloc(sizeof(Runner));
    char c[1024];
    int d;
    scanf("%s,%d", &c, &d);
    printf("\n");

    char* runner_name = malloc(strlen(c));
    strcpy(runner_name, c);
    runner->name = c;
    runner->result = d;

    printf("%s %d\n", runner->name, runner->result);

    return runner;
}

