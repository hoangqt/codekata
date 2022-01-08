import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class CStyleCheck {
  public static final int MAX_LINE_LENGTH = 80;

  public static final Pattern tabs = Pattern.compile("\\t+");
  public static final Pattern c_plus_plus_comment = Pattern.compile("\\/\\/");
  public static final Pattern open_comment_space = Pattern.compile("\\/\\*[^ *\n]");
  public static final Pattern close_comment_space = Pattern.compile("[^ *]\\*\\/");
  public static final Pattern paren_curly_space = Pattern.compile("\\)\\{");
  public static final Pattern semi_space = Pattern.compile(";[^ \\s]");
  public static final Pattern operator_space = Pattern.compile("(\\w(\\+|\\-|\\*|\\<|\\>|\\=)\\w)|(\\w(\\=\\=|\\<\\=|\\>\\=)\\w)");
  public static final Pattern comment_line = Pattern.compile("^\\s*\\/\\*.*\\*\\/\\s*$");
  public static final Pattern comma_space = Pattern.compile(",[^ ]");

  public static Matcher m = null;

  public static void checkLine(String filename, String line, int n) {
    if (line.length() > MAX_LINE_LENGTH) {
      System.out.println(String.format("File: %s, line %d: [TOO LONG (%d CHARS)]:\n%s", filename, n, line.length(), line));
    }

    m = tabs.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [TABS]:\n%s", filename, n, line));
      m = null;
    }

    m = c_plus_plus_comment.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [DON'T USE C++ COMMENTS]:\n%s", filename, n, line));
      m = null;
    }

    m = open_comment_space.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s", filename, n, line));
      m = null;
    }

    m = close_comment_space.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s", filename, n, line));
      m = null;
    }

    m = paren_curly_space.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [PUT SPACE BETWEEN ) AND {]:\n%s", filename, n, line));
      m = null;
    }

    m = semi_space.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s", filename, n, line));
      m = null;
    }

    m = operator_space.matcher(line);
    if (m.find()) {
      m = comment_line.matcher(line);
      if (!m.find()) {
        System.out.println(String.format("File: %s, line %d: [PUT SPACE AROUND OPERATORS]:\n%s", filename, n, line));
        m = null;
      }
    }

    m = comma_space.matcher(line);
    if (m.find()) {
      System.out.println(String.format("File: %s, line %d: [PUT SPACE AFTER COMMA]:\n%s", filename, n, line));
      m = null;
    }
  }

  public static void usage() {
    System.out.println("usage: c_style_check filename1 [filename2 ...]");
    System.exit(1);
  }

  public static void checkFile(String filename) {
    try {
      BufferedReader in = new BufferedReader(new FileReader(filename));
      String line;
      int i = 0;
      while ((line = in.readLine()) != null) { // Line by line w/o newline char
        i++; // Start on line 1.
        checkLine(filename, line, i);
      }
      in.close();
    } catch (IOException e) {
      System.out.println("Error reading file " + filename);
    }
  }

  public static void main(String[] args) {
    if (args.length < 1) {
      usage();
    }

    for (int i = 0; i < args.length; i++) {
      checkFile(args[i]);
    }
  }
}
