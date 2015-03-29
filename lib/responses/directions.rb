require 'responses/base'

module Responses
  class Directions < Base
    def initialize(response_hash)
      super

      @value = response_hash['directions']
    end
  end
end
