require 'squib'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 1

Squib::Deck.new(cards: 21, width: '2.75in', height: '1.5in') do
  background color: '#BBB'
  use_layout file: 'layouts/reasons.yml'

  svg file: data.reason1.map { |s| "bw/reasons/#{s.downcase}.svg"}, layout: :reason1
  svg file: data.reason2.map { |s| "bw/reasons/#{s.downcase}.svg"}, layout: :reason2

  text str: data.reason1, layout: :reason1text
  text str: data.reason2, layout: :reason2text

  save_png prefix: 'reason_', trim: 37.5, trim_radius: 37.5
  save_sheet prefix: 'sheet_reasons_', rows: 7, columns: 3
  save_pdf file: 'reasons.pdf'
end

Squib::Deck.new(cards: 1, width: '2.75in', height: '1.5in') do
  background color: '#BBB'
  save_png prefix: 'reason_back_'
  save_sheet prefix: 'sheet_reasons_back_', rows: 7, columns: 3
end