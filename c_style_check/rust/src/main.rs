use regex::Regex;
use std::env;
use lazy_static::lazy_static;
use std::fs::File;
use std::io::{self, BufRead};

lazy_static! {
    static ref TABS: Regex = Regex::new(r"\t+").unwrap();
    static ref COMMA_SPACE: Regex = Regex::new(r",[^ ]").unwrap();
    // < AND > don't need to escape
    static ref OPERATOR_SPACE: Regex = Regex::new(r"(\w(\+|\-|\*|<|>|\=)\w)|(\w(\=\=|<\=|>\=)\w)").unwrap();
    static ref COMMENT_LINE: Regex = Regex::new(r"^\s*\/\*.*\*\/\s*$").unwrap();
    static ref OPEN_COMMENT_SPACE: Regex = Regex::new(r"\/\*[^ *\n]").unwrap();
    static ref CLOSE_COMMENT_SPACE: Regex = Regex::new(r"[^ *]\*\/").unwrap();
    static ref PAREN_CURLY_SPACE: Regex = Regex::new(r"\)\{").unwrap();
    static ref C_PLUS_PLUS_COMMENT: Regex = Regex::new(r"\/\/").unwrap();
    static ref SEMI_SPACE: Regex = Regex::new(r";[^ \s]").unwrap();
}

fn check_file(filename: &str) {
    if let Ok(file) = File::open(filename) {
        let reader = io::BufReader::new(file);
        let mut line_number = 1;

        for line in reader.lines() {
            if let Ok(line) = line {
                check_line(filename, &line, line_number);
                line_number += 1;
            }
        }
    } else {
        eprintln!("Failed to open file: {}", filename);
        std::process::exit(1);
    }
}

fn check_line(filename: &str, line: &str, line_number: usize) {
    let line = line.trim_end_matches('\n');

    if TABS.is_match(line) {
        println!("File: {}, line: {}: [TABS]:\n{}", filename, line_number, line);
    }

    if line.len() > 80 {
        println!("File: {}, line: {}: [TOO LONG ({} CHARS)]:\n{}", filename, line_number, line.len(), line);
    }

    if OPEN_COMMENT_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE AFTER OPEN COMMENT]:\n{}", filename, line_number, line);
    }

    if CLOSE_COMMENT_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE AFTER CLOSE COMMENT]:\n{}", filename, line_number, line);
    }

    if PAREN_CURLY_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE BETWEEN ) AND {{]:\n{}", filename, line_number, line);
    }

    if C_PLUS_PLUS_COMMENT.is_match(line) {
        println!("File: {}, line: {}: [DON'T USE C++ COMMENTS]:\n{}", filename, line_number, line);
    }

    if SEMI_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n{}", filename, line_number, line);
    }

    if OPERATOR_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE AROUND OPERATORS]:\n{}", filename, line_number, line);
    }

    if COMMA_SPACE.is_match(line) {
        println!("File: {}, line: {}: [PUT SPACE AFTER COMMA]:\n{}", filename, line_number, line);
    }
}

fn main() {
    let usage = "usage: c_style_check filename1 [filename2 ...]";

    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        println!("{}", usage);
        std::process::exit(0);
    }

    for filename in &args[1..] {
        check_file(filename);
    }
}
