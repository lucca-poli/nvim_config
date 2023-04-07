local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.beautysh
    },
})
