package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"
	"text/template"

	"github.com/lithammer/dedent"
)

func getDSMList() []string {
        settingsGradle := "settings.gradle"
        marker := "include '"
        dsmList := []string{}

        file, err := os.Open(settingsGradle)
        if err != nil {
                fmt.Println(err)
                os.Exit(1)
        }
        defer file.Close()

        scanner := bufio.NewScanner(file)
        for scanner.Scan() {
                lineText := scanner.Text()
                lineSlice := strings.Split(lineText, "\n")
                for _, line := range lineSlice {
                        if strings.Contains(line, marker) {
                                dsmList = append(dsmList, line[9:len(line)-1])
                        }
                }
        }

        return dsmList
}


type DSM struct {
        Name string
}

func getTriggerSnippet(dsm string) string {
        dsmName := DSM{dsm}

        // TODO: (tranh) avoid empty first line
        triggerTemplate := `
                Build {{ .Name }}:
                  stage: Triggers
                  trigger:
                    include: {{ .Name }}/.gitlab-ci.yml
                    strategy: depend
                  rules:
                    - changes:
                        - **/*`

        // Removes common leading whitespace from multiline strings
        t, err := template.New("dsmTemplate").Parse(dedent.Dedent(triggerTemplate))
        if err != nil {
                fmt.Println(err)
                os.Exit(1)
        }

        // Create a buffer to write our result to.
        var templateOutputBuf bytes.Buffer
        err = t.Execute(&templateOutputBuf, dsmName)

        if err != nil {
                fmt.Println(err)
                os.Exit(1)
        }

        triggerText := templateOutputBuf.String()

        return triggerText
}

func genTriggerYaml() {
        triggerYaml := "triggers.yml"
        dsmList := getDSMList()

        for _, dsm := range dsmList {
                // Appending text to file
                f, err := os.OpenFile(triggerYaml, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
                if err != nil {
                        fmt.Println(err)
                        os.Exit(1)
                }
                defer f.Close()

                if _, err := f.WriteString(getTriggerSnippet(dsm) + "\n"); err != nil {
                        fmt.Println(err)
                        os.Exit(1)
                }
        }
}


func main() {
        genTriggerYaml()
}
