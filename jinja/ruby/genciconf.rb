#!/usr/bin/env ruby

require 'mustache'

def get_dsm_list
  settings_gradle_file = 'settings.gradle'
  marker = "include '"
  dsm_list = []
  file = File.open(settings_gradle_file, 'r')
  file.each_line do |line|
    if line.include?(marker)
      dsm_list.append(line.slice(9, line.length - 11))
    end
  end

  dsm_list
end

def get_trigger_snippet(dsm)
  trigger_template = <<-HEREDOC
Build {{ dsm }}:
  stage: Triggers
  trigger:
    include: {{ dsm }}/.gitlab-ci.yml
    strategy: depend
  rules:
    - changes:
        - "**/*"
  HEREDOC

  Mustache.render(trigger_template, dsm: dsm)
end

def gen_trigger_yaml
  trigger_yaml = 'triggers.yml'
  dsm_list = get_dsm_list
  dsm_list.each do |dsm|
    File.open(trigger_yaml, 'a') do |file|
      file.puts(get_trigger_snippet(dsm))
      file.puts("\n")
    end
  end
end

gen_trigger_yaml
