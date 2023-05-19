local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

--LSP Mappings, handles copilot/cmp conflicts
cmp.setup({
        mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            elseif cmp.visible() then
                cmp.mapping.confirm({ select = false })
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {
        "i",
        "s",
    }),
}),

  })
