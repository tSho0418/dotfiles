local wezterm = require("wezterm")
-- この設定ファイル自身のディレクトリから keybinds.lua を読む (WSL 側リポジトリを直接参照するため)
package.path = (wezterm.config_file:match("^(.*)[/\\]") or wezterm.config_dir) .. "/?.lua;" .. package.path
local config = wezterm.config_builder()

config.default_domain = 'WSL:Ubuntu'


config.automatically_reload_config = true
config.font_size = 11.0
config.use_ime = true


config.color_scheme = 'Tokyo Night'
config.term = "xterm-256color"

config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.scrollback_lines = 10000
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }
config.adjust_window_size_when_changing_font_size = false


config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600
-- config.window_background_opacity = 0.85
-- config.macos_window_background_blur = 20
config.window_background_opacity = 0.9
-- config.win32_system_backdrop = 'Acrylic'
config.win32_system_backdrop = 'Disable'
config.audible_bell = "Disabled"
----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = false
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  font = wezterm.font('SF Mono'),
  font_size = 10,
  inactive_titlebar_bg = "#1a1b26",
  active_titlebar_bg = "#1a1b26",
}

-- タブバーを背景色に合わせる
-- -- config.window_background_gradient = {
--   colors = { "#000000" },
-- }

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
-- config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

local function tab_title(tab)
  local t = tab.tab_title      -- set_title で付けた名前
  if t and #t > 0 then
    return t                   -- あればそれを使う
  end
  return tab.active_pane.title -- 無ければ従来どおりペインのタイトル
end

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

local LEFT_CIRCLE = utf8.char(0xe0b6)
local RIGHT_CIRCLE = utf8.char(0xe0b4)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#454545"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#2d6ac0"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab_title(tab), max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = LEFT_CIRCLE },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = RIGHT_CIRCLE },
  }
end)

config.font = wezterm.font_with_fallback {
  'SF Mono',
  'Symbols Nerd Font Mono', -- powerline/タブの丸グリフ用
  'PlemolJP Console NF',    -- 日本語 + Nerdフォント（HackGen等でも可）
}

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
