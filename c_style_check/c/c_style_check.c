#include <regex.h>
#include <stdio.h>
#include <string.h>

#define PROGRAM_NAME "c_style_check"
#define MAX_LINE_LENGTH 80
#define DEBUG 0

/* Disable gcc/cc warnings */
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wreturn-stack-address"
#pragma GCC diagnostic ignored "-Wunknown-escape-sequence"
#pragma GCC diagnostic ignored "-Wpedantic"

void checkLine(char *filename, char *line, int n) {
  int return_value;
  regex_t regex;

  /* Remove trailing newline */
  line[strlen(line) - 1] = '\0';

  regcomp(&regex, "\t+", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line: %d: [TABS]:\n%s\n", filename, n, line);
    /* Free memory allocated by regcomp */
    regfree(&regex);
  }

  if (strlen(line) > MAX_LINE_LENGTH) {
    printf("File: %s, line: %d: [TOO LONG (%lu CHARS)]:\n%s\n", filename, n,
           strlen(line), line);
  }

  regcomp(&regex, ",[^ ]", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value==0) {
    printf("File: %s, line: %d: [PUT SPACE AFTER COMMA]:\n%s\n", filename, n,
           line);
    regfree(&regex);
  }

  /* TODO: fix this */
  regcomp(&regex, "(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line: %d: [PUT SPACE AROUND OPERATORS]:\n%s\n", filename,
           n, line);
    regfree(&regex);
  }

  /*It should trigger PUT SPACE AFTER OPEN COMMENT */
  regcomp(&regex, "\\/\\*[^ *]", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s\n", filename,
           n, line);
    regfree(&regex);
  }

  /* It should trigger PUT SPACE AFTER OPEN COMMENT*/
  regcomp(&regex, "[^ *]\\*\\/", 0); /* Escape meta character in C is \\ */
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line: %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s\n",
           filename, n, line);
    regfree(&regex);
  }

  regcomp(&regex, "\\)\\{", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  /* It should trigger PUT SPACE BETWEEN ) AND { */
  if (return_value == 0){
    printf("File: %s, line: %d: [PUT SPACE BETWEEN ) AND {]:\n%s\n", filename,
           n, line);
    regfree(&regex);
  }

  // It should trigger DON\'T USE C++ COMMENTS
  regcomp(&regex, "\/\/", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line: %d: [DON\'T USE C++ COMMENTS]:\n%s\n", filename, n,
           line);
    regfree(&regex);
  }

  regcomp(&regex, ";[^ \s]", 0);
  return_value = regexec(&regex, line, 0, NULL, 0);
  if (return_value == 0) {
    printf("File: %s, line: %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s\n",
           filename, n, line);regfree(&regex);
  }
}

void checkFile(char *filename) {
  FILE *file = fopen(filename, "r");
  if (file == NULL) {
    printf("%s: No such file or directory\n", filename);
    return;
  }

  /* Maximum characters per line */
  char line[160];
  int lineNumber = 0;

  /* Read line by line */
  while (fgets(line, sizeof(line), file) != NULL) {
    checkLine(filename, line, lineNumber + 1); /* Start on line 1. */
    lineNumber++;
  }
  fclose(file);
}

int main(int argc, char **argv) {
  char *usage = "usage: %s filename1 [filename2 ...]\n";

  if (argc < 2) {
    printf(usage, PROGRAM_NAME);
    return 1;
  }

  for (int i = 1; i < argc; i++) {
    checkFile(argv[i]);
  }
  return 0;
}
