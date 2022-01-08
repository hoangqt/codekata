#!/usr/bin/env node

const fs = require('fs');

const MAX_LINE_LENGTH = 80;

const tabs = /\t+/;
const commaSpace = /,[^ ]/;
const operatorSpace = /(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)/;
const commentLine = /^\s*\/\*.*\*\/\s*$/;
const openCommentSpace = /\/\*[^ *\n]/;
const closeCommentSpace = /[^ *]\*\//;
const parenCurlySpace = /\)\{/;
const cppComment = /\/\//;
const semiSpace = /;[^ \s]/;

function checkLine(filename, line, n) {
  if (line.match(tabs)) {
    console.log(`File: ${filename}, line ${n}: [TABS]:\n${line}`);
  }

  if (line.length > MAX_LINE_LENGTH) {
    console.log(
      `File: ${filename}, line ${n}: [TOO LONG (${line.length} CHARS)]:\n${line}`
    );
  }

  if (line.match(cppComment)) {
    console.log(
      `File: ${filename}, line ${n}: [DON'T USE C++ COMMENTS]:\n${line}`
    );
  }

  if (line.match(openCommentSpace)) {
    console.log(
      `File: ${filename}, line ${n}: [PUT SPACE AFTER OPEN COMMENT]:\n${line}`
    );
  }

  if (line.match(closeCommentSpace)) {
    console.log(
      `File: ${filename}, line ${n}: [PUT SPACE AFTER CLOSE COMMENT]:\n${line}`
    );
  }

  if (line.match(parenCurlySpace)) {
    console.log(
      `File: ${filename}, line ${n}: [PUT SPACE BETWEEN ) AND {]:\n${line}`
    );
  }

  if (line.match(commaSpace)) {
    console.log(
      `File: ${filename}, line ${n}: [PUT SPACE AFTER COMMA]:\n${line}`
    );
  }

  if (line.match(semiSpace)) {
    console.log(
      `File: ${filename}, line ${n}: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n${line}`
    );
  }

  if (line.match(operatorSpace)) {
    if (!line.match(commentLine)) {
      console.log(
        `File: ${filename}, line ${n}: [PUT SPACE AROUND OPERATORS]:\n${line}`
      );
    }
  }
}

function checkFile(filename) {
  const lines = fs.readFileSync(filename, "utf8").split("\n");
  for (let i = 0; i < lines.length; i++) {
    checkLine(filename, lines[i], i + 1); // Start on line 1.
  }
}

function usage() {
  console.log("usage: c_style_check filename1 [filename2 ...]");
  process.exit(1);
}

const main = () => {
  // File param starts at index 2
  // node script.js filename1 [filename2 ...]
  const paramIndex = 2;
  if (process.argv.length < paramIndex) {
    usage();
  }

  for (let i = paramIndex; i < process.argv.length; i++) {
    checkFile(process.argv[i]);
  }
};

if (require.main === module) {
  main();
}
