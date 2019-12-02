require 'squib'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
out = StringIO.new
out.puts "graph LR"

def make_edge(out, row, j)
  match = row["Consume#{j}"].to_s.match /(?<a>\d+):(?<b>\d+)/
  unless match.nil?
    ratio = '%.02f' % (match[:b].to_f / match[:a].to_f)
    a = row["Consume#{j}Icon"]
    b = row["Store#{j}Icon"]
    out.puts "    #{a} --#{ratio}--> #{b}"
  end
end

(0..data.nrows).each do |i|
  row = data.row(i)
  make_edge(out, row, 1)
  make_edge(out, row, 2)
end

File.open('resource tree.mm', 'w') { |f| f.write out.string }
puts "Done!"
