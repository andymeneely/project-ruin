notification :off

group :default do
  guard 'rake', :task => 'default' do
    watch %r{data/.*\.xlsx$}
    watch %r{data/.*\.csv$}
    watch %r{src/.*\.rb$}
    watch %r{.*\.yml}
    watch %r{img/.*\.svg$}
    watch %r{img/.*\.png$}
  end
end

group :opportunities do
  guard 'rake', :task => 'opportunities' do
    watch %r{data/.*\.xlsx$}
    watch %r{data/.*\.csv$}
    watch %r{src/.*\.rb$}
    watch %r{.*\.yml}
    watch %r{img/.*\.svg$}
    watch %r{img/.*\.png$}
  end
end
