require 'squib'
require 'game_icons'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
File.open('data/opportunities.txt', 'w+') { |f| f.write data.to_pretty_text }

Squib::Deck.new(cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/opportunities.yml'

  text str: data.name, layout: :name

  %w(Consume1 Consume2 Store1 Store2 Required1 Required2).each do |col|
    data["#{col}SVG"] = data["#{col}Icon"].map do |icon|
      unless icon.to_s.empty?
        GameIcons.get(icon).recolor(fg: 'fff', bg: '000', bg_opacity: 0).string
      end
    end
    # Draw these UI frames only if the column is not nil
    # UGH. Looks like a bug in Squib. svg's layout isn't properly supporting expansion
    svgfile = "bw/#{col.downcase[0..-2]}.svg" # e.g. Store2 --> store.svg
    svg layout: "#{col}Frame",
        file: data["#{col}Icon"].map { |x| x.to_s.empty? ? nil : svgfile }
    svg data: data["#{col}SVG"], layout: "#{col}Icon"
    text str: data[col], layout: col
  end

  %w(Action1 Action2 Action3).each do |col|
    svg file: data[col].map {|a| a.nil? ? nil : 'bw/action.svg'},
        layout: "#{col}Frame"
    text str: data[col], layout: col
  end

  svg file: data.buff_type.map { |b| b.nil? ? nil : 'bw/buff.svg' },
      layout: :BuffFrame
  text str: data.buff_type, layout: :BuffType

  text str: data.tags, layout: :tags

  text str: ProjectRuin::VERSION, layout: :version

  # enable_build :proofs
  build(:proofs) do
    safe_zone
    cut_zone
  end

  save prefix: 'opportunity_', format: :png
  save prefix: 'opportunity_preview_', format: :png, trim: '0.125in', trim_radius: '0.125in'

  cut_zone
  save_sheet prefix: 'opportunity_sheet_', columns: 8,
             trim: '0.125in', trim_radius: '0.125in'
end
