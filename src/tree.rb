require 'squib'
require_relative 'version'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 0
out = StringIO.new
out.puts "graph LR"

def make_edge(out, row, j)
  match = row["Consume#{j}"].to_s.match /(?<a>\d+):(?<b>\d+)/
  unless match.nil?
    ratio = '%.02f' % (match[:b].to_f / match[:a].to_f)
    a = row["Consume#{j}Resource"]
    b = row["Store#{j}Resource"]
    out.puts "    #{a} --#{ratio}--> #{b}"
  end
end

def make_req(out, row)
  [1,2].each do |i|
    [1,2].each do |j|
      if(!row["Required#{i}Resource"].to_s.empty? &&
         !row["Store#{j}Resource"].to_s.empty?)
        a = row["Required#{i}Resource"]
        b = row["Store#{j}Resource"]
        out.puts "    #{a} -.-> #{b}"
      end
    end
  end
end

(0..data.nrows).each do |i|
  row = data.row(i)
  make_edge(out, row, 1)
  make_edge(out, row, 2)
  make_req(out, row)
end

File.open('resource tree.mm', 'w') { |f| f.write out.string }
puts "Done!"
