local wezterm = require 'wezterm'

local ssh_domains = {}

for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
    if host == "xps" then
        table.insert(ssh_domains, {
            name = host,
            remote_address = config["hostname"],
            username = config["user"],
            ssh_option = {
                identityfile = config["identityfile"]
            },
            remote_wezterm_path = "/home/linuxbrew/.linuxbrew/bin/wezterm",
            assume_shell = "Posix"
        })
    end
end

wezterm.on("update-right-status", function(window, pane)
    local name = window:active_key_table()
    if name then
        name = "mode: " .. name
    end
    window:set_right_status(name or "")
end);

return {
    default_prog = {"zsh", "-lc", [[exec fish]]},
    font = wezterm.font_with_fallback({"Cica", "JetBrains Mono", "Fira Code"}),
    font_size = 15,
    tab_bar_at_bottom = true,
    color_scheme = "Dracula",
    window_background_opacity = 0.9,
    ssh_domains = ssh_domains,
    leader = {
        key = "q",
        mods = "CTRL",
        timeout_milliseconds = 1000
    },
    keys = {{
        key = "|",
        mods = "LEADER",
        action = wezterm.action {
            SplitHorizontal = {
                domain = "CurrentPaneDomain"
            }
        }
    }, {
        key = "-",
        mods = "LEADER",
        action = wezterm.action {
            SplitVertical = {
                domain = "CurrentPaneDomain"
            }
        }
    }, {
        key = "c",
        mods = "LEADER",
        action = wezterm.action {
            SpawnTab = "CurrentPaneDomain"
        }
    }, {
        key = "x",
        mods = "LEADER",
        action = wezterm.action {
            CloseCurrentTab = {
                confirm = false
            }
        }
    }, {
        key = "q",
        mods = "LEADER",
        action = wezterm.action {
            ActivateKeyTable = {
                name = "pane",
                one_shot = false,
                timeout_milliseconds = 5000
            }
        }
    }, {
        key = "q",
        mods = "LEADER|CTRL",
        action = wezterm.action {
            SendKey = {
                key = "q",
                mods = "CTRL"
            }
        }
    }},
    key_tables = {
        pane = {{
            key = "LeftArrow",
            action = wezterm.action {
                ActivatePaneDirection = "Left"
            }
        }, {
            key = "RightArrow",
            action = wezterm.action {
                ActivatePaneDirection = "Right"
            }
        }, {
            key = "UpArrow",
            action = wezterm.action {
                ActivatePaneDirection = "Up"
            }
        }, {
            key = "DownArrow",
            action = wezterm.action {
                ActivatePaneDirection = "Down"
            }
        }, {
            key = "LeftArrow",
            mods = "SHIFT",
            action = wezterm.action {
                AdjustPaneSize = {"Left", 1}
            }
        }, {
            key = "RightArrow",
            mods = "SHIFT",
            action = wezterm.action {
                AdjustPaneSize = {"Right", 1}
            }
        }, {
            key = "UpArrow",
            mods = "SHIFT",
            action = wezterm.action {
                AdjustPaneSize = {"Up", 1}
            }
        }, {
            key = "DownArrow",
            mods = "SHIFT",
            action = wezterm.action {
                AdjustPaneSize = {"Down", 1}
            }
        }, {
            key = "Escape",
            action = "PopKeyTable"
        }}
    }

}
