require 'squib'
require 'irb'
require 'rake/clean'

# Add Rake's clean & clobber tasks
CLEAN.include('_output/*').exclude('_output/gitkeep.txt')

desc 'By default, just build the deck without extra options'
task default: [
  :opportunities,
  :alien,
  :tree
]

desc 'Build everything, with all the options'
task all: [:with_pnp, :with_proofs, :default]

desc 'Build the opportunity deck'
task(:opportunities)     { load 'src/opportunities.rb' }

desc 'Build the alien ship deck'
task(:alien)     { load 'src/alien.rb' }
task(:attacks)     { load 'src/attacks.rb' }

desc 'Build the reasons deck'
task(:reasons)     { load 'src/reasons.rb' }

desc 'Build the helps'
task(:helps)     { load 'src/helps.rb' }

desc 'Build the expert deck'
task(:experts)     { load 'src/experts.rb' }


desc 'Run simulation of team compositions'
task(:sim_teams) { load 'src/sim_teams.rb'}

desc 'Enable proof lines for the next builds'
task(:with_proofs) do
  puts "Enabling proofing lines."
  Squib.enable_build_globally :proofs
end

desc 'Save brainstorming notes from SimpleNote'
task(:notes) { load 'src/notes.rb' }

desc 'Build production tree in Mermaid'
task(:tree) { load 'src/tree.rb' }
