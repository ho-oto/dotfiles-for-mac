local wezterm = require 'wezterm'

local ssh_domains = {}
for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(ssh_domains, {
        name = host,
        remote_address = config["hostname"],
        username = config["user"],
        ssh_option = { identityfile = config["identityfile"] },
    })
end

local keys = {
    { key = "q", mods = "CTRL", action = wezterm.action {
        ActivateKeyTable = { name = "Pane", one_shot = false, timeout_milliseconds = 10000 }
    } },
}
local key_tables = {
    Pane = {
        -- make pane
        { key = "|", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action(wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } }, pane)
        end) },
        { key = "-", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action(wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } }, pane)
        end) },
        -- move pane
        { key = "LeftArrow", action = wezterm.action { ActivatePaneDirection = "Left" } },
        { key = "RightArrow", action = wezterm.action { ActivatePaneDirection = "Right" } },
        { key = "UpArrow", action = wezterm.action { ActivatePaneDirection = "Up" } },
        { key = "DownArrow", action = wezterm.action { ActivatePaneDirection = "Down" } },
        -- resize pane
        { key = "LeftArrow", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 1 } } },
        { key = "RightArrow", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 1 } } },
        { key = "UpArrow", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 1 } } },
        { key = "DownArrow", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 1 } } },
        -- make tab
        { key = "c", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action(wezterm.action { SpawnTab = "CurrentPaneDomain" }, pane)
        end) },
        { key = "x", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action(wezterm.action { CloseCurrentTab = { confirm = false } }, pane)
        end) },
        -- move tab
        { key = "Tab", action = wezterm.action { ActivateTabRelative = 1 } },
        { key = "Tab", mods = "SHIFT", action = wezterm.action { ActivateTabRelative = -1 } },
        -- misc
        { key = "r", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action("ReloadConfiguration", pane)
        end) },
        { key = "q", action = wezterm.action { SendKey = { key = "q", mods = "CTRL" } } },
        { key = "l", action = "ShowLauncher" },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter", action = "PopKeyTable" },
    }
}

local tabbar_bg = "#282a36"
local tabbar_fg = "#f8f8f2"

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

    local foreground = "#f8f8f2"

    local background = "#44475a"
    if tab.is_active then
        background = "#ff79c6"
    elseif hover then
        background = "#ffb86c"
    end

    local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)
    if title == "" then
        title = wezterm.truncate_right(
            string.gsub(tab.active_pane.current_working_dir, "(.*[/\\])(.*)", "%2"),
            max_width
        )
    end

    local left_color = tabbar_fg
    if tab.tab_index == 0 then left_color = background end

    local text = " " .. tab.tab_index + 1 .. ": " .. title .. "  "
    if tab.tab_index ~= 0 then text = " " .. text end

    if tab.tab_index + 1 ~= #tabs then
        return {
            { Background = { Color = background } },
            { Foreground = { Color = left_color } },
            { Text = utf8.char(0xe0bc) },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = text },
            { Background = { Color = tabbar_fg } },
            { Foreground = { Color = background } },
            { Text = utf8.char(0xe0bc) }
        }
    else
        return {
            { Background = { Color = background } },
            { Foreground = { Color = left_color } },
            { Text = utf8.char(0xe0bc) },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = text },
            { Background = { Color = tabbar_fg } },
            { Foreground = { Color = background } },
            { Text = utf8.char(0xe0bc) },
            { Background = { Color = tabbar_bg } },
            { Foreground = { Color = tabbar_fg } },
            { Text = utf8.char(0xe0bc) .. " " }
        }
    end
end)

wezterm.on("update-right-status", function(window, pane)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b6)

    local color_mode = ""
    if window:active_key_table() then color_mode = "#ff5555" else color_mode = "#50fa7b" end

    local colors = { tabbar_bg, color_mode, "#6272a4", "#bd93f9", "#7c5295", "#b491c8", }

    local colors_index = 1
    local elements = {}
    local function insert_element(text)
        table.insert(elements, { Background = { Color = colors[colors_index] } })
        table.insert(elements, { Foreground = { Color = colors[colors_index + 1] } })
        table.insert(elements, { Text = SOLID_LEFT_ARROW })
        table.insert(elements, { Foreground = { Color = tabbar_fg } })
        table.insert(elements, { Background = { Color = colors[colors_index + 1] } })
        table.insert(elements, { Attribute = { Intensity = "Bold" } })
        table.insert(elements, { Text = "  " .. text .. "    " })
        colors_index = colors_index + 1
    end

    local name = window:active_key_table()
    if name then name = "mode: " .. name else name = "mode: Normal" end
    insert_element(name)

    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        cwd_uri = cwd_uri:sub(8);
        local slash = cwd_uri:find("/")
        local hostname = ""
        if slash then
            hostname = cwd_uri:sub(1, slash - 1)
            local dot = hostname:find("[.]")
            if dot then hostname = hostname:sub(1, dot - 1) end
            insert_element(hostname)
        end
    end

    local date = wezterm.strftime("%a %b %-d %H:%M")
    insert_element(date)

    window:set_right_status(wezterm.format(elements))
end);

local font = wezterm.font_with_fallback({
    "UDEV Gothic NF", "HackGenNerd", "Cica", "JetBrains Mono", "Fira Code"
})

return {
    default_prog = { "zsh", "-lc", [[exec fish]] },
    font = font,
    font_size = 14,
    scrollback_lines = 10000,
    initial_rows = 32,
    initial_cols = 250,
    -- tab_bar_at_bottom = true,
    color_scheme = "Dracula",
    window_background_opacity = 0.9,
    ssh_domains = ssh_domains,
    keys = keys,
    key_tables = key_tables,
    -- use_fancy_tab_bar = true,
    -- window_frame = { inactive_tabbar_bg = tabbar_bg },
    use_fancy_tab_bar = false,
    colors = {
        tab_bar = { background = tabbar_bg },
    }
}
