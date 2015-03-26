require 'minitest/autorun'

$LOAD_PATH.unshift('lib', 'spec')
if __FILE__ == $0
  Dir.glob('./lib/**/*.rb') { |file| require file }
  Dir.glob('./spec/**/*_spec.rb') { |file| require file }
else
  require File.basename($0, '.*').sub('_spec', '')
end
