local M = {}

-- Returns the trimmed stdout of a command, or nil if it is missing or fails
local function cmd_output(cmd)
    if vim.fn.executable(cmd[1]) ~= 1 then
        return nil
    end
    local out = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        return nil
    end
    return vim.trim(out)
end

function M.system_is_dark()
    if vim.fn.has("mac") == 1 then
        -- prints "Dark" in dark mode; exits non-zero (key missing) in light mode
        local out = cmd_output({ "defaults", "read", "-g", "AppleInterfaceStyle" })
        return out ~= nil and out:match("Dark") ~= nil
    elseif vim.fn.has("unix") == 1 then
        -- Cinnamon (Mint). The keys don't exist on other desktops, so the commands fail
        -- and this falls through to light. org.gnome.desktop.interface color-scheme is
        -- deliberately not used: on Mint it stays 'prefer-dark' even in light mode.
        local scheme = cmd_output({ "gsettings", "get", "org.x.apps.portal", "color-scheme" })
        if scheme and scheme:match("prefer%-dark") then
            return true
        end
        -- Otherwise infer from the GTK theme name, e.g. 'Mint-L-Dark-Blue'
        local theme = cmd_output({ "gsettings", "get", "org.cinnamon.desktop.interface", "gtk-theme" })
        return theme ~= nil and theme:lower():match("dark") ~= nil
    end
    return false
end

-- Follow the system appearance: macchiato in dark mode, latte in light mode.
-- Detected on macOS and Linux Mint (Cinnamon); anything else falls back to latte.
function M.system_colorscheme()
    -- A remote host cannot see the SSH client's desktop appearance. Allow the
    -- launching environment to select a palette explicitly (e.g. NVIM_THEME=dark).
    local override = (vim.env.NVIM_THEME or ""):lower()
    if override == "dark" then
        return "catppuccin-macchiato"
    elseif override == "light" then
        return "catppuccin-latte"
    end

    return M.system_is_dark() and "catppuccin-macchiato" or "catppuccin-latte"
end

return M
