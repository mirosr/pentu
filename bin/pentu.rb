#!/usr/bin/env ruby

$LOAD_PATH.unshift('lib')
Dir.glob('./lib/**/*.rb') { |file| require file }

Application.run
