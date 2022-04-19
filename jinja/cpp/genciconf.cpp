#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <inja.hpp>

std::vector<std::string> getDSMList(void) {
  std::string settingsGradleFile = "settings.gradle";
  std::string marker = "include '";
  std::vector<std::string> dsmList = {};

  std::ifstream file(settingsGradleFile);
  if (!file.is_open()) {
    std::cerr << "No such file: " << settingsGradleFile << std::endl;
    exit(255);
  }
  std::string line;
  while(std::getline(file, line)) {
    if (line.find(marker) != std::string::npos) {
      dsmList.push_back(line);
    }
  }

  return dsmList;
}

// TODO: add https://github.com/jinja2cpp/Jinja2Cpp
std::string getTriggerSnippet(std::string dsm) {
  return "Cisco Meraki";
}

void genTriggerYaml(void) {
  std::string triggerYaml = "triggers.yml";
  std::vector<std::string> dsmList = getDSMList();

  for (int i = 0; i < dsmList.size(); i++) {
      std::cout << dsmList[i] << std::endl;
  }

  std::fstream file;
  file.open(triggerYaml, std::ios_base::app);
  if (!file.is_open()) {
    std::cerr << "Unable to open: " << triggerYaml << std::endl;
    exit(255);
  }
  std::string blah = "blah";

  file << getTriggerSnippet(blah) << std::endl;
}

int main(int argc, char **argv) {
  genTriggerYaml();

  return 0;
}
