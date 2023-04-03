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
local l = require("luasnip.extras").lambda

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
    d(2, function(args)
            local paramsNodes = {}

            local function getNodeText(nodeText)
                local keywordText = string.match(nodeText, "%s*([%w_]+:%s*[%w_]+)")
                nodeText = string.format("%s, ", keywordText)

                return nodeText
            end

            for index, nodeText in ipairs(args[1]) do
                nodeText = getNodeText(nodeText)


                local choiceNode = c(index, {
                    t(nodeText),
                    t(""),
                })

                table.insert(paramsNodes, choiceNode)
            end
            return sn(nil, paramsNodes)
        end,
        { 1 }),
    d(3, function(args)
            local propertyNodes = {}
            local jumpIndex = 1

            for _, nodeText in ipairs(args[1]) do
                local keyword = string.match(nodeText, "%s*([^%s]+):.*")

                if keyword == nil then
                    keyword = "type a variable"
                end

                if string.find(args[2][1], keyword) == nil then
                    table.insert(propertyNodes, t({ "", string.format("        this.%s = ", keyword)
                    }))
                    table.insert(propertyNodes, c(jumpIndex, {
                        t("null"),
                        i(1, "inicialize property")
                    }))
                    table.insert(propertyNodes, t(";"))
                    jumpIndex = jumpIndex + 1
                else
                    table.insert(propertyNodes, t({ "", string.format("        this.%s = %s;", keyword, keyword)
                    }))
                end
            end
            table.insert(propertyNodes, t({ "", "" }))
            return sn(nil, propertyNodes)
        end,
        { 1, 2 })
}))
table.insert(snippets, pjModels)

local pjRepository = s("pjrepository", fmt([[
import {1} from "../models/{1}";

class {2} {{
    private {3}: {1}[];

    constructor() {{
        this.{3} = [];
    }}

    {4}

}}

export default {2};
]], {
    f(function()
        local filename = return_filename()
        local modelName = filename:match("(.*)sRepository")
        return modelName
    end, {}),
    f(return_filename, {}),
    f(function()
        local filename = return_filename()
        local propertyName = filename:match("(.*)sRepository"):lower() .. "s"
        return propertyName
    end, {}),
    i(1, "// type the repo methods")
}))
table.insert(snippets, pjRepository)

local publicMethod = s("pubmethod", fmt([[
public {1}({2}): {3} {{
    {4}
}}
]], {
    i(1, "/* method name */"),
    i(2, "/* params */"),
    c(3, {
        t("void"),
        i(1, "/* method return type */")
    }),
    i(4, "// code"),
}))
table.insert(snippets, publicMethod)

local privateMethod = s("primethod", fmt([[
private {1}({2}): {3} {{
    {4}
}}
]], {
    i(1, "/* method name */"),
    i(2, "/* params */"),
    c(3, {
        t("void"),
        i(1, "/* method return type */")
    }),
    i(4, "// code"),
}))
table.insert(snippets, privateMethod)

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
