// hello_c.c
// build:  gcc -Wall hello_c.c -o hello_c

// RevEng Platform: https://www.onlinedisassembler.com
// View Binary in vim:  :%!xxd
// dissasemble:  TODO objdump -D -b binary -m i386 -M intel hello_asm
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>   
int main()
{
  char header[] = "Content-type: text/plain\n\n";
  char body[] = "Hello from c!";
  char envKey[] = "QUERY_STRING";
  char * envVal;
  char delimiters[] = "=&";
  char mockString[] = "text=correct%20me";
  char textToCorrect[80];
  char buffer[80];
  strcpy(buffer, mockString);

  char * token;

  envVal = getenv(envKey);

  printf("%s", header);
  printf("%s\n", body);

  // printf("%s\n", envVal);
  // Learn the outputs from strtok...

  // Iterate over the query string to collect the textToCorrect value
  token = strtok(buffer, delimiters);
  while (token != NULL)
  {
    if (strcmp(token, "text") == 0) {
      printf("%s ", "We got the key of text and it's value is...");

      // Copy the value of the text key to a variable
      token = strtok(NULL, delimiters);
      strcpy(textToCorrect, token);

      printf("%s\n", textToCorrect);
      break;
    }

    token = strtok(NULL, delimiters);
  }

  // perform the operations to correct the text....




  return 0;
}
