local wezterm = require 'wezterm'

local config = {}


if wezterm.config_builder then
  config = wezterm.config_builder()
end


-- https://wezfurlong.org/wezterm/config/lua/keyassignment/MoveTab.html
config.keys = {}

for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end


-- https://wezfurlong.org/wezterm/config/lua/keyassignment/MoveTabRelative.html
local act = wezterm.action

config.keys = {
  { key = '{', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
}


-- config.color_scheme = 'Adventure'
-- config.color_scheme = 'One Dark (Gogh)'
config.color_scheme = 'DoomOne'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 20.0

-- config.enable_scroll_bar = true

-- ------------------------
-- Defining your own colors
-- ------------------------


------------------------------------
-- Native (Fancy) Tab Bar appearance
------------------------------------
config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'Roboto', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10. on Windows but 12.0 on other systems
  font_size = 21.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#333333',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#333333',
}

-- window.colors = {
--   tab_bar = {
--     -- The color of the inactive tab bar edge/divider
--     inactive_tab_edge = '#575757',
--   },
-- }


-- ----------------------
-- Styling Inactive Panes
-- ----------------------
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- -----------------------
-- Window Background Image
-- -----------------------
-- config.window_background_image = '/path/to/wallpaper.jpg'


-- ------------------
-- Launching Programs
-- ------------------
config.default_prog = { 'fish', '-l' }
-- config.default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },


return config
