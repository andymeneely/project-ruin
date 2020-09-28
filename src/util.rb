def game_icon(str)
  GameIcons.get(str).recolor(fg: 'fff', bg: '000', bg_opacity: 0).string
end