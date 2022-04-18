const fs = require('fs');
const nunjucks = require('nunjucks');

function getDSMList() {
  const settingsGradleFile = "settings.gradle";
  const dsmList = [];
  const marker = "include '";

  // TODO: use another method to throw an error if settings.gradle not found
  const lines = fs.readFileSync(settingsGradleFile, 'utf8').split('\n');
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes(marker)) {
      dsmList.push(lines[i].substring(9, lines[i].length - 1));
    }
  }

  return dsmList;
}

function getTriggerSnippet(dsm) {
  const renderedText = nunjucks.renderString(`Build {{ dsm }}:
  stage: Triggers
  trigger:
    include: {{ dsm }}/.gitlab-ci.yml
    strategy: depend
  rules:
    - changes:
        - "**/*"`, { dsm: dsm });

  return renderedText;

}

function genTriggerYaml() {
  const triggerYaml = "triggers.yml";
  const dsmList = getDSMList();

  for (let i = 0; i < dsmList.length; i++) {
    fs.appendFile(triggerYaml, getTriggerSnippet(dsmList[i]) + "\n\n", (err) => {
      if (err) throw err;
    });
  }
}

const main = () => {
  genTriggerYaml();
};

if (require.main === module) {
  main();
}
