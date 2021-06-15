require 'squib'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 2 do |_h, v|
  if v.respond_to? :gsub
    v.gsub(/(Leader|Creative|Logical|Tactical|Strategic|Holistic)/, '\1 :\1:').gsub(',',"\n")
  else
    v
  end
end
File.open('data/experts.txt', 'w+') { |f| f.write data.to_pretty_text }

Squib::Deck.new(cards: data.nrows) do
  use_layout file: 'layouts/experts.yml'
  background color: :white

  text str: data.name, layout: :name
  traits = %w(leader logical creative tactical strategic holistic)
  traits.each do |t|
    svg layout: "#{t}_img",
        file: data[t].map {|l| l.nil? ? nil : "bw/traits/#{t}.svg" }
    text str: data["#{t}Desc"], layout: "#{t}_text" do |embed|
      traits.each do |et|
        embed.svg key: ":#{et.capitalize}:",
                  file: "img/bw/traits/#{et}-embed.svg",
                  width: 40, height: 40
      end
    end
  end

  text str: data.power, layout: :power

  save_png prefix: 'expert_', trim: 37.5, trim_radius: 37.5
  save_sheet prefix: 'sheet_expert_', rows: 5, columns: 5
  cut_zone
  save_pdf file: 'experts.pdf', trim: 37.5
end