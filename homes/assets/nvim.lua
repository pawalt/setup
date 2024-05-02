local telescope = require('telescope.builtin')
local lspconfig = require('lspconfig')
local lsp_zero = require('lsp-zero')

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {'vendor/*'},
    use_gitignore = true,
  },
})

-- Set space as the leader key
vim.g.mapleader = ' '

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Set colorscheme
vim.cmd('colorscheme gruvbox')
vim.opt.background = 'dark'

-- Clipboard settings
vim.opt.clipboard = 'unnamedplus'

-- Airline symbols (assuming you are using a plugin that supports Lua config)
vim.g.airline_powerline_fonts = 1

-- Indentation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Search and file lookup
vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>o', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', {noremap = true, silent = true})

-- telescopy
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope lsp_dynamic_workspace_symbols<CR>', {noremap = true, silent = true})

-- Navigation mappings
vim.api.nvim_set_keymap('n', '<leader>j', '<C-W><C-J>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>h', '<C-W><C-H>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>k', '<C-W><C-K>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>l', '<C-W><C-L>', {noremap = true, silent = true})

-- Delete but throw away result
vim.api.nvim_set_keymap('n', '<leader>d', '"_d', {noremap = true, silent = true})

-- Play macro in q
vim.api.nvim_set_keymap('n', '<leader>q', '@q', {noremap = true, silent = true})

-- Split window in both directions
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', {noremap = true, silent = true})

-- Close windows and panels
vim.api.nvim_set_keymap('n', '<leader>wc', ':q<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>wo', ':only<CR>', {noremap = true, silent = true})

-- go forward and back
vim.api.nvim_set_keymap('n', 'H', '<C-o>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'L', '<C-i>', {noremap = true, silent = true})

lspconfig.gopls.setup({})
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

