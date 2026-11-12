-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- <leader>l is the LSP group here (LazyVim uses it for :Lazy, which is still available via :Lazy)
pcall(vim.keymap.del, "n", "<leader>l")

-- Drop LazyVim's duplicates of keys that also live in a group:
-- <leader>` = <leader>bb, <leader>- = <leader>ws, <leader>| = <leader>wv
-- and the rarely used <leader>K (keywordprg) and <leader>L (LazyVim changelog)
for _, lhs in ipairs({ "<leader>`", "<leader>-", "<leader>|", "<leader>K", "<leader>L" }) do
    pcall(vim.keymap.del, "n", lhs)
end

-- Toggle comment (gc comes from Neovim's built-in commenting)
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle Comment" })

-- Landing page (lvim had this on <leader>; via Alpha)
map("n", "<leader>;", function() Snacks.dashboard() end, { desc = "Dashboard" })

-- Files and search. <leader>f stays LazyVim's file/find group.
map("n", "<leader>r", function() LazyVim.pick("files")() end, { desc = "Find Files" })
map("n", "<leader>fs", "/", { desc = "Find (search in buffer)" })

-- LSP
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
map("n", "<leader>lf", function() LazyVim.format({ force = true }) end, { desc = "Format" })
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Show Hover" })
map("n", "<leader>lI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
map("n", "<leader>lo", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols" })
map("n", "<leader>lr", vim.lsp.buf.references, { desc = "Go to References" })
map("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>lx", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })

require("which-key").add({
    { "<leader>l", group = "LSP" },
})

-- :OrganizeImports (was defined on the tsserver client in lvim)
vim.api.nvim_create_user_command("OrganizeImports", function()
    LazyVim.lsp.action["source.organizeImports"]()
end, { desc = "Organize Imports" })
