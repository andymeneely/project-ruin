require 'open-uri'

# Save our notes from SimpleNote
html = open('https://app.simplenote.com/p/ggPlM7').read
File.open('brainstorming.html', 'w') { |f| f.write html }
