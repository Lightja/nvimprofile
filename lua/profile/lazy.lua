-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	{"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "c", "lua", "vim", "vimdoc", "cpp", "query", "javascript", "typescript" },
			sync_install = false,
			auto_install = true,
			highlight    = { enable = true },
		}
	},
	{ 'tpope/vim-surround'},   																									-- tpope surrounding text (e.g. {}, "", etc)
	{ 'tpope/vim-commentary'},   																								-- tpope comments
	{ 'tpope/vim-fugitive'},     																								-- tpope git
	{ 'theprimeagen/harpoon'},																									-- Bonus file navigation, ctrl+q/w/e/r/t
	{ 'scottmckendry/cyberdream.nvim', as = 'cyberdream', config = function() vim.cmd('colorscheme cyberdream') end },  		-- color scheme
	{ 'nvim-telescope/telescope.nvim', dependencies = 'nvim-lua/plenary.nvim' }, 												-- Fuzzy finder (find files, grep, etc)
	{ 'zbirenbaum/copilot.lua', as= 'copilot'},																					-- copilot
	{ 'mbbill/undotree'},																										-- undotree (<leader>u)
	{ 'jakemason/ouroboros', dependencies = 'nvim-lua/plenary.nvim' },															-- C Header/Source file switching
	{ 'neovim/nvim-lspconfig'},
	{ 'folke/neodev.nvim'},                                                                                                     -- folke/neodev.nvim
	{ 'folke/trouble.nvim', opts = { icons = false } },																			-- Diagnostics, references, telescope results, quickfix and location lists. Good for fixing things.
	{ 'mfussenegger/nvim-dap'},   																								-- Debugger
	{ 'rcarriga/nvim-dap-ui', name='dapui', dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },				-- Debugger UI
	{ 'hrsh7th/nvim-cmp'},
	{ 'L3MON4D3/LuaSnip'},
	{ 'rafamadriz/friendly-snippets'},
	{ 'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		}
	},
    install = { colorscheme = { "cyberdream" } },
    checker = { enabled = true },
	-- { 'hrsh7th/cmp-nvim-lsp'},
	-- { 'hrsh7th/cmp-nvim-lua'},
	-- { 'hrsh7th/cmp-buffer'},
	-- { 'hrsh7th/cmp-path'},
	-- { "ThePrimeagen/refactoring.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },		-- Refactoring, debugging print statements, etc
	-- {'nvim-treesitter/playground'},																								-- treesitter playground
})
local treesitter_install = require 'nvim-treesitter.install'
treesitter_install.compilers = { "zig" }
treesitter_install.prefer_git = false