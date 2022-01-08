package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

const MAX_LINE_LENGTH = 80

var tabs = regexp.MustCompile(`\t+`)
var comma_space = regexp.MustCompile(`,[^ ]`)
var operator_space = regexp.MustCompile(`(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)`)
var comment_line = regexp.MustCompile(`^\s*\/\*.*\*\/\s*$`)
var open_comment_space = regexp.MustCompile(`\/\*[^ *\n]`)
var close_comment_space = regexp.MustCompile(`[^ *]\*\/`)
var paren_curly_space = regexp.MustCompile(`\)\{`)
var c_plus_plus_comment = regexp.MustCompile(`\/\/`)
var semi_space = regexp.MustCompile(`;[^ \s]`)

func checkLine(filename string, line string, n int) {
	// Strip the terminal newline.
	line = strings.TrimRight(line, "\n")

	if tabs.MatchString(line) {
		fmt.Printf("File: %s, line %d: [TABS]:\n%s", filename, n, line)
	}

	if len(line) > MAX_LINE_LENGTH {
		fmt.Printf("File: %s, line %d: [TOO LONG (%d CHARS)]:\n%s\n", filename, n, len(line), line)
	}

	if open_comment_space.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s\n", filename, n, line)
	}

	if close_comment_space.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s\n", filename, n, line)
	}

	if paren_curly_space.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [PUT SPACE BETWEEN ) AND {]:\n%s\n", filename, n, line)
	}

	if c_plus_plus_comment.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [DON'T USE C++ COMMENTS]:\n%s\n", filename, n, line)
	}

	if semi_space.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s\n", filename, n, line)
	}

	if operator_space.MatchString(line) {
		if !comment_line.MatchString(line) {
			fmt.Printf("File: %s, line: %d: [PUT SPACE AROUND OPERATORS]:\n%s\n", filename, n, line)
		}
	}

	if comma_space.MatchString(line) {
		fmt.Printf("File: %s, line: %d: [PUT SPACE AFTER COMMA]:\n%s\n", filename, n, line)
	}
}

func checkFile(filename string) {
	file, err := os.Open(filename)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer file.Close()

	i := 0
	// Read file line by line.
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		i++ // Start on line 1.
		line := scanner.Text()
		checkLine(filename, line, i)
	}
}

func main() {
	usage := `usage: c_style_check filename1 [filename2 ...]`

	if len(os.Args) < 2 {
		fmt.Println(usage)
		os.Exit(0)
	}

	for _, filename := range os.Args[1:] {
		checkFile(filename)
	}
}
