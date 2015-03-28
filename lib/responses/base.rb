require 'json'

module Responses
  class Base
    attr_reader :value, :error

    def self.load(json)
      new(JSON.parse(json))
    end

    def initialize(response_hash)
      @value = response_hash
      @error = ''
    end
  end
end
