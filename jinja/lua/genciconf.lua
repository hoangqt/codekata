local template = require "resty.template"

function getDSMList()
    local settingsGradleFile = "settings.gradle"
    local dsmList = {}
    local marker = "include '"

    local file, err = io.open(settingsGradleFile, "r")
    if not file then error("File not found: " .. settingsGradleFile) end

    for line in file:lines() do
        if string.find(line, marker) then
            table.insert(dsmList, string.sub(line, 10, string.len(line) - 1))
        end
    end
    file:close()

    return dsmList
end

function getTriggerSnippet(dsm)
    local renderedText = template.process([[
Build {{ dsm }}:
  stage: Triggers
  trigger:
    include: {{ dsm }}/.gitlab-ci.yml
    strategy: depend
  rules:
    - changes:
        - "**/*"
]], {dsm = dsm})

    return renderedText

end

function genTriggerYaml()
    local triggerYaml = "triggers.yml"
    local dsmList = getDSMList()
    for _, dsm in ipairs(dsmList) do
        local file = io.open(triggerYaml, "a")
        do
            file:write(getTriggerSnippet(dsm))
            file:write("\n")
            file:close()
        end
    end
end

function main() genTriggerYaml() end

main()
