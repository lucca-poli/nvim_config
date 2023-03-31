local ls = require("luasnip") --{{{
local s = ls.s                --> snippet
local i = ls.i                --> insert node
local t = ls.t                --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

local function cs(trigger, nodes, opts) --{{{
    local snippet = s(trigger, nodes)
    local target_table = snippets

    local pattern = file_pattern
    local keymaps = {}

    if opts ~= nil then
        -- check for custom pattern
        if opts.pattern then
            pattern = opts.pattern
        end

        -- if opts is a string
        if type(opts) == "string" then
            if opts == "auto" then
                target_table = autosnippets
            else
                table.insert(keymaps, { "i", opts })
            end
        end

        -- if opts is a table
        if opts ~= nil and type(opts) == "table" then
            for _, keymap in ipairs(opts) do
                if type(keymap) == "string" then
                    table.insert(keymaps, { "i", keymap })
                else
                    table.insert(keymaps, keymap)
                end
            end
        end

        -- set autocmd for each keymap
        if opts ~= "auto" then
            for _, keymap in ipairs(keymaps) do
                vim.api.nvim_create_autocmd("BufEnter", {
                    pattern = pattern,
                    group = group,
                    callback = function()
                        vim.keymap.set(keymap[1], keymap[2], function()
                            ls.snip_expand(snippet)
                        end, { noremap = true, silent = true, buffer = true })
                    end,
                })
            end
        end
    end

    table.insert(target_table, snippet) -- insert snippet into appropriate table
end                                     --}}}

local return_filename = function()
    local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':t')
    return string.match(filename, "(.-)%.")
end

-- Start Refactoring --

local destructeredImport = s("dimp", fmt([[
import {{ {2} }} from "{1}";
]], {
    i(1, "module"),
    i(2, ""),
}))
table.insert(snippets, destructeredImport)

local defaultImport = s("imp", fmt([[
import {2} from "{1}";
]], {
    i(1, "module"),
    i(2, "default_module"),
}))
table.insert(snippets, defaultImport)

local grabFilename = s("grab", fmt([[
// list:
{1}

// and copy of list:
{2}
]], {
    i(1, "placeholder"), -- Input node for variable names
    f(function(args)
            local nodes = {}
            for _, textNodeTable in ipairs(args[1]) do
                local nodeText = textNodeTable

                nodeText = string.match(nodeText, "([^:]+):")
                nodeText = string.format("  this.%s = %s;", nodeText, nodeText)

                table.insert(nodes, nodeText)
            end
            return nodes
        end,
        1)
}))
table.insert(snippets, grabFilename)

local pjModels = s("pjmodel", fmt([[
class {1} {{
    {2}

    constructor({3}) {{
{4}
    }}
}}

export default {1};
]], {
    f(return_filename, {}),
    i(1, "typed properties list"),
    f(function(args)
            local paramsString = ""
            for _, nodeText in ipairs(args[1]) do

                local keywordText = string.match(nodeText, "%s*([%w_]+:%s*[%w_]+)")
                nodeText = string.format("%s, ", keywordText)
                paramsString = paramsString .. nodeText

            end
            return string.sub(paramsString, 1, -3)
        end,
        1),
    f(function(args)
            local nodes = {}
            for _, nodeText in ipairs(args[1]) do

                local keywordText = string.match(nodeText, "%s*([^%s]+):.*")
                nodeText = string.format("      this.%s = %s;", keywordText, keywordText)

                table.insert(nodes, nodeText)
            end
            return nodes
        end,
        1)
}))
table.insert(snippets, pjModels)

local thisProperty = s("thp", fmt([[
this.{1} = {2};
]], {
    i(1, "property_name"),
    f(function(args)
        return args[1][1]
    end, 1),
}))
table.insert(snippets, thisProperty)

-- End Refactoring --

return snippets, autosnippets
