return {
    { "nvim-tree/nvim-web-devicons", opts = {} },

    -- Detect tabs/spaces and indentation width from each file's contents.
    { "tpope/vim-sleuth", event = "BufReadPost" },

    -- Make completion opt-in: Ctrl+Space opens the list, arrows choose, Enter accepts.
    {
        "saghen/blink.cmp",
        opts = {
            completion = {
                menu = { auto_show = false },
                list = {
                    selection = { preselect = false, auto_insert = false },
                },
            },
            keymap = {
                preset = "enter",
                ["<C-space>"] = { "show" },
            },
        },
    },

    -- Splits
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        keys = {
            { "<M-S-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize Left" },
            { "<M-S-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize Right" },
            { "<M-S-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize Up" },
            { "<M-S-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize Down" },
            { "<S-Left>",    function() require("smart-splits").move_cursor_left() end,  desc = "Move to Left Split" },
            { "<S-Right>",   function() require("smart-splits").move_cursor_right() end, desc = "Move to Right Split" },
            { "<S-Up>",      function() require("smart-splits").move_cursor_up() end,    desc = "Move to Upper Split" },
            { "<S-Down>",    function() require("smart-splits").move_cursor_down() end,  desc = "Move to Lower Split" },
        },
    },

    -- Buffers
    {
        "akinsho/bufferline.nvim",
        keys = {
            { "<M-Left>",  "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<M-Right>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            highlight = {
                enable = true,
                disable = { "robot" },
            },
        },
    },

    -- Peek definitions in a floating window
    {
        "rmagatti/goto-preview",
        opts = {
            width = 120,              -- Width of the floating window
            height = 25,              -- Height of the floating window
            default_mappings = false, -- Bind default mappings
            debug = false,            -- Print debug information
            opacity = nil,            -- 0-100 opacity level of the floating window where 100 is fully transparent.
            post_open_hook = nil,     -- A function taking two arguments, a buffer and a window to be ran as a hook.
        },
    },

    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        },
    },

    -- Sessions
    {
        "folke/persistence.nvim",
        opts = {
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
            options = { "buffers", "curdir", "tabpages", "winsize" },
        },
        keys = {
            { "<leader>S",  "",                                                        desc = "+Session" },
            { "<leader>Sc", function() require("persistence").load() end,              desc = "Restore last session for current dir" },
            { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
            { "<leader>SQ", function() require("persistence").stop() end,              desc = "Quit without saving session" },
            -- Replaced by the Session group above
            { "<leader>qs", false },
            { "<leader>qS", false },
            { "<leader>ql", false },
            { "<leader>qd", false },
        },
    },

    -- Diagnostics (keep the lvim bindings: x is the current buffer, X the workspace)
    {
        "folke/trouble.nvim",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",  desc = "Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",               desc = "Diagnostics (workspace)" },
            { "<leader>xo", "<cmd>Trouble symbols toggle focus=false<cr>",       desc = "Symbols" },
        },
    },

    { "pixelastic/vim-undodir-tree" },

    { "mfukar/robotframework-vim", ft = "robot" },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = {
                comments = { "#", "//" },
                delimiter = {
                    ft = {
                        csv = ",",  -- Always use comma for .csv files
                        tsv = "\t", -- Always use tab for .tsv files
                    },
                    fallbacks = {   -- Try these delimiters in order for other files
                        ",",        -- Comma (most common)
                        "\t",       -- Tab
                        ";",        -- Semicolon
                        "|",        -- Pipe
                        ":",        -- Colon
                        " ",        -- Space
                    },
                },
            },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
            view = {
                header_lnum = true, -- Auto-detect header (default)
                sticky_header = {
                    enabled = true,
                    separator = "─", -- Separator line character
                },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        opts = {},
    },

    -- The refactoring extra puts its keys under <leader>r, which is Find Files here
    -- (see config/keymaps.lua), so move them to <leader>R.
    {
        "ThePrimeagen/refactoring.nvim",
        keys = function(_, keys)
            local moved = {}
            for _, key in ipairs(keys) do
                key = vim.deepcopy(key)
                if key[1]:find("^<leader>r") then
                    key[1] = "<leader>R" .. key[1]:sub(10)
                end
                moved[#moved + 1] = key
            end
            return moved
        end,
    },
}
