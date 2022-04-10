package genciconf;

import com.hubspot.jinjava.Jinjava;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class App {
    public String getGreeting() {
        return "rootProject.name = 'genciconf'";
    }

    public static List<String> getDSMList() {
        String settingsGradleFile = "settings.gradle";
        String marker = "include '";
        List<String> dsmList = new ArrayList<>();

        try {
            BufferedReader in = new BufferedReader(new FileReader(settingsGradleFile));
            String line;
            while ((line = in.readLine()) != null) {
                if (line.contains(marker)) {
                    dsmList.add(line.substring(9, line.length() - 1));
                }
            }
            in.close();
        } catch (IOException e) {
            System.out.println("Error reading file " + settingsGradleFile);
        }

        return dsmList;
    }

    public static String getTriggerSnippet(String dsm) {
        Jinjava jinjava = new Jinjava();
        Map<String, String> context = new HashMap<>();
        context.put("dsm", dsm);
        String template = ""
            .concat("Build {{ dsm }}:\n")
            .concat("  stage: Triggers\n")
            .concat("  trigger:\n")
            .concat("    include: {{ dsm }}/.gitlab-ci.yml\n")
            .concat("    strategy: depend\n")
            .concat("  rules:\n")
            .concat("    - changes:\n")
            .concat("        - **/*\n");

        String triggerText = jinjava.render(template, context);

        return triggerText;
    }

    public static void main(String[] args) {
        String triggerYaml = "triggers.yml";

        for (String dsm : getDSMList()) {
            try {
                // Append a string to existing file
                BufferedWriter out = new BufferedWriter(new FileWriter(triggerYaml, true));
                out.write(getTriggerSnippet(dsm) + "\n");
                out.close();
            } catch (IOException e) {
                System.out.println("Error writing file " + triggerYaml);
            }
        }
    }
}
