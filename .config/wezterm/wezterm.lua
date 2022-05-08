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
            assume_shell = "Posix",
        })
    end
end

return {
    default_prog = {"zsh", "-lc", [[exec fish]]},
    font = wezterm.font("Cica"),
    font_size = 15,
    tab_bar_at_bottom = true,
    color_scheme = "Dracula",
    window_background_opacity = 0.9,
    ssh_domains = ssh_domains,
}
