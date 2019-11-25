require 'open-uri'

# Save our notes from SimpleNote
print "Saving notes from SimpleNote..."
html = open('https://app.simplenote.com/p/ggPlM7').read
File.open('brainstorming.html', 'w+') do |f|
  f.write html
end
puts "done!"
