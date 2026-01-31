-- https://wezterm.org/config/files.html

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- Font
config.font_size = 12
config.font = wezterm.font 'FiraMono Nerd Font'

config.window_frame = {
    --font = wez.font({ family = 'PayPal Sans Big' }),
    --font_size = 16,
}

config.audible_bell = "Disabled"

-- disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.color_scheme = 'Classic Dark (base16)'
-- Classic Dark (base16) is used in Alacritty
--config.default_prog = { '/Users/tmfink/.nix-profile/bin/fish', '-l' }

-- box drawing characters are used to draw tmux panes
local box_drawing_str = ""
for code = 0x2500, 0x257F do
  box_drawing_str = box_drawing_str .. utf8.char(code)
end
config.selection_word_boundary = " \t\n{}[]()\"'`;:" .. box_drawing_str

config.window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
}

-- https://wezterm.org/config/keys.html
-- Show defaults: wezterm show-keys --lua
config.keys = {
    -- Tabs
    { key = 'LeftArrow',  mods = 'SUPER',       action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER',       action = act.ActivateTabRelative(1) },
    { key = 'LeftArrow',  mods = 'SHIFT|SUPER', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SHIFT|SUPER', action = act.MoveTabRelative(1) },
    {
        key = 'I',
        mods = 'SHIFT|SUPER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, _pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },

    -- Window
    { key = 'F11', action = wezterm.action.ToggleFullScreen },

    -- Splits (tmux-like)
    {
        key = '%',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = '"',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },

    -- Splits (terminator-like)
    {
        key = 'O',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = 'E',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },

    -- Pane focus (arrows)
    {
        key = 'LeftArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Down',
    },

    -- Pane focus (vi keys)
    {
        key = 'h',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Down',
    },

    -- Pane resize
    { key = 'H', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
    { key = 'L', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'K', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'J', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
}

-- https://www.reddit.com/r/wezterm/comments/10jda7o/is_there_a_way_not_to_open_urls_on_simple_click/
config.mouse_bindings = {
    -- Disable the default click behavior
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wezterm.action.DisableDefaultAssignment,
    },
    -- Ctrl-click will open the link under the mouse cursor
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.Nop,
    },
    -- Triple click selects command output
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'SHIFT',
    },
}

return config
