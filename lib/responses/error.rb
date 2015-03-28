require 'responses/base'

module Responses
  class Error < Base
    def initialize(response_hash)
      @value = ''
      @error = response_hash['error']
    end

    def self.general(message)
      load(%({"error":"#{message}"}))
    end
  end
end
