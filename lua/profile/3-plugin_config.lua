
local treesitter_install = require 'nvim-treesitter.install'
local treesitter_config  = require 'nvim-treesitter.configs'
treesitter_install.compilers = { "zig" }
treesitter_install.prefer_git = false
treesitter_config.setup { highlight = { enable = true } }


require("cyberdream").setup({
    colors = {bg = "#000000"},
    highlights = {Comment = {fg = "#00ff00"}},
})

vim.keymap.set("n", "[d", 			function () vim.diagnostic.goto_next()  end, opts)
vim.keymap.set("n", "]d", 			function () vim.diagnostic.goto_prev()  end, opts)
vim.keymap.set("n", "<leader>vd", 	function () vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "gl", 			function () vim.diagnostic.open_float() end, opts)
vim.api.nvim_create_autocmd('LspAttach', {desc = 'LSP actions',
	callback = function(event)
		local opts = {buffer = event.buf}
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set("n", "gd", 			function () vim.lsp.buf.definition() 				end, opts)
		vim.keymap.set("n", "gi", 			function () vim.lsp.buf.implementation() 			end, opts)
		vim.keymap.set("n", "go", 			function () vim.lsp.buf.type_definition() 			end, opts)
		vim.keymap.set("n", "gr", 			function () vim.lsp.buf.references() 				end, opts)
		vim.keymap.set("n", "gD", 			function () vim.lsp.buf.declaration() 				end, opts)
		vim.keymap.set("n", "K", 			function () vim.lsp.buf.hover() 					end, opts)
		vim.keymap.set("n", "<leader>vws", 	function () vim.lsp.buf.workspace_symbol("") 		end, opts)
		vim.keymap.set("n", "<leader>vca", 	function () vim.lsp.buf.code_action() 				end, opts)
		vim.keymap.set("n", "<leader>qq", 	function () vim.lsp.buf.code_action({apply = true}) end, opts)
		vim.keymap.set("n", "<leader>vrr", 	function () vim.lsp.buf.references() 				end, opts)
		vim.keymap.set("n", "<leader>vrn", 	function () vim.lsp.buf.rename() 					end, opts)
		vim.keymap.set("n", "<C-h>", 		function () vim.lsp.buf.signature_help() 			end, opts)
		vim.keymap.set("n", "<leader>h", 	function () vim.lsp.buf.signature_help() 			end, opts)
	end
})


local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local default_setup = function(server)
  require('lspconfig')[server].setup({
    capabilities = lsp_capabilities,
  })
end

require'lspconfig'.lua_ls.setup{
	cmd = {"C:/Users/Lightja/scoop/shims/lua-language-server.exe"}
}

require'lspconfig'.clangd.setup{
	cmd = {"C:/Program Files/LLVM/bin/clangd.exe"}
}

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'cmake',
		'pyright',
		'tailwindcss',
		'dockerls',
		'elixirls',
		'jdtls',              -- java
		'rome',               -- json (alt: spectral)
		'grammarly',          -- markdown
		'sqlls',
		'svelte',
		'zls'                 -- zig
	},
	handlers = {default_setup}
})

----nvim-cmp - more lsp config
local cmp     = require('cmp')
local luasnip = require('luasnip')
--LSP Mappings, handles copilot/cmp conflicts
cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },  -- cmp-nvim-lsp
		{ name = 'luasnip' },
		{ name = 'buffer' },   -- cmp-buffer
		{ name = 'path' },     -- cmp-path
		{ name = 'nvim_lua' }, -- cmp-nvim-lua
	},
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
	snippet = {
		expand = function(args)
		luasnip.lsp_expand(args.body)
		end,
	}
})


local dap = require('dap')
local dapui = require('dapui')
dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "X",
            pause      = "‼",
            play       = "▸",
            run_last   = "»",
            step_back  = "←",
            step_into  = "↓",
            step_out   = "↑",
            step_over  = "→",
            terminate  = "■"
        },
    },
    icons = {
        expanded      = "○",
        current_frame = "☼",
        collapsed     = "…",
    },
})
dap.adapters.lldb = {
    type = 'executable',
    command = 'C:/Users/Lightja/scoop/apps/mingw-winlibs-llvm-ucrt/14.2.0-19.1.1-12.0.0-r2/bin/lldb-dap.exe',
    name = "lldb"
}
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {command = 'c:/codelldb/extension/adapter/codelldb', args = {"--port","${port}"}},
}

local lldb = {
    name        = 'Launch lldb',
    type        = 'lldb',
    request     = 'launch',
    program     = FindExe(),
    environment = function()
        local file = io.open(vim.fn.getcwd() .. '/vcpkg/installed/x64-windows-static/lib/libtcmalloc_minimal.lib', "r")
        if file then
            file:close()
            return {{name = "LD_PRELOAD", value  = vim.fn.getcwd() .. "/vcpkg/installed/x64-windows-static/lib/libtcmalloc_minimal.lib"},
                    {name = "HEAPPROFILE", value = vim.fn.getcwd() .. "/tmp/heapprof " .. FindExe()}}
        end
        return {}
    end,
    cwd           = '${workspaceFolder}',
    stopOnEntry   = false,
    args          = {},
    runInTerminal = false;
}
dap.listeners.after.event_initializsation['dapui_config'] = function() dapui.open()  end
dap.listeners.after.event_terminated['dapui_config']      = function() dapui.close() end
dap.listeners.after.event_exited['dapui_config']          = function() dapui.close() end
dap.configurations.cpp  = {lldb}
dap.configurations.c    = {lldb}
dap.configurations.rust = {lldb}
require ("neodev").setup ({
    library = { plugins = {"nvim-dap-ui"}, types = true},

})


local copilot = require('copilot')
copilot.setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept    = "<CR>",
      refresh   = "gr",
      open      = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio    = 0.4
    },
  },
  suggestion = {
    enabled      = true,
    auto_trigger = false,
    debounce     = 75,
    keymap = {
      accept      = "<S-Tab>",
      accept_word = false,
      accept_line = false,
      next        = "<C-Tab>",
      prev        = "<M-[>",
      dismiss     = "<C-]>",
    },
  },
  filetypes = {
    yaml      = false,
    markdown  = false,
    help      = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit  = false,
    svn       = false,
    cvs       = false,
    ["."]     = false,
  },
  copilot_node_command = 'node',
  server_opts_overrides = {},
})
