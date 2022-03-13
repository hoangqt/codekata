# codekata

A simple style check script in different programming languages.

## Summary

This is an exercise to fresh programming knowledge from the past and learn new
ones. I don't have a hard list to target and may stop at some point. The goal
is to enjoy the process.

### Regex to find string

Use standard library where possible. Otherwise, use 3rd party dependency. The
meat of the regex is to look for partial match/contains the string from regex.

### Observations

CPP/Java use similar syntax. In cpp, std::regex_search to perform partial match
instead of using std::regex_match where it tries to match entire searched text.

golang/Javascript/Ruby are similar. These are the easiest to implement.

C is quite unique on its own.

Bash regex is weird.

Lua requires a 3rd party library.

Julia is similar to Lua in syntax.
