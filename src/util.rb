def game_icon(str)
  GameIcons.get(str).recolor(fg: 'fff', bg: '000', bg_opacity: 0).string
end


module Squib
  module ArrayExtras
    refine Array do
      def dot_svg
        self.map { |s| "#{s.downcase}.svg" }
      end
    end
  end
end
