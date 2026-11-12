return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- angularls itself is enabled by the lang.angular extra
                angularls = {
                    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
                },
                groovyls = {
                    capabilities = {
                        general = { positionEncodings = { "utf-16" } },
                    },
                },
            },
        },
    },

    -- Formatting: lvim only registered prettier for these filetypes
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
            },
        },
    },
    {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "prettier", "groovy-language-server" } },
    },

    -- Tests (keys follow the lvim <leader>t group)
    { "nvim-neotest/neotest-jest" },
    {
        "nvim-neotest/neotest",
        dependencies = { "antoinemadec/FixCursorHold.nvim" },
        opts = {
            adapters = {
                ["neotest-jest"] = {
                    jestCommand = "npm test --",
                },
            },
        },
        keys = {
            { "<leader>tr", function() require("neotest").run.run() end,                                desc = "Run" },
            { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,             desc = "Run (file)" },
            { "<leader>ts", function() require("neotest").run.stop() end,                              desc = "Stop" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,           desc = "Debug" },
            { "<leader>to", "<cmd>Neotest output-panel<cr>",                                           desc = "Output Window" },
            { "<leader>tO", "<cmd>Neotest summary<cr>",                                                desc = "Summary Window" },
            -- Moved to make room for the bindings above
            { "<leader>tS", false },
        },
    },

    -- Debug a package.json script (e.g. `start`) instead of a single file. js-debug attaches
    -- to the node processes the script spawns. Appended after the typescript extra's
    -- "Launch file"/"Attach" defaults, which it only registers when a filetype has no configs.
    {
        "mfussenegger/nvim-dap",
        opts = function()
            local dap = require("dap")

            local function package_manager()
                local cwd = vim.fn.getcwd()
                if vim.uv.fs_stat(cwd .. "/pnpm-lock.yaml") then
                    return "pnpm"
                elseif vim.uv.fs_stat(cwd .. "/yarn.lock") then
                    return "yarn"
                end
                return "npm"
            end

            -- Asks which script to run; returns a thread so vim.ui.select can be async
            local function pick_script()
                return coroutine.create(function(dap_run_co)
                    local path = vim.fn.getcwd() .. "/package.json"
                    local ok, pkg = pcall(function()
                        return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
                    end)
                    local names = ok and vim.tbl_keys(pkg.scripts or {}) or {}
                    if #names == 0 then
                        vim.notify("No scripts found in " .. path, vim.log.levels.WARN)
                        coroutine.resume(dap_run_co, dap.ABORT)
                        return
                    end
                    table.sort(names)
                    vim.ui.select(names, { prompt = "Script: " }, function(choice)
                        coroutine.resume(dap_run_co, choice and { "run", choice } or dap.ABORT)
                    end)
                end)
            end

            local config = {
                type = "pwa-node",
                request = "launch",
                name = "Launch npm script",
                runtimeExecutable = package_manager,
                runtimeArgs = pick_script,
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                sourceMaps = true,
                skipFiles = { "<node_internals>/**", "node_modules/**" },
            }
            for _, filetype in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                dap.configurations[filetype] = dap.configurations[filetype] or {}
                table.insert(dap.configurations[filetype], vim.deepcopy(config))
            end
        end,
    },
}
