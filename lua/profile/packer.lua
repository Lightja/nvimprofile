-- This file can be loaded by calling `lua require('plugins')` from your init.vim
return require('packer').startup(function(use)
    
    -- unobjectionable theme:
    use({'rose-pine/neovim', as = 'rose-pine', config = function() vim.cmd('colorscheme rose-pine') end })

    -- Packer, plugin manager, so useful it can manage itself.
    use 'wbthomason/packer.nvim'

    -- Mandatory tpope plugins
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use('tpope/vim-fugitive')

    -- Fuzzy finder (find files, grep, etc)
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { {'nvim-lua/plenary.nvim'} } }

    -- bonus file navigation, ctrl+q/w/e/r/t - creator works at netflix btw.
    use('theprimeagen/harpoon')

    -- I don't make mistakes, but everyone says this plugin is good
    use('mbbill/undotree')

    -- The thing that actually writes the code and comments
    use {"zbirenbaum/copilot.lua" }
    -- use {"zbirenbaum/copilot-cmp", after = { "copilot.lua" }, config = function () require("copilot_cmp").setup() end }

    -- Syntax highlighting and editor power tools
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')

    -- diagnostics, references, telescope results, quickfix and location lists. Good for fixing things.
    use({ "folke/trouble.nvim", config = function() require("trouble").setup { icons = false, } end })

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim', branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim', run = function() pcall(vim.cmd, 'MasonUpdate') end}, -- Downloads LSPs with :Mason
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/nvim-cmp'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},

        }
    }

end)

