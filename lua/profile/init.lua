require("profile.remap")
require("profile.set")
require("profile.packer")



--slash flipping
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


function SmartIndentI()
    if string.len(vim.fn.getline(".")) == 0 then
        return vim.api.nvim_feedkeys("\"_cc", "n", true)
    else
        return vim.api.nvim_feedkeys("i", "n", true)
    end
end
function SmartIndentA()
    if string.len(vim.fn.getline(".")) == 0 then
        return vim.api.nvim_feedkeys("\"_cc", "n", true)
    else
        return vim.api.nvim_feedkeys("a", "n", true)
    end
end

vim.cmd("command! -bang -range ToggleSlash <line1>,<line2>lua ToggleSlash(<line1>, <line2>, tonumber(<bang>1) == 1)")






vim.api.nvim_set_var('clipboard', {
  name = 'WslClipboard',
  copy = {
    ['+'] = 'clip.exe',
    ['*'] = 'clip.exe',
  },
  paste = {
    ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enabled = 0,
})
