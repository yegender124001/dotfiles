-- Normal stuff --
vim.opt.number = true			-- Number
vim.opt.relativenumber = true		-- Relative Number
vim.opt.mouse = 'a'			-- Mouse
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

-- Keymaps --
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n','<Tab>',':bnext<CR>', {silent = true})   -- Next Buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { silent = true }) -- Previous Buffer
vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { silent = true }) -- Close Buffer


-- Plugins --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git","clone","--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- 1. Colorscheme (Rose Pine is light on resources)
    { "rose-pine/neovim", name = "rose-pine", config = function() vim.cmd('colorscheme rose-pine') end },

    -- 2. Syntax Highlighting (Treesitter)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- 3. Autocomplete menu
    { "saghen/blink.cmp",
    version = '*',
    opts = {
        keymap = { 
            preset = 'default',
            ['<Tab>'] = {'accept', 'fallback'},
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    }, },

    -- 4. Autopairs
    {"windwp/nvim-autopairs", event = "InsertEnter", config= true},

    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                mode = "buffers",
                separator_style = "slant",
                show_buffer_close_icons = false,
                show_close_icon = false,
            }
        }
    },
    -- Meson Syntax Highlighting
    { "igankevich/mesonic" },
    
    -- Telescope (The ultimate file/text finder)
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Search filenames
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Search text inside files
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 30,
                    side = "left",
                },
                -- Keeps the tree updated when you change files
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
            })
        end,
    },
    {
    'stevearc/conform.nvim',
    opts = {
        formatters_by_ft = {
            cpp = { "clang-format" },
            meson = { "muon" },
            python = {"ruff_format"},
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
}
})

--          -- LSPs
-- 1. Clangd (Can't live without it)
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '-j=2',
        '--log=error'
    },
    filetypes = {'c','cpp','h','hpp','objc','objcpp','cuda','proto'},
    root_markers = {'.git','compile_commands.json','compile_flags.txt'},
})
vim.lsp.enable('clangd')


-- Meson
vim.lsp.config('meson', {
    cmd = {'mesonlsp','--lsp'},
    filetypes = {'meson'},
    root_markers = { 'meson.build', 'meson_options.txt' },
})

vim.lsp.enable('meson')

-- Zig
vim.lsp.config('zig', {
    cmd = {'zls'},
    filetypes = {'zig'},
    root_markers = {'build.zig'},
})

vim.lsp.enable('zig')

-- Python (Pyright)
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
})
vim.lsp.enable('pyright')

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    end,
})

-- Save undo history to a file so it persists after closing nvim
local undodir = vim.fn.expand('~/.local/share/nvim/undo')
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end

vim.opt.undodir = undodir
vim.opt.undofile = true
