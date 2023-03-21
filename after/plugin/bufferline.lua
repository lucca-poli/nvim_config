vim.opt.termguicolors = true
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<S-d>", ":bdelete<CR>", opts)

bufferline.setup{
    options = {
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        always_show_bufferline = false,
    },
    highlights = {
        fill = {
            bg = 'none',
        },
        background = {
            bg = 'none'
        },
        tab = {
            bg = 'none'
        },
        tab_selected = {
            bg = 'none'
        },
        tab_close = {
            bg = 'none'
        },
        close_button = {
            bg = 'none'
        },
        close_button_visible = {
            bg = 'none'
        },
        close_button_selected = {
            bg = 'none'
        },
        buffer_visible = {
            bg = 'none'
        },
        buffer_selected = {
            bg = 'none',
        },
        numbers = {
            bg = 'none',
        },
        numbers_visible = {
            bg = 'none',
        },
        numbers_selected = {
            bg = 'none',
        },
        diagnostic = {
            bg = 'none',
        },
        diagnostic_visible = {
            bg = 'none',
        },
        diagnostic_selected = {
            bg = 'none',
        },
        hint = {
            bg = 'none'
        },
        hint_visible = {
            bg = 'none'
        },
        hint_selected = {
            bg = 'none',
        },
        hint_diagnostic = {
            bg = 'none'
        },
        hint_diagnostic_visible = {
            bg = 'none'
        },
        hint_diagnostic_selected = {
            bg = 'none',
        },
        info = {
            bg = 'none'
        },
        info_visible = {
            bg = 'none'
        },
        info_selected = {
            bg = 'none',
        },
        info_diagnostic = {
            bg = 'none'
        },
        info_diagnostic_visible = {
            bg = 'none'
        },
        info_diagnostic_selected = {
            bg = 'none',
        },
        warning = {
            bg = 'none'
        },
        warning_visible = {
            bg = 'none'
        },
        warning_selected = {
            bg = 'none',
        },
        warning_diagnostic = {
            bg = 'none'
        },
        warning_diagnostic_visible = {
            bg = 'none'
        },
        warning_diagnostic_selected = {
            bg = 'none',
        },
        error = {
            bg = 'none',
        },
        error_visible = {
            bg = 'none'
        },
        error_selected = {
            bg = 'none',
        },
        error_diagnostic = {
            bg = 'none',
        },
        error_diagnostic_visible = {
            bg = 'none'
        },
        error_diagnostic_selected = {
            bg = 'none',
        },
        modified = {
            bg = 'none'
        },
        modified_visible = {
            bg = 'none'
        },
        modified_selected = {
            bg = 'none'
        },
        duplicate_selected = {
            bg = 'none'
        },
        duplicate_visible = {
            bg = 'none'
        },
        duplicate = {
            bg = 'none'
        },
        separator_selected = {
            bg = 'none'
        },
        separator_visible = {
            bg = 'none'
        },
        separator = {
            bg = 'none'
        },
        indicator_selected = {
            bg = 'none'
        },
        pick_selected = {
            bg = 'none',
        },
        pick_visible = {
            bg = 'none',
        },
        pick = {
            bg = 'none',
        },
        offset_separator = {
            bg = 'none',
        },
    },
}
