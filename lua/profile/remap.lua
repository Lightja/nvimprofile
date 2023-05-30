-- primeagen mappings - netflix?
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste, deleted goes into void buffer so we can paste the same thing again
vim.keymap.set("x", "<leader>p", "\"_dP")

-- copy to main clipboard instead of vim clipboard: asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete without saving to clipboard
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- ?? I put this here bc someone told me to. apparently Q is bad.
vim.keymap.set("n", "Q", "<nop>")

-- header / source file switching
vim.keymap.set("n", "<C-o>", ":Ouroboros<CR>")

-- doesnt even work on windows lmao
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- quick fix list?
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

---CUSTOM---
--build batch file
vim.api.nvim_set_keymap('n', '<C-n>', ':!tools\\clean<CR>:!tools\\build<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-b>', ':!tools\\buildfast<CR>', { noremap = true, silent = true })

--toggle slashes ToggleSlash defined in init.lua
vim.api.nvim_set_keymap('v', '<F8>', ':ToggleSlash<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F8>', ':ToggleSlash<CR>', { noremap = true, silent = true })


--smart insert mode - if line is empty, tab cursor automatically, much less annoying indentation and better compatibility with copilot bound to tab
function IsWhitespace(str)
    --returns true if string is all whitespace
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
vim.api.nvim_set_keymap('n', 'i', ':silent! lua TabCursorIfLineEmpty("i")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'a', ':silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Up>', '<Up><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Down>', '<Down><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Left>', '<Left><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Right>', '<Right><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })

