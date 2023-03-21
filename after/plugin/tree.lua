
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>' ,{silent = true, noremap = true})


-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

