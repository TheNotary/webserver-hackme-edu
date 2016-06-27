// hello_c.c
// build:  gcc -Wall hello_c.c -o hello_c

// RevEng Platform: https://www.onlinedisassembler.com
// View Binary in vim:  :%!xxd
// dissasemble:  TODO objdump -D -b binary -m i386 -M intel hello_asm
#include <stdio.h>
int main()
{
  char header[] = "Content-type: text/plain\n\n";
  char body[] = "Hello from c!";
  //char envKey[] = "PATH";
  //char envVal[5]; // this is a pointer though...

  // envVal = getenv(envKey);

  printf("%s", header);
  printf("%s\n", body);

  // printf("%s\n", getenv(envKey));
  return 0;
}
