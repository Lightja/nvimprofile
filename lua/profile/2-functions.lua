function ColorMyPencils(color)
	color = color or "cyberdream"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function FindExe()
    local file = io.open('build\\debug\\elleslist\\elleslist.exe', "r")
    if file then
        file:close()
        return 'build\\debug\\elleslist\\elleslist.exe'
    end
    file = io.open('build\\debug\\test\\test.exe', "r")
    if file then
        file:close()
        return 'build\\debug\\test\\test.exe'
    end
    file = io.open('build\\debug\\BSSProactive\\BSSProactive.exe', "r")
    if file then
        file:close()
        return 'build\\debug\\BSSProactive\\BSSProactive.exe'
    end
    file = io.open('build\\debug\\SupportUtils\\SupportUtils.exe', "r")
    if file then
        file:close()
        return 'build\\debug\\SupportUtils\\SupportUtils.exe'
    end
    return ""--vim.fn.getcwd() .. '\\' .. vim.fn.input('Path to executable: ')
end

function LineEmpty()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") ~= nil
end

-- function ExpectedIndentColumn()
    -- local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- local line_text = vim.api.nvim_buf_get_lines(0, line-1, line, false)[1]
    -- local indent = vim.fn.indent(line)
    -- -- local indent_size = vim.fn.indentsize(line)
    -- return indent
-- end

-- function ExpectedIndentColumn2()
    -- local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- local line_text = vim.api.nvim_buf_get_lines(0, line-1, line, false)[1]
    -- local indent = vim.fn.indent(line)
    -- -- local indent_size = vim.fn.indentsize(line)
    -- return indent 
-- end

function SplitStringToTable (inputstr, sep)
    local output_table = {}
    for item in inputstr:gmatch("([^"..sep.."]+)") do
        table.insert(output_table, item)
    end
    return output_table
end

function CursorBeforeExpectedIndentColumn()
    -- local line = vim.fn.getline(".")
    local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
    local previous_line_num = vim.fn.prevnonblank(line_num - 1);
    local previous_indent = vim.fn.indent(previous_line_num);
    local previous_line_text = vim.api.nvim_buf_get_text(0, previous_line_num - 1, 0, previous_line_num-1, 0, {})[1]
    -- local keywords = vim.split(vim.api.nvim_get_option('cinwords'), ',')
    local keywords = SplitStringToTable(vim.api.nvim_get_option_value('cinwords',{scope="local"}),',')
    table.insert(keywords, "{")
    for _, keyword in ipairs(keywords) do
        if previous_line_text:match(keyword) then
            previous_indent = previous_indent + vim.api.nvim_get_option('shiftwidth')
            break
        end
    end

    return previous_indent > col
end

    -- return vim.api.nvim_get_option('cinwords')
-- end
    -- local line,_ = unpack(vim.api.nvim_win_get_cursor(0))
    -- -- Check if the current line is empty
    -- local is_empty_line = vim.api.nvim_get_current_line():match("^%s*$") ~= nil
    -- if is_empty_line then
    --     -- Get the indentation of the previous non-empty line
    --     local previous_line = vim.fn.prevnonblank(line - 1)
    --     local previous_indent = vim.fn.indent(previous_line)
    --     -- Get the context of the previous line to determine the expected indentation
    --     local previous_line_context = vim.api.nvim_get_context(previous_line)

    --     -- Calculate the expected indentation
    --     local expected_indentation = vim.fn.indent(previous_line_context, previous_indent)
    --     return expected_indentation
    -- else
    --     -- Return the current indentation for non-empty lines
    --     return vim.fn.indent(line)
    -- end
-- end

function ToggleSlash(firstline, lastline, independent)
    local from = ''
    for lnum = firstline, lastline do
        local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
        local first_char = string.match(line, '[/\\]')
        if first_char ~= nil then
            if independent or from == '' then
                from = first_char
            end
            local opposite = (from == '/' and '\\' or '/')
            local new_line = string.gsub(line, from, opposite)
            vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, {new_line})
        end
    end
end


function IsWhitespace(str)
    return str:match("^%s*$") ~= nil
end

function TabCursorIfLineEmpty(button)
    local line = vim.fn.getline(".")
    local mode = vim.api.nvim_get_mode().mode

    if IsWhitespace(line) then
        vim.api.nvim_feedkeys("cc", "n", true)
    else
        vim.api.nvim_feedkeys(button, mode, true)
    end
end

function RunPsql()
    local current_buffer = vim.fn.expand('%:t')
    if not (current_buffer:match("%.sql$") or current_buffer:match("%.psql$")) then
        return
    end
    vim.cmd("w! c:\\script.sql")
    vim.fn.writefile(vim.fn.readfile('c:\\script.sql'), 'c:\\scriptcopy2.sql')
    local exit_code = vim.fn.system("psql -d elle -f c:\\scriptcopy2.sql > c:\\out3.txt")
    if exit_code ~= 0 and exit_code ~= "" then
        print("Error running psql. Exit code: " .. exit_code)
    end
end


