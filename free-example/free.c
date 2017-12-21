#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
  char* msg = malloc(sizeof(char)*6);
  strcpy(msg, "Hello");
  printf("%s\n", msg);
  free(msg);
  printf("success\n");
}
