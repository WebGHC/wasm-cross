#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  printf("Hello, World!\n");
  sleep(2);
  volatile int *x;
  for (int i = 0; i < 100; ++i) {
    x = (int *) malloc(9 * sizeof(int));
    printf("%d\n", x[0]);
  }
  printf("Hello, World2!\n");
  return 0;
}
