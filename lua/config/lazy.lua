local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.angular" },
        { import = "lazyvim.plugins.extras.linting.eslint" },
        { import = "lazyvim.plugins.extras.test.core" },
        -- edgy must be imported before the extras that integrate with it (aerial, overseer)
        { import = "lazyvim.plugins.extras.ui.edgy" },
        -- Debugging (js-debug-adapter comes from the typescript extra)
        { import = "lazyvim.plugins.extras.dap.core" },
        -- Code navigation
        { import = "lazyvim.plugins.extras.editor.aerial" },
        { import = "lazyvim.plugins.extras.editor.illuminate" },
        { import = "lazyvim.plugins.extras.ui.treesitter-context" },
        { import = "lazyvim.plugins.extras.editor.inc-rename" },
        -- Editing helpers
        { import = "lazyvim.plugins.extras.coding.mini-surround" },
        { import = "lazyvim.plugins.extras.coding.neogen" },
        { import = "lazyvim.plugins.extras.editor.refactoring" },
        { import = "lazyvim.plugins.extras.coding.yanky" },
        -- Workflow
        { import = "lazyvim.plugins.extras.editor.overseer" },
        -- Treesitter parsers for git files (commit messages, rebase, .gitignore)
        { import = "lazyvim.plugins.extras.lang.git" },
        { import = "plugins" },
    },
    defaults = {
        -- Custom plugins load at startup unless they set their own event/cmd/ft
        lazy = false,
        -- Many plugins ship outdated releases; track the latest commit instead
        version = false,
    },
    install = { colorscheme = { "catppuccin" } },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
