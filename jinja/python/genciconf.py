#!/usr/bin/env python

from textwrap import dedent
from typing import List

import fire
from jinja2 import Template


class GitlabCIGenerator(object):
    def _get_dsm_list(self) -> List[str]:
        settings_gradle_file = "settings.gradle"
        marker = "include '"
        dsm_list = []
        with open(settings_gradle_file, "r") as f:
            file_content = f.read()
            for line in file_content.splitlines():
                if marker in line:
                    # Extract the DSM name from include 'aruba-mobility'
                    dsm_list.append(line[9:-1])

        return dsm_list


    def _get_trigger_snippet(self, dsm) -> str:
        # Avoid empty first line with \
        trigger_template = dedent("""\
            Build {{ dsm }}:
              stage: Triggers
              trigger:
                include: {{ dsm }}/.gitlab-ci.yml
                strategy: depend
              rules:
                - changes:
                    - **/*
            """)

        template = Template(trigger_template)
        trigger_text = template.render(dsm=dsm)

        return trigger_text


    def gen_trigger_yaml(self) -> None:
        trigger_yaml =  "triggers.yml"

        dsm_list = self._get_dsm_list()
        for dsm in dsm_list:
            with open(trigger_yaml, "a") as f:
                f.write(self._get_trigger_snippet(dsm))
                f.write("\n\n")


if __name__ == "__main__":
    fire.Fire(GitlabCIGenerator)
