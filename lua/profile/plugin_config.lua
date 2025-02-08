

require'nvim-treesitter.install'.prefer_git = false



require("cyberdream").setup({
    colors = {bg = "#000000"},
    highlights = {Comment = {fg = "#00ff00"}},
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
-- lsp.preset('recommended')
lsp.setup {
	servers = {
		'cpp',
		'c',
		'lua_ls',
		'pyright',
		'gopls',
		'clangd',
		'jdtls',
		'cmake',
		'bat',
		'vim',
		'vimdoc',
		'typescript',
		'javascript',
		'jdtls'
	},
	on_attach = function(client, bufnr)
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
	end
}
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
		sources = {
			{ name = 'nvim_lsp' },  -- cmp-nvim-lsp
			{ name = 'luasnip' },
			{ name = 'buffer' },   -- cmp-buffer
			{ name = 'path' },     -- cmp-path
			{ name = 'nvim_lua' }, -- cmp-nvim-lua
		},
})


-- require('refactoring').setup({
    -- prompt_func_return_type = {
        -- go = false,
        -- java = false,
        -- cpp = false,
        -- c = false,
        -- h = false,
        -- hpp = false,
        -- cxx = false,
    -- },
    -- prompt_func_param_type = {
        -- go = false,
        -- java = false,
        -- cpp = false,
        -- c = false,
        -- h = false,
        -- hpp = false,
        -- cxx = false,
    -- },
    -- printf_statements = {},
    -- print_var_statements = {},
-- })

local dap = require('dap')
local dapui = require('dapui')
dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "X",
            pause = "‼",
            play = "▸",
            run_last = "»",
            step_back = "←",
            step_into = "↓",
            step_out = "↑",
            step_over = "→",
            terminate = "■"
        },
    },
    icons = {
        expanded = "○",
        current_frame = "☼",
        collapsed = "…",
    },
})
dap.adapters.lldb = {
    type = 'executable',
    command = 'C:/Program Files/LLVM/bin/lldb-vscode',
    name = "lldb"
}
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {command = 'c:/codelldb/extension/adapter/codelldb', args = {"--port","${port}"}},
}
-- local codelldb = {
--     name = 'Launch file',
--     type = 'codelldb',
--     request = 'launch',
--     program = FindExe(),
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},
--     runInTerminal = false;
-- }

local lldb = {
    name = 'Launch lldb',
    type = 'lldb',
    request = 'launch',
    program = FindExe(),
    environment = function()
        local file = io.open(vim.fn.getcwd() .. '/vcpkg/installed/x64-windows-static/lib/libtcmalloc_minimal.lib', "r")
        if file then
            file:close()
            return {{name = "LD_PRELOAD", value = vim.fn.getcwd() .. "/vcpkg/installed/x64-windows-static/lib/libtcmalloc_minimal.lib"},
                    {name = "HEAPPROFILE", value = vim.fn.getcwd() .. "/tmp/heapprof " .. FindExe()}}
        end
        return {}
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


-- require("telescope").load_extension("refactoring")



