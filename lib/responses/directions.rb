require 'responses/base'

module Responses
  class Directions < Base
    def initialize(response_hash)
      @value = response_hash['directions']
      @error = ''
    end
  end
end
