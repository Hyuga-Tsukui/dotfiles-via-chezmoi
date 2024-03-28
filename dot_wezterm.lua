local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 16.0
config.window_background_opacity = 0.6

-- config.default_prog = {"/bin/zsh", "-l", "-c", "`tmux attach -t 0 || tmux`"}

local act = wezterm.action
config.keys = {
	{
		key = "LeftArrow",
		mods = "CMD",
		action = act.SendKey {
			key = "b",
			mods = "META",
		},
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = act.SendKey {
			key = "f",
			mods = "META",
		},
	},
	{
		key = 'Backspace',
		mods = 'CTRL',
		action = act.SendKey {
			key = 'w',
			mods = 'CTRL',
		}

	},
}

return config