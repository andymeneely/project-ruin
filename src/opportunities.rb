require 'squib'
require 'game_icons'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
File.open('data/opportunities.txt', 'w+') { |f| f.write data.to_pretty_text }

def game_icon(str)
  GameIcons.get(str).recolor(fg: 'fff', bg: '000', bg_opacity: 0).string
end

icon = {
  'cars'            => game_icon('city-car'),
  'destroyers'      => game_icon('spaceship'),
  'doctrine'        => game_icon('enlightenment'),
  'energy'          => game_icon('electric'),
  'engineers'       => game_icon('pencil-ruler'),
  'fighters'        => game_icon('interceptor-ship'),
  'interpretations' => game_icon('archive-research'),
  'linguist'        => game_icon('read'),
  'managers'        => game_icon('tie'),
  'minerals'        => game_icon('ore'),
  'officers'        => game_icon('rank-3'),
  'recons'          => game_icon('binoculars'),
  'runes'           => game_icon('rune-stone'),
  'soldiers'        => game_icon('corporal'),
  'theologian'      => game_icon('moebius-triangle'),
  'vulnerabilities' => game_icon('cracked-shield'),
  'workers'         => game_icon('miner'),
  'writings'        => game_icon('files'),
}

Squib::Deck.new(cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/opportunities.yml'

  text str: data.name, layout: :name

  # Draw these UI frames only if the column is not nil
  # UGH. Looks like a bug in Squib. svg's layout isn't properly supporting expansion
  text str: data.consume1, layout: :Consume1
  text str: data.consume1resource, layout: :Consume1ResourceText
  svg layout: :Consume1Frame,
      file: data.consume1resource.map { |r| r.to_s.empty? ? nil : 'bw/consume.svg' }
  svg data: data.consume1resource.map { |r| icon[r] },
      layout: :Consume1Resource

  text str: data.consume2, layout: :Consume2
  text str: data.consume2resource, layout: :Consume2ResourceText
  svg layout: :Consume2Frame,
      file: data.consume2resource.map { |r| r.to_s.empty? ? nil : 'bw/consume.svg' }
  svg data: data.consume2resource.map { |r| icon[r] },
      layout: :Consume2Resource

  text str: data.store1, layout: :Store1
  text str: data.store1resource, layout: :Store1ResourceText
  svg layout: :Store1Frame,
      file: data.store1resource.map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data.store1resource.map { |r| icon[r] }, layout: :Store1Resource

  text str: data.store2, layout: :Store2
  text str: data.store2resource, layout: :Store2ResourceText
  svg layout: :Store2Frame,
      file: data.store2resource.map { |r| r.to_s.empty? ? nil : 'bw/store.svg' }
  svg data: data.store2resource.map { |r| icon[r] }, layout: :Store2Resource

  text str: data.required1, layout: :Required1
  text str: data.required1resource, layout: :Required1ResourceText
  svg layout: :Required1Frame,
      file: data.required1resource.map { |r| r.to_s.empty? ? nil : 'bw/required.svg' }
  svg data: data.required1resource.map { |r| icon[r] },
      layout: :Required1Resource

  text str: data.required2, layout: :Required2
  text str: data.required2resource, layout: :Required2ResourceText
  svg layout: :Required2Frame,
      file: data.required2resource.map { |r| r.to_s.empty? ? nil : 'bw/required.svg' }
  svg data: data.required2resource.map { |r| icon[r] },
      layout: :Required2Resource

  %w(Action1 Action2 Action3).each do |col|
    svg file: data[col].map {|a| a.nil? ? nil : 'bw/action.svg'},
        layout: "#{col}Frame"
    text str: data[col], layout: col
  end

  svg file: data.buff_type.map { |b| b.nil? ? nil : 'bw/buff.svg' },
      layout: :BuffFrame
  text str: data.buff_type, layout: :BuffType

  svg file: data.buff_action.map {|a| a.nil? ? nil : 'bw/buff-action.svg'},
      layout: "BuffActionFrame"
  text str: data.buff_action, layout: :BuffAction

  text str: data.tags, layout: :tags

  text str: ProjectRuin::VERSION, layout: :version

  # enable_build :proofs
#   build(:proofs) do
    # safe_zone
    cut_zone
#   end

  save_png prefix: 'opportunity_preview_',
           trim: '0.125in', trim_radius: '0.125in'

#   build :pdf do
   save_pdf file: 'opportunities_pnp.pdf', trim: '0.125in'
#   end

  cut_zone
  save_sheet prefix: 'opportunity_sheet_widescreen_', columns: 12,
             trim: '0.125in', trim_radius: '0.125in'
  save_sheet prefix: 'opportunity_sheet_portrait_', columns: 2,
             trim: '0.125in', trim_radius: '0.125in'

end
