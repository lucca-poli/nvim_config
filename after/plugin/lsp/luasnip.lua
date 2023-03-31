local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_lua").lazy_load({ paths = "~/.config/nvim/snippets/"})

ls.config.set_config({
    updateevents = "TextChanged, TextChangedI",
    enable_autosnippets = true,
})
