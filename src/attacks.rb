require 'squib'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 1

Squib::Deck.new(cards: 21) do
  background color: :gray
  use_layout file: 'layouts/attack.yml'
  svg file: 'bw/attack.svg'

  text str: data.attack_name, layout: :name
  text str: 'Attack', layout: :type

  svg file: data.reason1.map { |s| "bw/reasons/#{s.downcase}.svg"}, layout: :reason1
  svg file: data.reason2.map { |s| "bw/reasons/#{s.downcase}.svg"}, layout: :reason2

  # text str: data.reason1, layout: :reason1text
  # text str: data.reason2, layout: :reason2text

  text str: data.d20, layout: :d20
  text str: data.d12, layout: :d12
  text str: data.d8, layout: :d8
  text str: data.d6, layout: :d6

  text str: data.endgame_name.map { |s| "Crisis: #{s}"}, layout: :endgame_name


  save_png prefix: 'attack_', trim: 37.5, trim_radius: 37.5
  save_sheet prefix: 'sheet_attacks_', rows: 7, columns: 3
  save_pdf file: 'attacks.pdf'
end
