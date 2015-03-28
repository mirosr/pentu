require 'uri'
require 'net/http'
require 'responses/directions'
require 'responses/error'

module ForensicsAdapter
  def self.directions
    uri = URI.parse('')

    response = Net::HTTP.get_response(uri)

    if response_successful?(response)
      Responses::Directions.load(response.body)
    else
      Responses::Error.load(response.body)
    end
  rescue => e
    Responses::Error.general(e.message)
  end

  def self.submit_location(x:, y:)
  end

  private

  def self.response_successful?(response)
    response.is_a?(Net::HTTPOK)
  end
end
