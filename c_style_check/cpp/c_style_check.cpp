#include <fstream>
#include <iostream>
#include <regex>
#include <string>

#define PROGRAM_NAME "c_style_check"
#define MAX_LINE_LENGTH 80

auto const tabs = std::regex("\\t+");
auto const c_plus_plus_comment = std::regex("\\/\\/");
auto const open_comment_space = std::regex("\\/\\*[^ *\n]");
auto const close_comment_space = std::regex("[^ *]\\*\\/");
auto const paren_curly_space = std::regex("\\)\\{");
auto const semi_space = std::regex(";[^ \\s]");
auto const operator_space = std::regex(
    "(\\w(\\+|\\-|\\*|\\<|\\>|\\=)\\w)|(\\w(\\=\\=|\\<\\=|\\>\\=)\\w)");
auto const comment_line = std::regex("^\\s*\\/\\*.*\\*\\/\\s*$");
auto const comma_space = std::regex(",[^ ]");

void checkLine(const char *filename, std::string line, int n) {
  // Strip the terminal newline
  line.erase(line.find_last_not_of("\n\r") + 1);

  if (std::regex_match(line, tabs)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [TABS]:" << std::endl
              << line << std::endl;
  }

  if (line.length() > MAX_LINE_LENGTH) {
    std::cout << "File: " << filename << ", line " << n << ": [TOO LONG ("
              << line.length() << " CHARS)]" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, c_plus_plus_comment)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [DON'T USE C++ COMMENTS]:" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, open_comment_space)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [PUT SPACE AFTER OPEN COMMENT]:" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, close_comment_space)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [PUT SPACE AFTER CLOSE COMMENT]:" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, paren_curly_space)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [PUT SPACE BETWEEN ) AND {]:" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, semi_space)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [PUT SPACE/NEWLINE AFTER SEMICOLON]:" << std::endl
              << line << std::endl;
  }

  if (std::regex_search(line, operator_space)) {
    if (!std::regex_search(line, comment_line)) {
      std::cout << "File: " << filename << ", line " << n
                << ": [PUT SPACE AROUND OPERATORS]:" << std::endl
                << line << std::endl;
    }
  }

  if (std::regex_search(line, comma_space)) {
    std::cout << "File: " << filename << ", line " << n
              << ": [PUT SPACE AFTER COMMA]:" << std::endl
              << line << std::endl;
  }
}

// Read file line by line
void checkFile(const char *filename) {
  std::ifstream file(filename);
  if (!file.is_open()) {
    std::cerr << "No such file or directory: " << filename << std::endl;
    return;
  }

  int lineNumber = 0;
  std::string line;
  while (std::getline(file, line)) {
    checkLine(filename, line, lineNumber + 1);
    lineNumber++;
  }
  file.close();
}

int main(int argc, char **argv) {
  if (argc < 2) {
    std::cerr << "usage: " << PROGRAM_NAME << " filename1 [filename2 ...]"
              << std::endl;
    return 1;
  }

  for (int i = 1; i < argc; i++) {
    checkFile(argv[i]);
  }
  return 0;
}
