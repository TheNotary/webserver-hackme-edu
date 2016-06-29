// hello_c.c
// build:  gcc -Wall hello_c.c -o hello_c

// RevEng Platform: https://www.onlinedisassembler.com
// View Binary in vim:  :%!xxd
// dissasemble:  TODO objdump -D -b binary -m i386 -M intel hello_asm


/* The following is the size of a buffer to contain any error messages
   encountered when the regular expression is compiled. */

#define MAX_ERROR_MSG 0x1000

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
  char queryString[] = "text=correct%20me";
  char textToCorrect[256];


  char * token;

  envVal = getenv(envKey);

  printf("%s", header);
  printf("%s\n", body);

  // printf("%s\n", envVal);
  // Learn the outputs from strtok...

  // Iterate over the query string to collect the textToCorrect value
  token = strtok(queryString, delimiters);
  while (token != NULL)
  {
    if (strcmp(token, "text") == 0) {
      printf("%s ", "We got the key of text and it's value is...");

      // Copy the value of the text key to a variable
      token = strtok(NULL, delimiters);
      strncpy(textToCorrect, token, 255);

      printf("%s\n", textToCorrect);
      break;
    }

    token = strtok(NULL, delimiters);
  }

  // perform the operations to correct the text....

  regex_t r;
  const char * regex_text;
  const char * find_text;
  regex_text = "([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)";
  find_text = "This 1 is nice 2 so 33 for 4254";

  compile_regex(& r, regex_text);
  match_regex(& r, find_text);
  regfree (& r);


  return 0;
}





/*
  Compile the regular expression described by "regex_text" into "r".
*/
static int compile_regex(regex_t * r, const char * regex_text)
{
  int status = regcomp(r, regex_text, REG_EXTENDED|REG_NEWLINE);
  if (status != 0) {
    char error_message[MAX_ERROR_MSG];
    regerror(status, r, error_message, MAX_ERROR_MSG);
    printf("Regex error compiling '%s': %s\n",
             regex_text, error_message);
    return 1;
  }
  return 0;
}


/*
  Match the string in "to_match" against the compiled regular
  expression in "r".
*/
static int match_regex (regex_t * r, const char * to_match)
{
    /* "P" is a pointer into the string which points to the end of the
       previous match. */
    const char * p = to_match;
    /* "N_matches" is the maximum number of matches allowed. */
    const int n_matches = 10;
    /* "M" contains the matches found. */
    regmatch_t m[n_matches];

    while (1) {
        int i = 0;
        int nomatch = regexec (r, p, n_matches, m, 0);
        if (nomatch) {
            printf ("No more matches.\n");
            return nomatch;
        }
        for (i = 0; i < n_matches; i++) {
            int start;
            int finish;
            if (m[i].rm_so == -1) {
                break;
            }
            start = m[i].rm_so + (p - to_match);
            finish = m[i].rm_eo + (p - to_match);
            if (i == 0) {
                printf ("$& is ");
            }
            else {
                printf ("$%d is ", i);
            }
            printf ("'%.*s' (bytes %d:%d)\n", (finish - start),
                    to_match + start, start, finish);
        }
        p += m[0].rm_eo;
    }
    return 0;
}
