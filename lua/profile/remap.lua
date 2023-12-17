--more remappings for LSP/CMP in plugin_config.lua during plugin setup

-- primeagen mappings - netflix?
vim.g.mapleader = " "

--back to netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--move current selection up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- makes C-d and C-u usable for half-page up/down by centering with zz post jump
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)

-- quick fix list?
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

--run build batch file
vim.api.nvim_set_keymap('n', '<C-b>', ':!tools\\buildfast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':!tools\\clean<CR>:!tools\\build<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-m>', ':!tools\\clean<CR>:!tools\\buildTest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-m>', ':!tools\\buildTest<CR>', { noremap = true, silent = true })

--toggle slashes ToggleSlash defined in init.lua
vim.api.nvim_set_keymap('v', '<F8>', ':ToggleSlash<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F8>', ':ToggleSlash<CR>', { noremap = true, silent = true })
--remap b/B to s/S in normal and visual mode for stepping backwards more easily for a non-homerow typing qwerty gamer
vim.api.nvim_set_keymap('n', 's', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'S', 'B', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 's', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'S', 'B', { noremap = true, silent = true })
--smart insert mode - if line is empty, tab cursor automatically, much less annoying indentation and better compatibility with copilot bound to tab
--probably trash performance, will probably revisit at some point
--still missing some edge cases, but works well enough for now

vim.api.nvim_set_keymap('n', 'i', ':silent! lua TabCursorIfLineEmpty("i")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'a', ':silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Up>', '<Up><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Down>', '<Down><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Left>', '<Left><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Right>', '<Right><Esc>:silent! lua TabCursorIfLineEmpty("a")<CR>', { noremap = true, silent = true })

-- create header for c++ function on cursor, requires ourobouros
vim.api.nvim_set_keymap('n', '<leader>h', '^vt)ly:Ouroboros<CR>ggvi{<Esc>o<Esc>pa;<Esc>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qq', '<leader>vca1<CR>', { noremap = true, silent = true })

--fugitive git-status
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

--harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-t>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-q>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-w>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-e>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-r>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<C-Up>", function() ui.nav_next() end)
vim.keymap.set("n", "<C-Down>", function() ui.nav_prev() end)

--testing
vim.keymap.set("n", "<leader>tt", function() print(CursorBeforeExpectedIndentColumn()) end)

--trouble
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })

--undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

--telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) --pnuemonic: find files or fuzzy finder
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-f>', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }); end)

--Remap: Remaps for the refactoring operations. Pnuemonic 'r' for Refactor
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>rf",
    [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
    { noremap = true, silent = true, expr = false })
-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })
-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true })

-- nvim-dap debugging bindings. Pnuemonic 'd' for 'Debug'
vim.keymap.set("n", "<leader>dt", function() require("dapui").toggle() end)
vim.keymap.set("n", "<leader>de", [[<Cmd>lua require("dapui").eval()<CR>]])
vim.keymap.set("n", "<leader>ds", function() require("dap").continue() end)   --pnuemonic: s for start
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end)   --pnuemonic: c for continue
vim.keymap.set("n", "<leader>dq", function() require("dap").disconnect() end)
vim.keymap.set("n", "<leader>dso", function() require("dap").step_over() end) --pnuemonic: o for over
vim.keymap.set("n", "<leader>dsd", function() require("dap").step_into() end) --pnuemonic: u for up
vim.keymap.set("n", "<leader>dsu", function() require("dap").step_out() end)  --pnuemonic: d for down
vim.keymap.set("n", "<leader>dr", function() require("dap").run_last() end)
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<F5>", ':lua RunPsql()<CR>', { silent = true, noremap = true })
