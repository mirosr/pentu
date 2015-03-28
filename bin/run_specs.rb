#!/usr/bin/env ruby

if ARGV.empty?
  $LOAD_PATH.unshift('lib', 'spec')
  Dir.glob('./lib/**/*.rb') { |file| require file }
  Dir.glob('./spec/**/*_spec.rb') { |file| require file }
else
  working_dir = Dir.pwd
  ARGV.each do |file|
    spec_file = file
    path = File.dirname(file).sub('spec', 'lib')
    file = File.basename(file, '.*').sub('_spec', '')

    $LOAD_PATH.unshift('lib', 'spec')
    require File.join(working_dir, path, file)
    require File.join(working_dir, spec_file)
  end
end
