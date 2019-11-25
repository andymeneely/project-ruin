require 'squib'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0

Squib::Deck.new(cards: data.nrows) do
  background color: :white
  use_layout file: 'layouts/opportunities.yml'

  text str: data.name, layout: :name

  text str: data.atk.map { |s| "#{s} ATK" }, layout: :ATK
  text str: data.def.map { |s| "#{s} DEF" }, layout: :DEF

  text str: MySquibGame::VERSION, layout: :version

  build(:proofs) do
    safe_zone
    cut_zone
  end

  save format: :png
end
