#!/usr/bin/env ruby

# rubocop:disable Style/GlobalVars
$MAX_LINE_LENGTH = 80

$Tabs = Regexp.compile('\t+')
$CommaSpace = Regexp.compile(',[^\s]')
$OperatorSpace = Regexp.compile('(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)')
$CommentLine = Regexp.compile('^\s*\/\*.*\*\/\s*$')
$OpenCommentSpace = Regexp.compile('\/\*[^ *\n]')
$CloseCommentSpace = Regexp.compile('[^ *]\*\/')
$ParenCurlySpace = Regexp.compile('\)\{')
$CppComment = Regexp.compile('\/\/')
$SemiSpace = Regexp.compile(';[^ \s]')

def check_line(filename, line, n)
  # Strip the terminal newline.
  line = line.chomp

  if line =~ $Tabs
    puts "File: #{filename}, line #{n}: [TABS]:\n#{line}"
  end

  if line.length > $MAX_LINE_LENGTH
    puts "File: #{filename}, line #{n}: [TOO LONG (#{line.length} CHARS)]:\n#{line}"
  end

  if line =~ $CppComment
    puts "File: #{filename}, line #{n}: [DON'T USE C++ COMMENTS]:\n#{line}"
  end

  if line =~ $OpenCommentSpace
    puts "File: #{filename}, line #{n}: [PUT SPACE AFTER OPEN COMMENT]:\n#{line}"
  end

  if line =~ $CloseCommentSpace
    puts "File: #{filename}, line #{n}: [PUT SPACE AFTER CLOSE COMMENT]:\n#{line}"
  end

  if line =~ $ParenCurlySpace
    puts "File: #{filename}, line #{n}: [PUT SPACE BETWEEN ) AND {]:\n#{line}"
  end

  if line =~ $CommaSpace
    puts "File: #{filename}, line #{n}: [PUT SPACE AFTER COMMA]:\n#{line}"
  end

  if line =~ $SemiSpace
    puts "File: #{filename}, line #{n}: [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n#{line}"
  end

  if line =~ $OperatorSpace
    if line !~ $CommentLine
      puts "File: #{filename}, line #{n}: [PUT SPACE AROUND OPERATORS]:\n#{line}"
    end
  end
end

# Read file line by line
def chech_file(filename)
  file = File.open(filename, "r")
  file.each_line do |line|
    check_line(filename, line, file.lineno)
  end
  file.close
end

def usage
  puts "usage: c_style_check filename1 [filename2 ...]"
  exit 1
end

# ruby script filename1
# filename1 == ARGV[1]
if ARGV.length == 0
  usage
end

ARGV.each do |filename|
  chech_file(filename)
end
