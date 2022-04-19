#include <fstream>
#include <inja/inja.hpp>
#include <iostream>
#include <nlohmann/json.hpp>
#include <stdlib.h>
#include <string>
#include <vector>

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
  while (std::getline(file, line)) {
    if (line.find(marker) != std::string::npos) {
      // TODO: I don't know why line.length() - 10 works here :-/
      dsmList.push_back(line.substr(9, line.length() - 10));
    }
  }
  file.close();

  return dsmList;
}

std::string getTriggerSnippet(std::string dsm) {
  nlohmann::json j;

  j["dsm"] = dsm;

  std::string templateStr = "Build {{ dsm }}:\n"
                            "  stage: Triggers\n"
                            "  trigger:\n"
                            "    include: {{ dsm }}/.gitlab-ci.yml\n"
                            "    strategy: depend\n"
                            "  rules:\n"
                            "    - changes:\n"
                            "        - \"**/*\"\n";

  std::string renderedText = inja::render(templateStr, j);

  return renderedText;
}

void genTriggerYaml(void) {
  std::string triggerYaml = "triggers.yml";
  std::vector<std::string> dsmList = getDSMList();

  std::fstream file;
  // Opens file for appending
  file.open(triggerYaml, std::ios_base::app);
  if (!file.is_open()) {
    std::cerr << "Unable to open: " << triggerYaml << std::endl;
    exit(255);
  }

  for (int i = 0; i < dsmList.size(); i++) {
    file << getTriggerSnippet(dsmList[i]) << std::endl;
  }
  file.close();
}

int main(int argc, char **argv) {
  genTriggerYaml();

  return 0;
}
