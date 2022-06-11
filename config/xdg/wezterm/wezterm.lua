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
    { key = "UpArrow", mods = "ALT", action = wezterm.action { ScrollByPage = -1 / 20 } },
    { key = "DownArrow", mods = "ALT", action = wezterm.action { ScrollByPage = 1 / 20 } },
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
        { key = "s", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action("QuickSelect", pane)
        end) },
        { key = "x", action = wezterm.action_callback(function(window, pane)
            window:perform_action("PopKeyTable", pane)
            window:perform_action("ActivateCopyMode", pane)
        end) },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter", action = "PopKeyTable" },
    }
}

local tabbar_bg = "#282a36"
local tabbar_fg = "#f8f8f2"

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local tab_index = tab.tab_index + 1
    local is_first = (tab.tab_index == 0)
    local is_last = (tab.tab_index == #tabs - 1)

    -- powerline glyph (upper left triangle)
    local separator = utf8.char(0xe0bc)

    local tab_bg = "#44475a"
    if hover then tab_bg = "#ffb86c" end
    if tab.is_active then tab_bg = "#ff79c6" end

    -- neither first nor last
    -- text = "{separator}  {tab_index}: {title}  {separator}"
    -- max_width(text) = max_width(title) + width(tab_index) + 8
    local max_title_width = max_width - 8 - wezterm.column_width(tab_index)
    if is_first and is_last then
        -- first and last
        -- text = "  1: {title}  {separator}{separator} "
        -- max_width(text) = max_width(title) + 10
        max_title_width = max_width - 10
    elseif is_first then
        -- first and not last
        -- text = "  1: {title}  {separator}"
        -- max_width(text) = max_width(title) + 8
        max_title_width = max_width - 8
    elseif is_last then
        -- last and not first
        -- text = "{separator}  {tab_index}: {title}  {separator}{separator} "
        -- max_width(text) = max_width(title) + width(tab_index) + 10
        max_title_width = max_width - 10 - wezterm.column_width(tab_index)
    end

    local title = tab.active_pane.title
    if title == "" then
        title = string.gsub(tab.active_pane.current_working_dir, "(.*[/\\])(.*)", "%2")
    end
    title = wezterm.truncate_right(title, max_title_width)

    local text = "  " .. tab_index .. ": " .. title .. "  "
    if not is_first then text = separator .. text end

    local elements = {
        { Background = { Color = tab_bg } },
        { Foreground = { Color = tabbar_fg } },
        { Text = text },
        { Background = { Color = tabbar_fg } },
        { Foreground = { Color = tab_bg } },
        { Text = separator },
    }
    if is_last then
        table.insert(elements, { Background = { Color = tabbar_bg } })
        table.insert(elements, { Foreground = { Color = tabbar_fg } })
        table.insert(elements, { Text = separator .. " " })
    end

    return elements
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
    -- shell
    default_prog = { "zsh", "-lc", [[exec fish]] },
    -- key config
    keys = keys,
    key_tables = key_tables,
    -- ssh domains
    ssh_domains = ssh_domains,
    -- appearance
    font = font,
    font_size = 14,
    initial_rows = 32,
    initial_cols = 250,
    color_scheme = "Dracula",
    colors = { tab_bar = { background = tabbar_bg } },
    window_decorations = "RESIZE",
    window_background_opacity = 0.8,
    inactive_pane_hsb = { saturation = 0.25, brightness = 0.25 },
    use_fancy_tab_bar = false,
    tab_max_width = 24,
    -- misc
    scrollback_lines = 10000,
}
