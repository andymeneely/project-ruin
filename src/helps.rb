require 'squib'
require_relative 'version'

Squib::Deck.new(cards: 4, width: '5in', height: '3in') do
  background color: :white
  
  svg file: 'bw/help.svg'
  
  save_png prefix: 'help_'
  save_sheet prefix: 'sheet_helps_', columns: 2
end
