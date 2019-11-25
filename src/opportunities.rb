require 'squib'
require 'game_icons'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
File.open('data/opportunities.txt', 'w+') { |f| f.write data.to_pretty_text }

Squib::Deck.new(cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/opportunities.yml'

  text str: data.name, layout: :name

  svg file: 'bw/opportunity.svg', width: :deck, height: :deck

  %w(Consume1 Consume2 Required1 Required2).each do |col|
    data["#{col}SVG"] = data["#{col}Icon"].map do |icon|
      unless icon.to_s.empty?
        GameIcons.get(icon).recolor(fg: '000', bg_opacity: 0).string
      end
    end
    svg data: data["#{col}SVG"], layout: "#{col}Icon"
    text str: data[col], layout: col
  end

  text str: data.action1, layout: :Action1
  text str: data.tags, layout: :tags

  text str: ProjectRuin::VERSION, layout: :version

  # enable_build :proofs
  build(:proofs) do
    safe_zone
    cut_zone
  end

  save prefix: 'opportunity_', format: :png
  save prefix: 'opportunity_preview_', format: :png, trim: '0.125in', trim_radius: '0.125in'
end
