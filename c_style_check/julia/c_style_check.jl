const MAX_LINE_LENGTH = 80

const tabs = r"\t+"
const comma_space = r",[^ ]"
const operator_space = r"(\w(\+|\-|\*|\<|\>|\=)\w)|(\w(\=\=|\<\=|\>\=)\w)"
const comment_line = r"^\s*\/\*.*\*\/\s*$"
const open_comment_space = r"\/\*[^ *\n]"
const close_comment_space = r"[^ *]\*\/"
const paren_curly_space = r"\)\{"
const c_plus_plus_comment = r"//"
const semi_space = r";[^ \s]"

function check_line(filename::String, line::String, n::Int)
    # Strip the terminal newline
    line = rstrip(line)

    if occursin(tabs, line)
        print("File: $(filename), line: $(n): [TABS]:\n$(line)\n")
    end

    if length(line) > MAX_LINE_LENGTH
        print("File: $(filename), line: $(n): [TOO LONG (88 CHARS)]:\n$(line)\n")
    end

    if occursin(open_comment_space, line)
        print("File: $(filename), line: $(n): [PUT SPACE AFTER OPEN COMMENT]:\n$(line)\n")
    end

    if occursin(close_comment_space, line)
        print("File: $(filename), line: $(n): [PUT SPACE AFTER CLOSE COMMENT]:\n$(line)\n")
    end

    if occursin(paren_curly_space, line)
        print("File: $(filename), line: $(n): [PUT SPACE BETWEEN ) AND {]:\n$(line)\n")
    end

    if occursin(c_plus_plus_comment, line)
        print("File: $(filename), line: $(n): [DON'T USE C++ COMMENTS]:\n$(line)\n")
    end

    if occursin(semi_space, line)
        print(
            "File: $(filename), line: $(n): [PUT SPACE/NEWLINE AFTER SEMICOLON]:\n$(line)\n",
        )
    end

    if occursin(operator_space, line)
        if !occursin(comment_line, line)
            print("File: $(filename), line: $(n): [PUT SPACE AROUND OPERATORS]:\n$(line)\n")
        end
    end

    if occursin(comma_space, line)
        print("File: $(filename), line: $(n): [PUT SPACE AFTER COMMA]:\n$(line)\n")
    end
end

function check_file(filename::String)
    i = 0
    open(filename) do file
        for line in eachline(file)
            i += 1
            check_line(filename, line, i)
        end
    end
end

function usage()
    println("usage: c_style_check filename1 [filename2 ...]")
    return
end

function main(args::Vector{String})
    if length(args) < 1
        usage()
    end

    for arg in ARGS
        check_file(arg)
    end
end

main(ARGS)
