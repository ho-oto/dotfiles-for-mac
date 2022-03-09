local wezterm = require 'wezterm';
return {
    default_prog = {"zsh", "-lc", [[exec fish]]},
    font = wezterm.font("Cica"),
    font_size = 15,
    color_scheme = "Dracula",
}