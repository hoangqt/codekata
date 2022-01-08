#!/usr/bin/env bash

set -euo pipefail

readonly MAX_LINE_LENGTH=80

readonly tabs="\t+"
readonly comma_space=",[^ ]"
# readonly operator_space="([:alpha:](\+|\-|\*|\<|\>|\=)[:alpha:])|([:alpha:](\=\=|\<\=|\>\=)[:alpha:])"
readonly operator_space="*\=\=*"
readonly comment_line="^[:space:]*\/\*.*\*\/[:space:]*$"
readonly open_comment_space="\/\*[^ *\n]"
readonly close_comment_space="[^ *]\*\/"
readonly paren_curly_space="\)\{"
readonly c_plus_plus_comment="//"
readonly semi_space=";[^ \s]"

check_line() {
  local filename="$1"
  local line="$2"
  local n="$3"

  # Strip the trailing newline
  line="${line%$'\n'}"

  # TODO: fix this
  if [[ "$line" =~ $tabs ]]; then
    printf "File: %s, line %s: [TABS]:\n%s\n" "$filename" "$n" "$line"
  fi

  if [[ ${#line} -gt "$MAX_LINE_LENGTH" ]]; then
    printf "File: %s, line %s: [TOO LONG (%s CHARS)]:\n%s\n" "$filename" "$n" "${#line}", "$line"
  fi

  if [[ "$line" =~ $open_comment_space ]]; then
    printf "File: %s, line: %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s\n" "$filename" "$n" "$line"
  fi

  if [[ "$line" =~ $close_comment_space ]]; then
    printf "File: %s, line: %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s\n" "$filename" "$n" "$line"
  fi

  if [[ "$line" =~ $paren_curly_space ]]; then
    printf "File: %s, line: %d: [PUT SPACE BETWEEN ) AND {]:\n%s\n" "$filename" "$n" "$line"
  fi

  if [[ "$line" =~ $c_plus_plus_comment ]]; then
    printf "File: %s, line: %d: [DON'T USE C++ COMMENTS]:\n%s\n" "$filename" "$n" "$line"
  fi

  if [[ "$line" =~ $semi_space ]]; then
    printf "File: %s, line: %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s\n" "$filename" "$n" "$line"
  fi

  # TODO: fix this
  if [[ "$line" =~ $operator_space ]]; then
    if [[ ! "$line" =~ $comment_line ]]; then
      printf "File: %s, line: %d: [PUT SPACE AROUND OPERATORS]:\n%s\n" "$filename" "$n" "$line"
    fi
  fi

  if [[ "$line" =~ $comma_space ]]; then
    printf "File: %s, line: %d: [PUT SPACE AFTER COMMA]:\n%s\n" "$filename" "$n" "$line"
  fi
}

check_file() {
  local i=0
  local filename="$1"

  # Read file line by line
  while read -r line; do
    i=$((i + 1))
    check_line "$filename" "$line" "$i"
  done < "$1"
}

usage() {
  cat <<EOF
  usage: c_style_check filename1 [filename2 ...]
EOF
}

main() {
  test $# -lt 1 && usage && exit 1

  check_file "$@"
}

main "$@"
