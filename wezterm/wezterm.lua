local wezterm = require("wezterm")
local config = {}

config.cell_width = 0.9
config.window_frame = {
	active_titlebar_bg = "#1c1c1c",
	inactive_titlebar_bg = "#1c1c1c",
}

config.term = "wezterm"

config.cursor_blink_rate = 0
config.initial_rows = 30
config.initial_cols = 100

config.font_size = 13.0

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"corners",
})

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.colors = {
	cursor_bg = "#cccccc",
	foreground = "#eeeeee",
	background = "#1c1c1c",
	tab_bar = {
		active_tab = {
			bg_color = "#1c1c1c",
			fg_color = "#eeeeee",
		},
		inactive_tab = {
			bg_color = "#1c1c1c",
			fg_color = "#767676",
		},
	},
}

return config
