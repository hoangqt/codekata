#!usr/bin/env lua-5.4

local MAX_LINE_LENGTH <const> = 80
local tabs <const> = '\t+'
local c_plus_plus_comment<const> = '%/%/'
local open_comment_space <const> = '%/%*[^ *\\n]'
local close_comment_space <const> = '[^ *]%*%/'
local paren_curly_space <const> = '%)%{'
local comma_space <const> = ',[^ ]'
local semi_space <const> = ';[^ \\s]'

-- Limitations of Lua patterns not supporting () with |. See the following
-- http://lua-users.org/wiki/PatternsTutorial
--
-- luarocks install lrexlib-pcre https://github.com/rrthomas/lrexlib
local rex = require("rex_pcre")
-- Need to break the original pattern into two parts :-/
-- Pattern: '(\\w(\\+|\\-|\\*|\\<|\\>|\\=)\\w)|(\\w(\\=\\=|\\<\\=|\\>\\=)\\w)'
local operator_space_1 = rex.new('(\\w(\\+|\\-|\\*|\\<|\\>|\\=)\\w)')
local operator_space_2 = rex.new('(\\w(\\=\\=|\\<\\=|\\>\\=)\\w)')

local comment_line = rex.new('^\\s*\\/\\*.*\\*\\/\\s*$')

function checkLine(filename, line, n)

  if string.match(line, tabs) then
    print(string.format("File: %s, line %d: [TABS]:\n%s", filename, n, line))
  end

  if #line > MAX_LINE_LENGTH then
    print(string.format("File: %s, line %d: [TOO LONG (%d) CHARS]:\n%s", filename, n, #line, line))
  end

  if string.match(line, c_plus_plus_comment) then
    print(string.format("File: %s, line %d: [DON'T USE C++ COMMENTS]:\n%s", filename, n, line))
  end

  if string.match(line, open_comment_space) then
    print(string.format("File: %s, line %d: [PUT SPACE AFTER OPEN COMMENT]:\n%s", filename, n, line))
  end

  if string.match(line, close_comment_space) then
    print(string.format("File: %s, line %d: [PUT SPACE AFTER CLOSE COMMENT]:\n%s", filename, n, line))
  end

  if string.match(line, paren_curly_space) then
    print(string.format("File: %s, line %d: [PUT SPACE BETWEEN ) AND {]:\n%s", filename, n, line))
  end

  if string.match(line, comma_space) then
    print(string.format("File: %s, line %d: [PUT SPACE AFTER COMMA]:\n%s", filename, n, line))
  end

  -- Use lrexlib-pcre library to work around Lua regex limitations.
  if operator_space_1:match(line) or operator_space_2:match(line) then
    if not comment_line:match(line) then
      print(string.format("File: %s, line %d: [PUT SPACE AROUND OPERATORS]:\n%s", filename, n, line))
    end
  end

  if string.match(line, semi_space) then
    print(string.format("File: %s, line %d: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n%s", filename, n, line))
  end

end

function checkFile(filename)
  -- Open file for reading line by line
  local file = io.open(filename, "r")
  if file == nil then
    print("File not found: " .. filename)
    return
  end

  local i = 0
  -- Read line by line
  for line in file:lines() do
    i = i + 1
    checkLine(filename, line, i)
  end
end

function usage()
  print("usage: c_style_check filename1 [filename2 ...]")
  os.exit(0)
end

function main()
  -- arg[1] is the first parameter
  if #arg < 1 then
    usage()
  end

  for i = 1, #arg do
    checkFile(arg[i])
  end
end

-- Call main
main()
