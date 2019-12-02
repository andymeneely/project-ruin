require 'squib'
require 'game_icons'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
File.open('data/opportunities.txt', 'w+') { |f| f.write data.to_pretty_text }

def game_icon(str)
  GameIcons.get(str).recolor(fg: 'fff', bg: '000', bg_opacity: 0).string
end

icon = {
  'cars'       => game_icon('city-car'),
  'destroyers' => game_icon('spaceship'),
  'energy'     => game_icon('electric'),
  'engineers'  => game_icon('pencil-ruler'),
  'fighters'   => game_icon('interceptor-ship'),
  'linguist'   => game_icon('read'),
  'managers'   => game_icon('tie'),
  'minerals'   => game_icon('ore'),
  'officers'   => game_icon('rank-3'),
  'soldiers'   => game_icon('corporal'),
  'theologian' => game_icon('moebius-triangle'),
  'workers'    => game_icon('miner'),
}

Squib::Deck.new(cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/opportunities.yml'

  text str: data.name, layout: :name


  # Draw these UI frames only if the column is not nil
  # UGH. Looks like a bug in Squib. svg's layout isn't properly supporting expansion
  text str: data["Consume1"], layout: :Consume1
  svg layout: "Consume1Frame",
      file: data["Consume1Resource"].map { |r| r.to_s.empty? ? nil : 'bw/consume.svg' }
  svg data: data["Consume1Resource"].map { |r| icon[r] },
      layout: :Consume1Resource
  text str: data["Consume2"], layout: :Consume2
  svg layout: "Consume2Frame",
      file: data["Consume2Resource"].map { |r| r.to_s.empty? ? nil : 'bw/consume.svg' }
  svg data: data["Consume2Resource"].map { |r| icon[r] },
      layout: :Consume2Resource

  text str: data["Store1"], layout: :Store1
  svg layout: "Store1Frame",
      file: data["Store1Resource"].map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data["Store1Resource"].map { |r| icon[r] }, layout: :Store1Resource
  text str: data["Store2"], layout: :Store2
  svg layout: "Store2Frame",
      file: data["Store2Resource"].map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data["Store2Resource"].map { |r| icon[r] }, layout: :Store2Resource

  text str: data["Required1"], layout: :Required1
  svg layout: "Required1Frame",
      file: data["Required1Resource"].map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data["Required1Resource"].map { |r| icon[r] },
      layout: :Required1Resource
  text str: data["Required2"], layout: :Required2
  svg layout: "Required2Frame",
      file: data["Required2Resource"].map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data["Required2Resource"].map { |r| icon[r] },
      layout: :Required2Resource

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

  save_png prefix: 'opportunity_preview_',
           trim: '0.125in', trim_radius: '0.125in'

  cut_zone
  save_sheet prefix: 'opportunity_sheet_widescreen_', columns: 12,
             trim: '0.125in', trim_radius: '0.125in'
  save_sheet prefix: 'opportunity_sheet_portrait_', columns: 2,
             trim: '0.125in', trim_radius: '0.125in'
end
