require 'responses/base'

module Responses
  class Result < Base
    def initialize(response_hash)
      super

      @value = response_hash['message']
    end
  end
end
