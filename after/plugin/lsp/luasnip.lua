local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_lua").lazy_load({ paths = "~/.config/nvim/snippets/"})

ls.config.set_config({
    updateevents = "TextChanged, TextChangedI",
    enable_autosnippets = true,
})
