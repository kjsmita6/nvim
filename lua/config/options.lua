-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.termguicolors = true

local is_windows = vim.fn.has("win32") == 1

if is_windows then
    -- Enable powershell as your default shell
    vim.opt.shell = "pwsh.exe"
    vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.cmd [[
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
]]

    -- Set a compatible clipboard manager
    vim.g.clipboard = {
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
    }
end

-- Undo/backup
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.fn.mkdir(vim.fn.stdpath("data") .. "/backup", "p")

-- Spacing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.wrap = true

-- <Left>/<Right> wrap to the previous/next line at the line boundaries
-- ("<" and ">" for normal/visual, "[" and "]" for insert/replace)
vim.opt.whichwrap:append("<,>,[,]")

-- Options from old .vimrc
vim.opt.ruler = true
vim.opt.lazyredraw = false
vim.opt.foldcolumn = "1"
vim.opt.showcmd = true

-- lvim never formatted on save (format_on_save was off), so keep it off.
-- Format manually with <leader>lf / <leader>cf, or toggle with <leader>uf.
vim.g.autoformat = false
