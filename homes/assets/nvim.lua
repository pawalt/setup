local telescope = require('telescope.builtin')
local lspconfig = require('lspconfig')
local lsp_zero = require('lsp-zero')

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {'vendor/*'},
    use_gitignore = true,
  },
})

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
})

require('guess-indent').setup({})

-- space is leader
vim.g.mapleader = ' '

-- set colorscheme
vim.cmd('syntax enable')
vim.cmd('colorscheme gruvbox-material')
vim.opt.background = 'dark'

-- relnum
vim.wo.relativenumber = true
vim.wo.number = true

-- use the system clippy
vim.opt.clipboard = 'unnamedplus'

-- airline symbols
vim.g.airline_powerline_fonts = 1

-- indentation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- search and file lookup
vim.api.nvim_set_keymap('n', '<leader><leader>', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>o', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', {noremap = true, silent = true})

-- telescopy
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope lsp_dynamic_workspace_symbols<CR>', {noremap = true, silent = true})

-- terminal config
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap = true, silent = true})
local function disable_line_numbers()
  vim.wo.number = false
  vim.wo.relativenumber = false
end
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = disable_line_numbers
})

-- navigation mappings
vim.api.nvim_set_keymap('n', '<leader>j', '<C-W><C-J>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>h', '<C-W><C-H>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>k', '<C-W><C-K>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>l', '<C-W><C-L>', {noremap = true, silent = true})

-- delete but throw away result
vim.api.nvim_set_keymap('n', '<leader>d', '"_d', {noremap = true, silent = true})

-- play macro in q
vim.api.nvim_set_keymap('n', '<leader>q', '@q', {noremap = true, silent = true})

-- split window in both directions
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-w>v', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-w>s', {noremap = true, silent = true})

-- close windows and panels
vim.api.nvim_set_keymap('n', '<leader>wc', ':q<CR>', {noremap = true, silent = true})

-- go forward and back
vim.api.nvim_set_keymap('n', 'H', '<C-o>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'L', '<C-i>', {noremap = true, silent = true})

-- test running
vim.api.nvim_set_keymap('n', '<leader>rt', ":TestNearest -v<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>rp', ":TestFile -v<CR>", {noremap = true, silent = true})

-- TODO:
-- - go to next/previous problem
-- - rerun failed tests
-- - rerun last test
-- - debug
-- - refactoring
-- - goto impl, references
-- - open in github

-- use persistent terminal for tests
vim.g['test#strategy'] = 'neovim_sticky'

-- use default lsp_zero bindings and enable go
lspconfig.gopls.setup({})
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- use regular tab autocomplete
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end
        cmp.confirm()
      else
        fallback()
      end
    end, {"i",}),
  }),
})
