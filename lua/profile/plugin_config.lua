require('rose-pine').setup({
    disable_background = true
})

local copilot = require('copilot')
copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<S-Tab>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})
--telescope.load_extension('copilot')

--lsp config
local lsp = require('lsp-zero')
--additional setup in after/plugin/nvim-cmp.lua
lsp.preset('recommended')
lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
    -- 'clangd',
    'lua_ls',
    'cmake',
    'gopls',

})
lsp.nvim_workspace()
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.set_preferences({
    sign_icons = { }
})
lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "gd", function () vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function () vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function () vim.lsp.buf.workspace_symbol("") end, opts)
    vim.keymap.set("n", "<leader>vd", function () vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function () vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>vca", function () vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>qq", function () vim.lsp.buf.code_action({apply = true}) end, opts)
    vim.keymap.set("n", "<leader>vrr", function () vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function () vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "]d", function () vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<C-h>", function () vim.lsp.buf.signature_help() end, opts)
end)
lsp.setup()

----nvim-cmp - more lsp config
local cmp = require('cmp')
local luasnip = require('luasnip')
--LSP Mappings, handles copilot/cmp conflicts
cmp.setup({
        mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if CursorBeforeExpectedIndentColumn() then
                fallback()
            elseif require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            elseif cmp.visible() then
                cmp.mapping.confirm({ select = false })
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif not LineEmpty() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i","s",}),
        }),
})

--treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query", "cpp" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  -- choco install tree-sitter for windows to download the CLI
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require('refactoring').setup({
    prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
    },
    prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
})

local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
dap.adapters.lldb = {
    type = 'executable',
    command = 'C:/Program Files/LLVM/bin/lldb-vscode',
    name = "lldb"
}
local lldb = {
    name = 'Launch lldb',
    type = 'lldb',
    request = 'launch',
    -- program = 'build\\debug\\supportutils.exe',
    program = function()
        local file = io.open('build\\debug\\test\\test.exe', "r")
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
        return vim.fin.getcwd() .. '\\' .. vim.fn.input('Path to executable: ')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false;
}
dap.listeners.after.event_initializsation['dapui_config'] = function() dapui.open() end
dap.listeners.after.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.after.event_exited['dapui_config'] = function() dapui.close() end
dap.configurations.cpp = {lldb}
dap.configurations.c = {lldb}
dap.configurations.rust = {lldb}
require ("neodev").setup ({
    library = { plugins = {"nvim-dap-ui"}, types = true},
})


require("telescope").load_extension("refactoring")



