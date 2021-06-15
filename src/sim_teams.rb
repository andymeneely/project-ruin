require 'squib'

data = Squib.xlsx file: 'data/game.xlsx', sheet: 2
File.open('data/experts.txt', 'w+') { |f| f.write data.to_pretty_text }

class Expert
  attr_reader :name, :leader, :logical, :creative, :tactical, :strategic, :holistic, :power, :traits

  def initialize(row)
    @leader = row["leader"] == 'x'
    @logical = row["logical"] == 'x'
    @creative = row["creative"] == 'x'
    @tactical = row["tactical"] == 'x'
    @strategic = row["strategic"] == 'x'
    @holistic = row["holistic"] == 'x'
    @name = row["name"]
    @power = row["power"].to_i
    @traits = row.select {|key, value| value == 'x'}.map {|key, _v| key }
  end

  def to_s
    <<~EOS
      #{@name}:
        leader: #{@leader}
        logical: #{@logical}
        creative: #{@creative}
        tactical: #{@tactical}
        strategic: #{@strategic}
        holistic: #{@holistic}
        power: #{@power}
        traits: #{@traits}
    EOS
  end
end

experts = 0.upto(data.nrows - 1).map {|i| Expert.new(data.row(i)) }

def compute_power(team, task)
  power = team.reduce(0) {|sum, expert| sum + expert.power }
  team.each do |expert|
    # Leader -3 with another Leader
    if expert.leader
      power -= 5 if team.count { |e| e.leader } >= 2
    end

    # Logical +10 with Creative, +5 Linguist or Engineer
    if expert.logical
      power += 5 if task == 'Linguist' || task == 'Engineer'
      power += 10 if team.any? {|e| e.creative }
    end

    # Creative +5 for each other Creative, +5 for Engineer or Officer
    if expert.creative
      power += [0, team.count { |e| e.creative } - 1].max * 5
      power += 5 if task == 'Linguist' || task == 'Theologian'
    end

    # Holistic +2 for each Trait in team, +1 for Theologian
    if expert.holistic
      power += team.map {|e| e.traits}.flatten.uniq.count * 2
      power += 1 if task == 'Theologian'
    end

    # Tactical +7 with Strategic, +6 for Engineer or Officer
    if expert.tactical
      power += 5 if team.any? { |e| e.strategic }
      power += 5 if task == 'Officer' || task == 'Engineer'
    end

    # Strategist +3 for each other Creative, +5 for Officer
    if expert.strategic
      power += team.count {|e| e.creative } * 3
      power += 5 if task == 'Officer'
    end

  end
  return power
end

@trait_power = Hash.new(0)
@trait_count = Hash.new(0)
@task_power = Hash.new(0)
@expert_power = Hash.new(0)
@expert_count = Hash.new(0)
@top_experts = Set.new
hist = Hash.new(0)
def compute_trait_breakdown(team, power)
  team.each do |expert|
    expert.traits.each do |t|
      @trait_power[t] += power
      @trait_count[t] += 1
    end
  end
end

# team = experts[0..2]
# puts "Computing power for this team: "
# team.each {|e| puts e }
# puts compute_power(experts[0..2], 'Engineer')

tasks = %w(Engineer Theologian Officer Linguist)
8000.times do
  random_task = tasks.sample
  random_team = experts.sample(3)
  power = compute_power(random_team, task)
  hist[power] += 1
  @task_power[random_task] += power
  random_team.each do |e|
    @expert_power[e.name] += power
    @expert_count[e.name] += 1
  end
  compute_trait_breakdown(random_team, power)
  if(power >= 75)
    puts "Great team: #{power}, #{random_team.map {|e| e.name }.sort}"
    random_team.each {|e| @top_experts << e.name }
  end
end

puts "=" * 5
puts task
puts "=" * 5
sorted_hist = hist.sort_by { |(k, _v)|  k }
sorted_hist.each do |(k, v)|
  puts "#{k}: #{'*' * (v * 0.65)}"
end

puts "#" * 10
# puts @trait_power
# puts "-----"
# puts @trait_count
# puts "-----"
puts @trait_power.map {|t, p| "#{t}: #{'%.1f' % (p.to_f / @trait_count[t])}"}
puts "#" * 10
puts @task_power
puts "#" * 10
# puts @expert_power
# puts "-----"
# puts @expert_count
# puts "-----"
puts @expert_power.map {|t, p| "#{'%-7s' % t} #{'%.1f' % (p.to_f / @expert_count[t])}"}.sort

puts "=== Top experts (>=75) ==="
puts @top_experts.sort.join(' ')
